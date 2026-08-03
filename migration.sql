-- ============================================================================
-- OPEN BRAIN — EXPRESS SCHEMA
-- Run this ONE TIME in the Supabase SQL Editor.
-- Supabase.com -> your project -> SQL Editor -> New query -> paste -> Run.
--
-- This creates everything at once: the thoughts table, login-protected access,
-- semantic search, and the connection graph.
--
-- SAFE TO RUN ON AN EXISTING BRAIN. If you already built one following the
-- seven-level course, this adds only what is missing and does not touch a
-- single thought you have saved. See section 5 for the one extra step you
-- will need afterwards.
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
-- Written so it is safe to run on a brand new project OR on a brain you already
-- built following the seven-level course. If the table already exists, only the
-- missing pieces get added and nothing you have saved is touched.
create table if not exists thoughts (
  id          uuid primary key default gen_random_uuid(),
  content     text not null,
  created_at  timestamptz not null default now()
);

-- Add every column individually rather than assuming the table is new. On a
-- fresh project these all get created; on an existing brain, only whatever is
-- missing does.
alter table thoughts add column if not exists user_id     uuid references auth.users(id) on delete cascade;
alter table thoughts add column if not exists source      text not null default 'text';
alter table thoughts add column if not exists tags        text[] default '{}';
alter table thoughts add column if not exists category    text;
alter table thoughts add column if not exists summary     text;
alter table thoughts add column if not exists embedding   vector(1536);
alter table thoughts add column if not exists enriched_at timestamptz;
alter table thoughts add column if not exists metadata    jsonb default '{}'::jsonb;

-- NOTE ON user_id: it is deliberately nullable here, not "not null".
--
-- If you are upgrading an existing brain, your old thoughts have no owner yet —
-- they were saved before there was any such thing as logging in. Forcing the
-- column to be non-null would refuse to add it at all, and the whole script
-- would fail.
--
-- Section 5 below shows you how to claim those old thoughts once you have
-- created your login. Until you do that, they will not appear in the app: the
-- security rules only return rows that belong to you, and rows with no owner
-- belong to nobody. THEY ARE NOT DELETED. They are sitting in the table waiting
-- to be claimed, and you can see them any time in the Supabase Table Editor.

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
  source_thought_id uuid not null references thoughts(id) on delete cascade,
  target_thought_id uuid not null references thoughts(id) on delete cascade,
  similarity_score  float not null,
  created_at        timestamptz not null default now()
);

-- Same upgrade-safe approach as the thoughts table above
alter table thought_links add column if not exists user_id   uuid references auth.users(id) on delete cascade;
alter table thought_links add column if not exists link_type text not null default 'semantic';

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

-- If you are upgrading a brain built with the seven-level course, it had a rule
-- that let ANYONE with your public key read, change and delete everything.
-- Remove it. These names cover both versions of that rule.
drop policy if exists "allow_all" on thoughts;
drop policy if exists "temporary_open_access" on thoughts;
drop policy if exists "own_thoughts" on thoughts;
drop policy if exists "allow_all" on thought_links;

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
-- 5. UPGRADING? CLAIM YOUR EXISTING THOUGHTS
--
-- SKIP THIS ENTIRELY if this is a brand new brain. It only matters if you had
-- thoughts saved before you had a login.
--
-- Those old thoughts have no owner. The security rules above only return rows
-- that belong to you, so right now they will not show up in the app. They are
-- NOT lost — check the Table Editor and you will see them all sitting there.
--
-- To claim them:
--
--   STEP 1: open your app and create your login first. You cannot own anything
--           until an account exists.
--
--   STEP 2: come back here and run the two statements below.
--
-- Check how many are waiting:
--
--   select count(*) from thoughts where user_id is null;
--
-- Then claim them. Replace the email with the one you just signed up with:
--
--   update thoughts
--   set user_id = (select id from auth.users where email = 'you@example.com')
--   where user_id is null;
--
--   update thought_links
--   set user_id = (select id from auth.users where email = 'you@example.com')
--   where user_id is null;
--
-- Refresh the app and everything you ever saved is back — now protected by your
-- login instead of open to anyone who found the address.
--
-- Old thoughts will have no tags, category or meaning-fingerprint, because they
-- were saved before any of that existed. They are still searchable by keyword.
-- To bring them fully up to date, ask Claude Code: "backfill enrichment and
-- embeddings for my thoughts that don't have them yet."
-- ---------------------------------------------------------------------------


-- ---------------------------------------------------------------------------
-- 6. WHAT THIS COSTS YOU
--
-- Every time your brain tags a thought or works out its meaning, it makes a
-- small paid request to an AI. Each one is a fraction of a cent. This table
-- records them so the number stops being a promise somebody made you and
-- becomes something you can look at.
--
-- Nothing here can break a save: if writing one of these rows fails, the
-- thought is already stored and the failure is ignored.
-- ---------------------------------------------------------------------------
create table if not exists llm_usage (
  id                uuid primary key default gen_random_uuid(),
  user_id           uuid not null references auth.users(id) on delete cascade,
  kind              text not null default 'chat',   -- chat | embedding
  model             text,
  source            text,                            -- which function spent it
  prompt_tokens     integer default 0,
  completion_tokens integer default 0,
  cost_usd          numeric(12,8) default 0,
  created_at        timestamptz not null default now()
);

create index if not exists idx_usage_user_time on llm_usage(user_id, created_at desc);

alter table llm_usage enable row level security;

drop policy if exists "own_usage_select" on llm_usage;
create policy "own_usage_select" on llm_usage
  for select to authenticated
  using (auth.uid() = user_id);

-- Spending so far this calendar month, plus an all-time figure.
create or replace function my_spend()
returns table (
  month_usd    numeric,
  month_calls  bigint,
  total_usd    numeric,
  total_calls  bigint
)
language plpgsql
stable
as $$
begin
  -- Runs as the caller, so row level security applies and they can only ever
  -- sum their own rows. The explicit user_id filter below is belt and braces.
  return query
    select
      coalesce(sum(u.cost_usd) filter (
        where u.created_at >= date_trunc('month', now())), 0)::numeric,
      count(*) filter (
        where u.created_at >= date_trunc('month', now()))::bigint,
      coalesce(sum(u.cost_usd), 0)::numeric,
      count(*)::bigint
    from llm_usage u
    where u.user_id = auth.uid();
end;
$$;


-- ---------------------------------------------------------------------------
-- 7. SEMANTIC SEARCH
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
-- 8. FIND NEIGHBOURS — used to build the graph
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
-- 9. KEYWORD SEARCH FALLBACK
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
