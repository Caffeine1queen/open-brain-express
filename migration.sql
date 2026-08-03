-- ============================================================================
-- OPEN BRAIN — EXPRESS SCHEMA
-- Run this ONE TIME in the Supabase SQL Editor.
-- Supabase.com -> your project -> SQL Editor -> New query -> paste -> Run.
--
-- This creates everything at once: the thoughts table, login-protected access,
-- semantic search, and the connection graph. Unlike the step-by-step course,
-- nothing here needs to be backfilled later because the full schema exists
-- before the first thought is ever saved.
-- ============================================================================


-- ---------------------------------------------------------------------------
-- 1. EXTENSIONS
-- pgvector lets Postgres store "embeddings" — the numeric fingerprint of a
-- thought's meaning — and compare them. This is what makes search understand
-- meaning instead of just matching words.
-- ---------------------------------------------------------------------------
create extension if not exists vector;


-- ---------------------------------------------------------------------------
-- 2. THOUGHTS TABLE
-- One row per captured thought, whatever the source.
-- user_id ties each row to the person who saved it. That column is what makes
-- the security policies further down actually work.
-- ---------------------------------------------------------------------------
create table if not exists thoughts (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references auth.users(id) on delete cascade,
  content     text not null,

  -- where it came from: text | voice | youtube | pdf | url | telegram | digest
  source      text not null default 'text',

  -- filled in automatically by the enrich-thought function, a few seconds
  -- after the row is inserted
  tags        text[] default '{}',
  category    text,
  summary     text,
  embedding   vector(1536),
  enriched_at timestamptz,

  -- free-form extras: video title, source URL, filename, etc.
  metadata    jsonb default '{}'::jsonb,

  created_at  timestamptz not null default now()
);

create index if not exists idx_thoughts_user       on thoughts(user_id);
create index if not exists idx_thoughts_created    on thoughts(created_at desc);
create index if not exists idx_thoughts_source     on thoughts(source);

-- HNSW index: makes "find the most similar thoughts" fast even with thousands
-- of rows. Without it every search compares against every single row.
create index if not exists idx_thoughts_embedding
  on thoughts using hnsw (embedding vector_cosine_ops);


-- ---------------------------------------------------------------------------
-- 3. THOUGHT LINKS — the graph
-- Each row is a connection between two thoughts that mean similar things.
-- Created automatically whenever a thought is saved.
-- ---------------------------------------------------------------------------
create table if not exists thought_links (
  id                uuid primary key default gen_random_uuid(),
  user_id           uuid not null references auth.users(id) on delete cascade,
  source_thought_id uuid not null references thoughts(id) on delete cascade,
  target_thought_id uuid not null references thoughts(id) on delete cascade,
  similarity_score  float not null,
  link_type         text not null default 'semantic',
  created_at        timestamptz not null default now()
);

-- Block the same link being stored twice in the same direction (A->B)
create unique index if not exists idx_links_pair
  on thought_links(source_thought_id, target_thought_id);

-- Block the same link stored backwards (if A->B exists, refuse B->A).
-- LEAST/GREATEST sorts the two ids into a consistent order first, so both
-- directions collapse to the same index entry. Without this you get double
-- the edges and confusing results — this was learned the hard way.
create unique index if not exists idx_links_canonical
  on thought_links (
    least(source_thought_id::text, target_thought_id::text),
    greatest(source_thought_id::text, target_thought_id::text)
  );

create index if not exists idx_links_source on thought_links(source_thought_id);
create index if not exists idx_links_target on thought_links(target_thought_id);
create index if not exists idx_links_user   on thought_links(user_id);

-- A thought can never link to itself
do $$
begin
  if not exists (
    select 1 from pg_constraint where conname = 'no_self_links'
  ) then
    alter table thought_links
      add constraint no_self_links
      check (source_thought_id != target_thought_id);
  end if;
end $$;


-- ---------------------------------------------------------------------------
-- 4. SECURITY — this is the part that matters
--
-- Row Level Security means the database itself refuses to hand out rows that
-- do not belong to the person asking. Policies below grant access ONLY to
-- logged-in users, and ONLY to their own rows.
--
-- Note what is NOT here: no policy granting anything to "anon". A visitor who
-- is not logged in gets nothing, even if they have your app's public key.
--
-- Your edge functions (Telegram bot, MCP server, enrichment) use the service
-- role key, which bypasses RLS entirely. That is intentional and correct —
-- that key lives only in Supabase secrets and never reaches a browser.
-- ---------------------------------------------------------------------------
alter table thoughts      enable row level security;
alter table thought_links enable row level security;

drop policy if exists "own_thoughts_select" on thoughts;
create policy "own_thoughts_select" on thoughts
  for select to authenticated
  using (auth.uid() = user_id);

drop policy if exists "own_thoughts_insert" on thoughts;
create policy "own_thoughts_insert" on thoughts
  for insert to authenticated
  with check (auth.uid() = user_id);

drop policy if exists "own_thoughts_update" on thoughts;
create policy "own_thoughts_update" on thoughts
  for update to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "own_thoughts_delete" on thoughts;
create policy "own_thoughts_delete" on thoughts
  for delete to authenticated
  using (auth.uid() = user_id);

drop policy if exists "own_links_select" on thought_links;
create policy "own_links_select" on thought_links
  for select to authenticated
  using (auth.uid() = user_id);

drop policy if exists "own_links_insert" on thought_links;
create policy "own_links_insert" on thought_links
  for insert to authenticated
  with check (auth.uid() = user_id);

drop policy if exists "own_links_delete" on thought_links;
create policy "own_links_delete" on thought_links
  for delete to authenticated
  using (auth.uid() = user_id);


-- ---------------------------------------------------------------------------
-- 5. SEMANTIC SEARCH
-- Takes the numeric fingerprint of a search phrase and returns the thoughts
-- whose meaning is closest to it.
--
-- The <=> operator is pgvector's cosine distance. Subtracting from 1 turns it
-- into a similarity where higher = more alike.
--
-- Threshold is 0.3 here (cast a wide net for search) versus 0.5 for the graph
-- below (links should be stronger connections than search hits).
-- ---------------------------------------------------------------------------
create or replace function search_thoughts_semantic(
  p_user_id        uuid,
  query_embedding  vector(1536),
  match_threshold  float default 0.3,
  match_count      int   default 10
)
returns table (
  id         uuid,
  content    text,
  source     text,
  category   text,
  tags       text[],
  created_at timestamptz,
  similarity float
)
language plpgsql
stable
as $$
begin
  return query
    select
      t.id, t.content, t.source, t.category, t.tags, t.created_at,
      (1 - (t.embedding <=> query_embedding))::float as similarity
    from thoughts t
    where t.user_id = p_user_id
      and t.embedding is not null
      and (1 - (t.embedding <=> query_embedding)) > match_threshold
    order by t.embedding <=> query_embedding
    limit match_count;
end;
$$;


-- ---------------------------------------------------------------------------
-- 6. FIND NEIGHBOURS — used to build the graph
--
-- VOLATILE, not STABLE, on purpose. This runs immediately after a new thought
-- is inserted. A STABLE function may read an older snapshot of the table that
-- does not yet contain the row we just saved. VOLATILE always sees current data.
-- ---------------------------------------------------------------------------
create or replace function find_links_for_thought(
  p_user_id        uuid,
  source_id        uuid,
  source_embedding vector(1536),
  match_threshold  float default 0.5,
  match_count      int   default 5
)
returns table (
  target_id  uuid,
  similarity float
)
language plpgsql
volatile
as $$
begin
  return query
    select
      t.id as target_id,
      (1 - (t.embedding <=> source_embedding))::float as similarity
    from thoughts t
    where t.user_id = p_user_id
      and t.id != source_id
      and t.embedding is not null
      and (1 - (t.embedding <=> source_embedding)) > match_threshold
    order by t.embedding <=> source_embedding
    limit match_count;
end;
$$;


-- ---------------------------------------------------------------------------
-- 7. KEYWORD SEARCH FALLBACK
-- Used when a thought has no embedding yet (the first few seconds after
-- saving), or if the embedding service is unavailable.
-- ---------------------------------------------------------------------------
create or replace function search_thoughts_keyword(
  p_user_id   uuid,
  query_text  text,
  match_count int default 10
)
returns table (
  id         uuid,
  content    text,
  source     text,
  category   text,
  tags       text[],
  created_at timestamptz
)
language plpgsql
stable
as $$
begin
  return query
    select t.id, t.content, t.source, t.category, t.tags, t.created_at
    from thoughts t
    where t.user_id = p_user_id
      and t.content ilike '%' || query_text || '%'
    order by t.created_at desc
    limit match_count;
end;
$$;


-- ---------------------------------------------------------------------------
-- DONE.
-- Expected result: "Success. No rows returned."
--
-- Quick check that it worked — run this separately:
--   select table_name from information_schema.tables
--   where table_schema = 'public';
-- You should see: thoughts, thought_links
-- ---------------------------------------------------------------------------
