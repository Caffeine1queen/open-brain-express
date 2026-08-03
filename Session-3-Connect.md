# Session 3 — Connect Claude, then fill your brain

**Time: about 90 minutes. Half of it is the fun part.**

Two things happen here. First you connect Claude Desktop to your brain, which
takes about fifteen minutes. Then you fill it up — because a brain with three
things in it is not impressive, and a brain with thirty is.

---

## Part A — Connect Claude (paste into Claude Code)

```
Connect this person's Open Brain to their Claude Desktop app.

You need two values, both of which should be in `.env.local` from Session 2:
  - Their Supabase project ref
  - Their MCP_ACCESS_KEY

If either is missing, ask for it.

=== STEP 1 — CHECK THE SERVER RESPONDS ===

Before touching Claude Desktop, confirm the MCP server is alive:

  curl -X POST https://THEIR_REF.supabase.co/functions/v1/open-brain-mcp ^
    -H "Content-Type: application/json" ^
    -H "Authorization: Bearer THEIR_MCP_ACCESS_KEY" ^
    -d "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"tools/list\",\"params\":{}}"

(On Mac or Linux use \ instead of ^ for line continuation.)

You want a response listing three tools: search_brain, list_recent, add_thought.

If you get 401: the key does not match what is in Supabase secrets.
If you get a Supabase gateway error rather than your own 401: the function was
deployed without --no-verify-jwt. Redeploy it with that flag.

=== STEP 2 — WRITE THE CLAUDE DESKTOP CONFIG ===

Find the config file:
  Windows: %APPDATA%\Claude\claude_desktop_config.json
  Mac:     ~/Library/Application Support/Claude/claude_desktop_config.json

If it does not exist, create it. If it does exist, MERGE into it — do not
overwrite it, they may have other MCP servers configured already.

The entry to add:

{
  "mcpServers": {
    "open-brain": {
      "command": "npx",
      "args": [
        "-y",
        "mcp-remote",
        "https://THEIR_REF.supabase.co/functions/v1/open-brain-mcp",
        "--header",
        "Authorization:${AUTH_TOKEN}"
      ],
      "env": {
        "AUTH_TOKEN": "Bearer THEIR_MCP_ACCESS_KEY"
      }
    }
  }
}

Note the shape of that header: `Authorization:${AUTH_TOKEN}` with no space after
the colon, and the actual value in `env`. This looks odd but it is deliberate —
arguments containing spaces get mangled on Windows, and this form avoids it.

Validate the file is proper JSON before saving. A stray comma here means Claude
Desktop starts with no tools and says nothing about why.

=== STEP 3 — RESTART CLAUDE DESKTOP ===

Tell them to quit Claude Desktop COMPLETELY — not just close the window. On
Windows, right-click the system tray icon and choose Quit. On Mac, Cmd+Q.
Then reopen it.

Have them start a new conversation and check for a tools or slider icon near
the message box. Clicking it should list open-brain.

=== STEP 4 — TEST IT ===

Have them ask Claude Desktop, in their own words:

  "Search my brain for [something they saved in Session 2]"

Claude should call search_brain and return their own thought.

If nothing happens, check in this order:
  1. Was Claude Desktop fully quit and reopened?
  2. Is the JSON valid?
  3. Does the curl test from Step 1 still work?
  4. Look at Claude Desktop's MCP logs:
     Windows: %APPDATA%\Claude\logs\
     Mac:     ~/Library/Logs/Claude/
```

---

## Part B — Fill your brain

This is the part people skip, and it is the part that decides whether you keep
using this or forget about it by Friday.

Right now your brain has a handful of test entries. Searching it is
underwhelming, because there is nothing in there worth finding. **Twenty minutes
of feeding it changes that completely.**

Do all three of the following. In that order.

### 1. Five to eight YouTube videos — about two minutes

Think of videos you have actually watched in the last few months that taught you
something. A talk, a tutorial, an interview, a documentary.

Find them in your YouTube history, paste each link into the **YouTube** tab.

This is the fastest way to fill a brain with substance. Each video becomes
several paragraphs of real content — worth far more than a dozen one-line notes.

### 2. Three to five links — about two minutes

Articles you bookmarked and meant to read. Blog posts you keep referring back
to. Anything in an open tab right now.

Paste each into the **Link** tab.

### 3. A fifteen-minute conversation — the important one

This is where it becomes *yours* rather than a pile of other people's content.

Open Claude Desktop — it can now write into your brain — and paste this:

```
Interview me to fill my Open Brain with what I actually know and care about.

Ask me one question at a time and wait for my answer. After each answer, use the
add_thought tool to save it in my own words — cleaned up, but not rewritten into
corporate language.

Work through roughly these areas, following anything interesting I say:
- What I am working on right now, and what is hard about it
- Something I learned recently that changed how I think
- A problem I have been chewing on without resolving
- Something I find myself explaining to people over and over
- What I want to be better at a year from now
- Opinions I hold that people around me disagree with

Keep going for about fifteen minutes. Do not summarise at the end — just save as
we go, and tell me how many thoughts we captured.
```

Talk normally. Do not try to be impressive. The half-formed thoughts are the
valuable ones — those are exactly what you will have forgotten in six months.

---

## Now use it

You should have thirty-something thoughts. Try these in Claude Desktop:

> **"What have I been thinking about lately?"**
> It reads your recent captures and tells you — often noticing themes you had
> not noticed yourself.

> **"Search my brain for how to get new clients"** — using words you never
> typed. It should still find your notes about customer acquisition, marketing,
> or sales. That is meaning-based search working.

> **"What connects to the thought I saved about [topic]?"**
> This is the graph. Ideas you forgot resurface because they are linked to what
> you are thinking about now.

> **"Based on everything in my brain, what am I avoiding?"**
> Ask this one when you have a bit more in there. It is uncomfortable.

---

## Keeping it alive

The brain is only as good as what goes into it. The habit that makes it work:

**When you finish something worth remembering — a video, an article, a
conversation, an idea in the shower — put it in.** Ten seconds. The phone app
makes this easy: open the URL on your phone and choose "Add to Home Screen".

In three months you will have something no AI can give you from its own
training: everything *you* found worth keeping, searchable by meaning, connected
to itself, and readable by whatever AI you happen to be using at the time.

That is the whole idea. It is yours.
