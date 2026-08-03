# Start here

*[Versión en español: EMPIEZA-AQUI.md](EMPIEZA-AQUI.md)*

---

## Step 0 — You need three things installed

This is the only part that cannot be automated, because these are programs that
have to exist before Claude can help you. About 15 minutes, once ever.

**If you have done this before, skip to Step 1.**

### 1. Claude Code
[claude.ai/download](https://claude.ai/download) — download, install, sign in.
This is the app that will build everything.

You need a Claude subscription (Pro or Max) to use it.

### 2. Node.js
[nodejs.org](https://nodejs.org) — download the version marked **LTS**. Install
it accepting all the defaults.

### 3. Git
[git-scm.com/downloads](https://git-scm.com/downloads) — install accepting all
the defaults.

*(On a Mac, typing `git --version` in Terminal often installs it for you.)*

### Check it worked

Open a command window:
- **Windows:** press Start, type `PowerShell`, Enter
- **Mac:** press Cmd+Space, type `Terminal`, Enter

Type these two lines, one at a time. You want version numbers, not errors:

```bash
git --version
```

```bash
node --version
```

If both answer with a number, you are set. If either errors, reinstall that one
and try again.

---

## Step 1 — One prompt

**Open Claude Code, pick or create a folder (the Desktop is fine), copy the
whole block below, paste it, press Enter.**

That is the only thing you need to do to begin. Claude handles the rest and will
ask you for whatever it needs.

```
Hello. You are going to walk me through building my Open Brain today.

WHO I AM: I am not technical. Do not assume what I already have installed or
which accounts already exist — check, and ask me. I might have everything, I
might have nothing, I might have done some of it weeks ago and forgotten.

HOW I WANT YOU TO WORK WITH ME:

- Talk like a person. No jargon unless you explain it immediately.
- Do the work yourself. Do not explain at length what you are about to do —
  do it, then tell me what happened, in one line.
- When you need something from me, ask for ONE thing and wait.
- Tell me early, and mean it, that I can ask you anything at any point — what a
  word means, what you just did, whether something is safe. Learning to ask you
  is the actual point of this exercise.
- If I go quiet for several steps, check whether I am following.
- If I paste an error or a screenshot, treat it as completely normal.
- NEVER repeat a key or password of mine back into the chat. Put it where it
  belongs and say "saved", nothing more.

YOU ARE AUTHORISED TO REPAIR: if a command fails, read the error, work out the
cause, fix the file, and try again. Do not stop and ask me what to do — I will
not know. Only stop if you have tried twice and are genuinely stuck, and then
explain it to me in plain language.

=== WHAT WE ARE DOING TODAY ===

Building a personal knowledge base that belongs to me: a web app where I save
notes, voice, YouTube videos, PDFs and articles; a database that is mine; and at
the end, Claude Desktop reading everything I have saved.

=== START LIKE THIS ===

STEP 1 — Check what I already have. Run these and tell me the result:
  git --version
  node --version

If either fails, help me install it before continuing.

STEP 2 — Ask me, one at a time, which of these accounts I already have:
  GitHub, Supabase, Vercel, OpenRouter, Claude Desktop

STEP 3 — Help me create ONLY what is missing. The full instructions are here,
read them before guiding me:
  https://raw.githubusercontent.com/King-Tuerto/open-brain-express/main/Session-1-Accounts.md

Pay particular attention to three things in that document:
  - I need to "fork" the repository to my own GitHub account
  - "Confirm email" must be switched OFF in Supabase (Authentication -> Sign In
    / Providers -> Email), or I will not be able to log in to my own app
  - The OpenRouter key is the only part that costs money. Explain properly what
    it is and what it will cost me before I put a card in.

STEP 4 — Once I have everything, clone MY fork (not the original) and go into
the folder:
  git clone https://github.com/MY_USERNAME/open-brain-express
  cd open-brain-express

STEP 5 — Open the file Session-2-Build.md inside that folder, follow its
instructions exactly, and build my brain.

When Session 2 is done, continue with Session-3-Connect.md.

Note: always use `npx supabase` for Supabase commands. Do NOT use
`npm install -g supabase` — Supabase removed support for global installs and
that command fails.

Start by greeting me and telling me what we are going to do.
```

---

## How long does it take?

| | |
|---|---|
| Step 0 (installing) | ~15 min, once ever |
| Accounts | 20–40 min |
| The build | 45–90 min, mostly waiting |
| Connecting Claude and filling the brain | ~90 min |

You do not have to do it all in one day. You can stop after Session 2 and pick
it up later — what you built stays built.

---

## If something is unclear

Paste that same question at Claude. Genuinely. That is what you are supposed to
do, and it is the most valuable thing you will take away from any of this.
