// ============================================================================
// SHARED AI HELPERS
// ============================================================================
// Every AI call in Open Brain goes through this one file — both the "thinking"
// calls (summarising, tagging) and the "meaning fingerprint" calls (embeddings).
//
// WHY ONE FILE:
//   1. To switch AI providers you edit here and nowhere else.
//   2. It is imported directly by the other functions rather than being its own
//      deployed service. That matters: a function calling another function over
//      HTTP needs authentication headers, which is a classic source of silent
//      401 failures. Importing a module skips that problem entirely.
//
// TO CHANGE MODELS: edit the three constants below. Nothing else changes.
// ============================================================================

const OPENROUTER_KEY = Deno.env.get('OPENROUTER_API_KEY') ?? ''

// ---------------------------------------------------------------------------
// MODEL CHOICES — the only place these are named.
//
// CHAT_MODEL does the tagging and summarising. It runs on every save, so it
// should be cheap and fast. A small model is the right call here.
//
// EMBEDDING_MODEL turns text into 1536 numbers representing its meaning.
// IMPORTANT: if you change this, the new model MUST also output 1536 numbers,
// or the database column will reject it and you will need a new migration.
// ---------------------------------------------------------------------------
const CHAT_MODEL = Deno.env.get('LLM_MODEL') ?? 'anthropic/claude-haiku-4.5'
const EMBEDDING_MODEL = Deno.env.get('EMBEDDING_MODEL') ?? 'openai/text-embedding-3-small'
const EMBEDDING_DIMENSIONS = 1536

const OPENROUTER_CHAT_URL = 'https://openrouter.ai/api/v1/chat/completions'
const OPENROUTER_EMBED_URL = 'https://openrouter.ai/api/v1/embeddings'


// ---------------------------------------------------------------------------
// CORS headers — lets your web app talk to these functions from a browser.
// ---------------------------------------------------------------------------
export const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization, apikey',
}

export function jsonResponse(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
  })
}


// ---------------------------------------------------------------------------
// COST LOGGING
//
// Records what each AI call cost, so the app can show a real number instead of
// an estimate.
//
// SAFETY RULE: this must never affect anything. It is fired without being
// awaited and every failure is swallowed. If the logging breaks, or the table
// does not exist, or the network hiccups, the capture that triggered it still
// succeeds and the user never sees a thing. Cost visibility is a nice-to-have;
// saving the thought is not.
// ---------------------------------------------------------------------------
function logUsage(entry: {
  userId?: string
  kind: 'chat' | 'embedding'
  model: string
  source?: string
  promptTokens?: number
  completionTokens?: number
  costUsd?: number
}): void {
  if (!entry.userId) return   // nothing to attribute it to

  const url = Deno.env.get('SUPABASE_URL')
  const key = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')
  if (!url || !key) return

  // Deliberately not awaited.
  fetch(`${url}/rest/v1/llm_usage`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'apikey': key,
      'Authorization': `Bearer ${key}`,
      'Prefer': 'return=minimal',
    },
    body: JSON.stringify({
      user_id: entry.userId,
      kind: entry.kind,
      model: entry.model,
      source: entry.source ?? null,
      prompt_tokens: entry.promptTokens ?? 0,
      completion_tokens: entry.completionTokens ?? 0,
      cost_usd: entry.costUsd ?? 0,
    }),
    signal: AbortSignal.timeout(5000),
  }).catch(() => { /* deliberately ignored — see safety rule above */ })
}


// ---------------------------------------------------------------------------
// callLLM — ask the AI a question, get text back.
//
// Returns null instead of throwing when something goes wrong. Callers should
// carry on without the AI rather than failing the whole save. A thought saved
// without tags is far better than a thought that never saved.
// ---------------------------------------------------------------------------
export async function callLLM(opts: {
  prompt: string
  systemPrompt?: string
  maxTokens?: number
  timeoutMs?: number
  userId?: string      // who to bill this to, for the cost display
  source?: string      // which function spent it
}): Promise<string | null> {
  if (!OPENROUTER_KEY) {
    console.error('[ai] OPENROUTER_API_KEY is not set — skipping LLM call')
    return null
  }

  const messages: Array<{ role: string; content: string }> = []
  if (opts.systemPrompt) messages.push({ role: 'system', content: opts.systemPrompt })
  messages.push({ role: 'user', content: opts.prompt })

  try {
    const res = await fetch(OPENROUTER_CHAT_URL, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${OPENROUTER_KEY}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        model: CHAT_MODEL,
        messages,
        max_tokens: opts.maxTokens ?? 1024,
        // Asks OpenRouter to report what this call actually cost, rather than
        // us guessing from a price list that goes stale.
        usage: { include: true },
      }),
      signal: AbortSignal.timeout(opts.timeoutMs ?? 30_000),
    })

    if (!res.ok) {
      const errText = await res.text().catch(() => '')
      console.error(`[ai] LLM HTTP ${res.status}: ${errText.slice(0, 300)}`)
      return null
    }

    const data = await res.json()
    const text = data?.choices?.[0]?.message?.content
    if (typeof text !== 'string' || !text.trim()) {
      console.error('[ai] LLM returned no usable text')
      return null
    }

    logUsage({
      userId: opts.userId,
      kind: 'chat',
      model: CHAT_MODEL,
      source: opts.source,
      promptTokens: data?.usage?.prompt_tokens ?? 0,
      completionTokens: data?.usage?.completion_tokens ?? 0,
      costUsd: Number(data?.usage?.cost ?? 0),
    })

    return text.trim()
  } catch (err) {
    console.error('[ai] LLM call failed:', String(err))
    return null
  }
}


// ---------------------------------------------------------------------------
// callLLMForJSON — same as above, but insists on a JSON object back.
//
// Models sometimes wrap JSON in explanation or markdown fences. This digs the
// object out rather than giving up, because a parse failure here would mean a
// thought never gets tagged.
// ---------------------------------------------------------------------------
export async function callLLMForJSON<T = Record<string, unknown>>(opts: {
  prompt: string
  systemPrompt?: string
  maxTokens?: number
  userId?: string
  source?: string
}): Promise<T | null> {
  const raw = await callLLM(opts)
  if (!raw) return null

  // Straight parse first
  try {
    return JSON.parse(raw) as T
  } catch { /* fall through */ }

  // Strip ```json fences if present
  const fenced = raw.match(/```(?:json)?\s*([\s\S]*?)```/)
  if (fenced) {
    try {
      return JSON.parse(fenced[1].trim()) as T
    } catch { /* fall through */ }
  }

  // Last resort: grab the outermost { ... }
  const braced = raw.match(/\{[\s\S]*\}/)
  if (braced) {
    try {
      return JSON.parse(braced[0]) as T
    } catch { /* fall through */ }
  }

  console.error('[ai] Could not parse JSON from LLM. First 300 chars:', raw.slice(0, 300))
  return null
}


// ---------------------------------------------------------------------------
// generateEmbedding — turn text into its meaning fingerprint.
//
// Returns null on any failure. The caller saves the thought anyway; it simply
// will not be searchable by meaning or linked into the graph until an
// embedding exists.
//
// Long text is trimmed first. Embedding models have an input limit, and the
// first few thousand characters carry the gist well enough for search.
// ---------------------------------------------------------------------------
export async function generateEmbedding(
  text: string,
  attribution?: { userId?: string; source?: string }
): Promise<number[] | null> {
  if (!OPENROUTER_KEY) {
    console.error('[ai] OPENROUTER_API_KEY is not set — skipping embedding')
    return null
  }

  const input = text.replace(/\s+/g, ' ').trim().slice(0, 8000)
  if (!input) return null

  try {
    const res = await fetch(OPENROUTER_EMBED_URL, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${OPENROUTER_KEY}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ model: EMBEDDING_MODEL, input }),
      signal: AbortSignal.timeout(20_000),
    })

    if (!res.ok) {
      const errText = await res.text().catch(() => '')
      console.error(`[ai] Embedding HTTP ${res.status}: ${errText.slice(0, 300)}`)
      return null
    }

    const data = await res.json()
    const embedding = data?.data?.[0]?.embedding

    if (!Array.isArray(embedding)) {
      console.error('[ai] Embedding response had no vector')
      return null
    }

    // Guard against a model swap that changes the vector size. The database
    // column is fixed at 1536 and would reject anything else with a confusing
    // error — this catches it here with a clear message instead.
    if (embedding.length !== EMBEDDING_DIMENSIONS) {
      console.error(
        `[ai] Embedding size mismatch: got ${embedding.length}, expected ${EMBEDDING_DIMENSIONS}. ` +
        `Model "${EMBEDDING_MODEL}" does not match the database column. ` +
        `Either switch back to a 1536-dimension model or run a migration to change the column.`
      )
      return null
    }

    logUsage({
      userId: attribution?.userId,
      kind: 'embedding',
      model: EMBEDDING_MODEL,
      source: attribution?.source,
      promptTokens: data?.usage?.prompt_tokens ?? 0,
      costUsd: Number(data?.usage?.cost ?? 0),
    })

    return embedding as number[]
  } catch (err) {
    console.error('[ai] Embedding call failed:', String(err))
    return null
  }
}
