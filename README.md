# Open Brain — Express

> 🚀 **New here?** Everything you need is one prompt — **[START-HERE.md](START-HERE.md)**
> · 🇲🇽 **¿Empiezas ahora?** Un solo prompt — **[EMPIEZA-AQUI.md](EMPIEZA-AQUI.md)**

> 🇲🇽 **¿Español?** Empieza en **[Sesión 1 — Cuentas](Sesion-1-Cuentas.md)**.
> Todo el curso está en español: [Sesión 2](Sesion-2-Construir.md) ·
> [Sesión 2b](Sesion-2b-Telegram.md) · [Sesión 3](Sesion-3-Conectar.md).
> La aplicación detecta tu idioma sola, y tiene un botón EN/ES por si acaso.


A personal knowledge base you own. Save anything worth remembering — typed
notes, spoken thoughts, YouTube videos, PDFs, web articles — and it works out
what each thing is about and connects related ideas together on its own. Then
point Claude at it and it can search everything you have ever saved.

**Three sessions. Most of it happens while you watch.**

| | | |
|---|---|---|
| [Session 1](Session-1-Accounts.md) | Accounts and keys | 20–40 min, hands on |
| [Session 2](Session-2-Build.md) | Claude Code builds it | ~10 min of your input |
| [Session 2b](Session-2b-Telegram.md) | Text your brain *(optional)* | 20–30 min |
| [Session 3](Session-3-Connect.md) | Connect Claude, fill your brain | ~90 min, the good part |

**Start with [Session 1](Session-1-Accounts.md)** — and fork this repository
first, so the copy you build is your own.

---

## What you end up with

- A **web app** at your own URL, installable on your phone
- A **database you own** — export it any time, take it anywhere
- **Search by meaning.** Ask for "how do I get new clients" and find the note
  you wrote about customer acquisition, in different words
- **A graph that builds itself.** Every new thought finds related older ones and
  links to them. Things you forgot resurface on their own
- **Claude reading your brain** in any conversation, through MCP

---

## What it costs

The infrastructure is free — Supabase, Vercel and GitHub all have free tiers
this fits inside comfortably.

The one paid piece is an AI key from OpenRouter, used to tag your thoughts and
work out their meaning. Put $5–$10 on it and it will most likely last months.
Saving fifty things a month costs well under a dollar.

**Your Claude subscription does not cover this** — that pays for you talking to
Claude, not for your software calling an AI on its own. Different product,
separate bill. Session 1 explains this properly.

---

## Not locked in

Every AI call goes through one file — [`supabase/functions/_shared/ai.ts`](supabase/functions/_shared/ai.ts).
Change the model names at the top and your whole brain switches providers.
Nothing else changes.

The Claude connection uses MCP, an open standard. If you move to a different AI
that speaks it, you point that one at the same address. Your data never moves,
because it was never anywhere but your own database.

---

## What's in here

```
migration.sql              The database: tables, login protection, search, graph
index.html                 The app
config.js                  Your Supabase details (filled in during Session 2)
manifest.json, sw.js       Makes it installable on a phone

supabase/functions/
  _shared/ai.ts            Every AI call. Change models here and nowhere else.
  enrich-thought           Tags, embeds and links each thought automatically
  capture-youtube          Fetches real transcripts, four different ways
  capture-url              Reads any web page server-side
  search-brain             Meaning-based search
  open-brain-mcp           What Claude Desktop talks to
  telegram-bot             Text your brain from your phone (optional)
```

---

## A few things worth knowing

**Your brain is private.** The database refuses to return anything unless you
are logged in, and only ever returns your own rows. The key in `config.js` is
public on purpose and cannot read anything by itself.

**Deploy the MCP server with `--no-verify-jwt`.** It is the one exception, and
the reason is explained at the top of that file. Without the flag Claude Desktop
fails to connect with no useful error.

**YouTube is deliberately complicated.** YouTube hides subtitles from servers,
so `capture-youtube` tries several routes and takes the first that works. If you
find yourself "simplifying" it, read the comments at the top first.

**If a deploy fails, let Claude Code fix it.** Services change their APIs. This
repository is not actively maintained — it is meant to be repaired in place, and
Claude Code is told it is allowed to do that.

---

## Credit

Built from a working system by the author, who runs a version of this with
thousands of thoughts and tens of thousands of automatic connections. This is a
stripped-down version of that, meant to be stood up in an afternoon.

There is also a longer seven-level course that teaches you to build all of this
yourself, step by step, rather than having it installed for you. This version is
for people who want the thing working. That version is for people who want to
understand every piece.
