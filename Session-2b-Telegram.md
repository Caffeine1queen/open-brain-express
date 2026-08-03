# Session 2b — Text your brain (optional)

**Time: 20–30 minutes. Skip it if you are short on time — everything else works
without it.**

This gives you a Telegram bot. Send it a message from your phone and it saves to
your brain. Ask it a question and it searches. No app to open, no browser, no
typing a URL — just a message thread like any other.

It is the thing most people end up using most.

---

## First, get a bot from Telegram

You need the Telegram app on your phone. If you do not have it:
[telegram.org](https://telegram.org) — sign up with your phone number.

Then:

1. In Telegram, search for **@BotFather** — the official one, it has a blue tick
2. Send it: `/start`
3. Send it: `/newbot`
4. It asks for a name — anything, e.g. `My Brain`
5. It asks for a username — must end in `bot`, e.g. `paulsbrain_bot`
6. It gives you a **token** that looks like `1234567890:AAF-xxxxxxxxxxxxxxxxx`

**Copy that token.** It is a password for your bot — anyone who has it controls
your bot. Put it somewhere safe for the next ten minutes; it goes into Supabase's
secret storage and never into a file.

Then **send your new bot any message** — just say hello. Nothing will happen yet,
but this creates the conversation, which the next step needs.

---

## Then paste this into Claude Code

```
Set up the Telegram bot for this person's Open Brain.

You will need their bot token from BotFather. Ask for it once, store it, and
never repeat it back in the chat.

=== STEP 1 — STORE THE TOKEN ===

  npx supabase secrets set TELEGRAM_BOT_TOKEN=their-token

=== STEP 2 — DEPLOY ===

  npx supabase functions deploy telegram-bot --no-verify-jwt

The --no-verify-jwt flag is required. Telegram cannot send a Supabase login
token, so without it Supabase blocks every message before the code runs and the
bot appears completely dead with nothing useful in the logs.

=== STEP 3 — TELL TELEGRAM WHERE TO SEND MESSAGES ===

Telegram needs to know the address of the function. This is called setting the
webhook and you do it once, by opening a URL.

Build this URL with their real values and have them open it in a browser:

  https://api.telegram.org/bot<THEIR_BOT_TOKEN>/setWebhook?url=https://<THEIR_PROJECT_REF>.supabase.co/functions/v1/telegram-bot

They should see: {"ok":true,"result":true,"description":"Webhook was set"}

If they see "ok":false, read the description — it is usually a typo in the token
or the URL.

=== STEP 4 — LOCK IT TO THEIR PHONE ===

Right now anyone who finds the bot could write into their brain. Fix that.

Have them send their bot any message. The bot will reply with their chat id and
instructions — it is designed to do this before it is locked down.

Take that number and store it:

  npx supabase secrets set TELEGRAM_CHAT_ID=that-number

Then redeploy so it takes effect:

  npx supabase functions deploy telegram-bot --no-verify-jwt

=== STEP 5 — TEST ===

Have them, on their phone:

  1. Send: "Testing my brain from Telegram"
     Expect: "✅ Saved (5 words). Tagging it now."

  2. Wait 15 seconds, then send: /recent
     Expect: to see that message listed back

  3. Send: ? testing
     Expect: the same thought found by search

  4. Send: /count
     Expect: a total, e.g. "🧠 34 thoughts, 61 connections between them."

If nothing at all comes back, the webhook is the usual culprit. Check it with:

  https://api.telegram.org/bot<THEIR_BOT_TOKEN>/getWebhookInfo

Look at "last_error_message" in the response — it usually says exactly what is
wrong. A 401 there means the function was deployed without --no-verify-jwt.

=== STEP 6 — TELL THEM HOW TO USE IT ===

  - Send anything -> it saves
  - ? followed by a question -> searches by meaning
  - /recent -> last 5 things
  - /count -> how much is in there

Suggest they pin the bot to the top of their Telegram list.
```

---

## What you now have

Your brain is in your pocket. Ideas in the car, in a meeting, on a walk — send
them to the bot and they are captured, tagged, and connected to everything else
you know, before you have put your phone away.

Everything sent this way appears in your web app and is readable by Claude, the
same as anything else. It is one brain with several doors into it.

---

## Next

Back to **[Session 3](Session-3-Connect.md)** — connecting Claude Desktop and
filling your brain up.
