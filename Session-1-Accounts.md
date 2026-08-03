# Session 1 — Accounts and Keys

**Time: 20–40 minutes. This is the only part where you do the work by hand.**

Everything after this session is done for you. This part cannot be — creating
accounts means clicking buttons on websites and reading your own email, and no
software can do that on your behalf.

Work through it top to bottom. Skip anything you already have.

---

## What you are building, in one paragraph

A private knowledge base that belongs to you. You save things into it — typed
notes, spoken thoughts, YouTube videos, PDFs, web articles — and it stores them
in a database you own. It works out what each thing is about, and quietly
connects related ideas together. Then you point Claude at it, and Claude can
search everything you have ever saved. If you stop using Claude one day, the
brain still works — you point something else at it.

---

## Before you start — the things you should already have

Open a command window and type each of these. You are looking for a version
number, not an error.

**Windows:** press Start, type `PowerShell`, press Enter.
**Mac:** press Cmd+Space, type `Terminal`, press Enter.

```bash
git --version
```

```bash
node --version
```

If either one errors, stop and install it first — [git-scm.com](https://git-scm.com/downloads)
and [nodejs.org](https://nodejs.org) (choose the LTS version). Then close and
reopen the command window.

You also need **Claude Code**. If you have it, you are ready. If not, install it
from [claude.ai/download](https://claude.ai/download) — it is the app that will
do the actual building.

---

## A word about API keys, before you make one

You are about to create something called an API key. It is worth 60 seconds to
understand what it is, because it is the one thing in this build that costs
money.

**An API key is a password that lets *your software* talk to an AI**, instead of
you talking to an AI by typing in a chat window.

Here is the part that confuses almost everyone:

> **Your Claude subscription does not cover this.**

A Claude Pro or Max subscription pays for *you* using Claude — in the app, in
the browser, in Claude Code. It does not pay for *your programs* calling an AI
on their own. That is billed separately, by usage. Two different products, two
different bills. Nothing has gone wrong when you hit a billing page.

**What it will actually cost you:** every time you save something, your brain
asks an AI to tag it and work out its meaning. Those are small, cheap requests.
Saving fifty things a month costs well under a dollar. Ten dollars of credit
will most likely last you many months. You are not signing up for a subscription
— you put a few dollars in and it draws down as you use it.

If you save a hundred YouTube videos in a weekend, you will spend more. You will
be able to see exactly what you have spent on your provider's dashboard at any
time.

---

## 1. GitHub — where your code lives

Skip the signup if you have an account, but **do not skip the fork**.

1. Go to [github.com](https://github.com) → **Sign up**
2. Any username, free plan
3. Verify your email

### Then take your own copy of the code

1. Go to **[github.com/King-Tuerto/open-brain-express](https://github.com/King-Tuerto/open-brain-express)**
2. Click **Fork** (top right)
3. Leave everything as it is → **Create fork**

You are now looking at your own copy — your username is in the address bar. The
original could be deleted tomorrow and yours would be completely unaffected.
That is how open source works, and it means this is genuinely yours now.

Leave that browser tab open. Session 2 needs the address.

---

## 2. Supabase — your database

This is where your thoughts actually live. It is yours; you can export
everything at any time.

1. Go to [supabase.com](https://supabase.com) → **Start your project**
2. **Sign in with GitHub** — simplest, and links the two accounts
3. Click **New project**
4. Name it `open-brain`
5. Set a database password. **Save it somewhere** — a password manager, a note,
   anywhere you will find it again
6. Choose the region closest to you
7. Click **Create new project** and wait about a minute while it builds

### Then change one setting — this matters

By default Supabase makes you confirm your email address before you can log in
to your own app. That means waiting for an email in the middle of setup, and it
trips people up.

1. In your project, go to **Authentication** in the left sidebar
2. Find **Sign In / Providers**, then **Email**
3. Turn **off** "Confirm email"
4. Save

You can turn it back on later. For a personal brain that only you log into, it
adds nothing.

---

## 3. OpenRouter — the AI your brain uses

This is the API key discussed above. It is the only paid piece.

1. Go to [openrouter.ai](https://openrouter.ai) → sign up
2. Click your avatar → **Credits** → add **$5 or $10**
3. Go to **Keys** → **Create Key** → name it `open-brain`
4. **Copy it now.** It starts with `sk-or-` and you will not be shown it again

Paste it somewhere safe for the next twenty minutes — a notes app is fine. It
will go into your database's secret storage shortly, and you can delete your
copy afterwards.

> **Why OpenRouter and not Anthropic directly?** OpenRouter is a single doorway
> to every AI model — Claude, GPT, Gemini, open-source ones. One key, one bill.
> If you ever want to switch which AI powers your brain, you change one word in
> a settings file. That is the whole point of building it this way: you are not
> locked in to anybody.

---

## 4. Vercel — puts your app on the internet

1. Go to [vercel.com](https://vercel.com) → **Sign Up**
2. **Continue with GitHub**
3. Free "Hobby" plan

---

## 5. Supadata — optional, for YouTube

**Skip this if you want. Everything still works without it.**

YouTube deliberately hides subtitles from servers. Your brain has a clever
workaround built in that succeeds much of the time on its own. Supadata is a
service that gets transcripts reliably, and its free tier covers 100 videos a
month.

Without it: YouTube captures still work, but sometimes you get a summary of the
video's description rather than what was actually said.

1. Go to [supadata.ai](https://supadata.ai) → sign up
2. Copy your API key

---

## 6. Claude Desktop — for the payoff at the end

1. Go to [claude.ai/download](https://claude.ai/download)
2. Install it and sign in

This is what will read your brain in Session 3.

---

## Checklist — you are ready when all of these are true

- [ ] `git --version` shows a version number
- [ ] `node --version` shows a version number
- [ ] Claude Code is installed
- [ ] You can log in at **github.com**
- [ ] Your Supabase project exists and shows a dashboard
- [ ] "Confirm email" is switched **off** in Supabase Authentication
- [ ] You have your **OpenRouter key** (`sk-or-…`) written down
- [ ] You can log in at **vercel.com**
- [ ] Claude Desktop is installed
- [ ] *(optional)* You have a Supadata key

---

## Next

Open **Session 2**. That is where you stop working and start watching.
