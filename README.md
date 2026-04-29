# eli5-mode

> The Claude Code skill that makes complex things make sense — and keeps them that way.

<img width="200" height="200" alt="claude-eli5" src="https://github.com/user-attachments/assets/7622dfd7-e538-435e-91ac-eef11cf8b30f" />

No definitions. No jargon. No walls of text.

22 commands that change how Claude explains, compares, teaches, and writes — at exactly the level you choose.

---

## Install

**Mac / Linux**
```bash
git clone https://github.com/kavyabhand/claude-eli5.git
cd claude-eli5
./install.sh
```

**Windows (PowerShell)**
```powershell
git clone https://github.com/kavyabhand/claude-eli5.git
cd claude-eli5
.\install.ps1
```

> **Windows script blocked?** Run `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` first.

Start a new Claude Code session. All 22 commands are live.

**Update:**
```bash
./update.sh
```

---

## Why you'll actually use this every day

Most tools make you smarter *about* a topic. eli5-mode makes you better at *communicating* it.

You'll reach for it in four situations — none of which require you to be confused:

1. **You're learning something new** — `/eli-prereqs` shows you the path, `/eli-teach` walks you through it, `/eli-compare` puts it side by side with something you already know
2. **You need to write for a non-technical audience** — `/eli-pr` writes your PR description, `/eli-brief` writes your Slack message to your manager, `/eli-commit` writes the commit message
3. **You need to check your own understanding** — `/eli-tweet` forces you to compress it to 280 chars, `/eli-quiz` tests it, `/eli-tldr` distills it to 3 bullets
4. **Your team needs onboarding docs** — `/eli-doc --team` generates a committed `ELI5.md` that explains your entire codebase in plain language

---

## The full command set

### Levels — each is its own slash command

| Command | Audience | Style |
|---|---|---|
| `/eli5` | 5-year-old (default) | Toys, food, animals. ~15 words/sentence. |
| `/eli-kid` | 10-year-old | School analogies. Cause-and-effect. Lots of "but why?" |
| `/eli-teen` | 15-year-old | Gaming, pop culture, social stuff. Sharp and impatient. |
| `/eli-adult` | Smart non-expert adult | Real-world analogies. No jargon. Assumes life experience. |
| `/eli-expert` | Expert in a *different* field | Bridges your domain to this one. Doctor? Lawyer? Chef? It'll ask. |

Use a command alone or with a question:
```
/eli5
/eli-teen explain what a race condition is
/eli-expert I'm a surgeon. What is async/await?
```

### Navigate levels

| Command | What it does |
|---|---|
| `/eli-deeper` | One level more technical. Re-explains the last concept. |
| `/eli-simpler` | One level simpler. Re-explains the last concept. |

---

### Learning tools

| Command | What it does |
|---|---|
| `/eli-compare X vs Y` | Side-by-side comparison using the same analogy domain. One analogy per concept, one key difference, one "use X when / use Y when." |
| `/eli-prereqs [topic]` | Shows what you need to understand first — a real learning path, not "learn programming fundamentals." Checks what you've already covered. |
| `/eli-teach [topic]` | Socratic mode. Guides you to the answer through questions instead of explaining it. You actually remember what you figure out yourself. |
| `/eli-quiz` | 2–3 level-appropriate questions on the last explanation. One at a time. Feedback in eli5 style. |
| `/eli-recap` | Digest of everything explained this session. Saves a concept index to `.claude/eli5-concepts.json` so future sessions can build on this one. |

---

### Format variants — same concept, different shape

| Command | What it does |
|---|---|
| `/eli-brief [topic]` | 3 sentences. Safe to paste to your director, a client, or a board deck. Each sentence ≤ 20 words. |
| `/eli-tweet [topic]` | 280 characters or fewer. Shows character count. Challenge: "shorter" to try again at ≤ 140. If you can't say it in 280 chars, you don't fully understand it. |
| `/eli-tldr [topic]` | Exactly 3 bullets: what it is, why it matters, key thing to know. No prose. |

---

### Workflow tools — useful even when you're not confused

| Command | What it does |
|---|---|
| `/eli-pr` | Reads `git diff main...HEAD` and writes a PR description: what changed, why, how to test, risk level. Audience: your manager, a designer, a PM. |
| `/eli-commit` | Reads staged changes and writes a commit message focused on *why*, not just *what*. No jargon in the subject line. |

**`/eli-pr` is the one that becomes a habit.** Engineers open PRs constantly. If the skill writes the plain-language description automatically, this stops being a "when I'm confused" tool and becomes a daily one.

---

### Memory — knowledge that survives sessions

| Command | What it does |
|---|---|
| `/eli-remember` | Saves the last analogy (or one you specify) to `custom-analogies.md`. Checked before the built-in bank in every future session. |
| `/eli-save` | Exports all eli5 explanations from this session to `eli5-notes.md`. |
| `/eli-doc` | Scans the current codebase and writes `ELI5.md` — a plain-language glossary of everything in it. |
| `/eli-doc --team` | Same, but structured for committing to the repo. Adds "new hire start here" section, gotchas, and a full glossary. Every future hire gets it automatically. |

---

### Control

```
/eli-off      stop eli5      normal mode      talk normally
/eli-status   — show current level
```

---

## Or just say it

Slash commands are optional. Any of these activate the default level:

```
eli5          ELI5           explain like i'm 5
dumb it down  explain simply  talk to me like a kid
pretend I'm 5               simplest possible explanation
```

---

## Auto-activate for a project

Drop a `.eli5rc` file in your project root and eli5-mode activates automatically every session — no command needed:

```bash
# .eli5rc

# Explanation level
level=eli-adult

# Expert field (for /eli-expert auto-activation)
# expert_field=medicine

# Passive jargon scan — appends a plain-language footnote after any response
# that contains unexplained technical terms. Works without a level active.
# passive_mode=true

# Proactive offers — Claude will offer to eli5 the most unfamiliar-looking
# term in each response, one line, non-intrusive.
# proactive=true
```

**The team setup**: add `passive_mode=true` to the repo's `.eli5rc`. Every team member gets a nudge toward clearer language in their session, without having to opt in individually.

See `examples/eli5rc-example` for all options.

---

## See it in action

One concept. Five levels.

> **`/eli5` — OAuth**
> Imagine you have a house key. OAuth is like making a tiny special key that only opens the mailbox. You give it to the mailman, but he can never get inside your house.

> **`/eli-kid` — OAuth**
> You know how your parents have a spare key that only opens the front door? OAuth works like that for apps. The app gets a tiny key that only does one thing — it can't get into everything.

> **`/eli-teen` — OAuth**
> You know how you can "Login with Google" on apps? OAuth makes that work. Google gives the app a special pass instead of your password — like a backstage wristband. Gets you in. Doesn't mean you own the venue.

> **`/eli-adult` — OAuth**
> OAuth lets you grant an app limited access to another service without sharing your password. Like a parking valet key — it parks the car, it can't open the glove box.

> **`/eli-expert` (doctor) — OAuth**
> Think of it like a referral letter. Your GP doesn't send the specialist your full chart — they send a referral authorizing exactly what's needed. OAuth is that letter. Scoped, time-limited, doesn't expose everything.

---

**`/eli-compare` — SQL vs NoSQL**
> **SQL** — like a spreadsheet where every row must follow the exact same column layout.
> **NoSQL** — like a folder of sticky notes where each note can have whatever's written on it.
>
> **Same**: both store and retrieve data; both need organization to stay fast at scale.
> **Different**: SQL forces structure upfront; NoSQL lets structure evolve as you go.
>
> **Use SQL when**: your data is predictable and relationships matter (orders + customers).
> **Use NoSQL when**: your data varies per item or you need to scale reads to millions of users fast.

---

**`/eli-brief` — Rate limiting** *(safe for Slack to your director)*
> Rate limiting is like a bouncer at a door who lets in only a set number of people per minute.
> It stops one bad actor from overwhelming a system and slowing it down for everyone else.
> Our API currently allows 100 requests per minute per user — raise or lower it in the dashboard.

---

**`/eli-pr`** *(reads your actual git diff)*
```
## What changed
Added automatic retry when the server is temporarily unavailable.

## Why
A single slow moment was failing the entire request for the user — now we try up to 3 times.

## How to test
- Make a request while the server is intentionally slow (add 5s delay in dev)
- Confirm the request succeeds after the retry
- Confirm normal requests are unaffected

## Risk
Low risk — retry logic only activates on network errors, not on application errors.
```

---

## Different analogy? Just ask.

If an analogy doesn't click, say any of these and Claude will generate a completely different one — never reusing one it already gave:

```
different analogy    another analogy    that didn't help
try again           give me another one   that one didn't click
```

---

## How it works

`eli5-mode` is a **behavioral skill** — it changes *how* Claude communicates, not what it knows. Three hooks work together:

| Hook | When it fires | What it does | Token cost |
|---|---|---|---|
| `SessionStart` | Once | Reads `core-rules.md` at runtime, injects full rules + activation | ~675t once |
| `UserPromptSubmit` | Every turn | 25-token reinforcement, level-switch detection, deactivation detection | ~25t/turn |
| Statusline | Every turn | Renders `[ELI5]` / `[ELI5:TEEN]` badge | 0t |

Eight rules baked into every response:

1. **Analogy first** — never define, always compare
2. **Kill jargon** — replace words that need explaining, don't explain them
3. **Short sentences** — one idea per sentence
4. **Stay accurate** — simpler is not the same as wrong
5. **Concrete over abstract** — food, toys, buildings, not "systems" and "paradigms"
6. **No condescension** — "simply" and "obviously" are banned
7. **Persistence** — every response until deactivated; drift is a bug
8. **Safety first** — warnings for destructive/irreversible actions always in plain language

---

## Token efficiency

| | Level stub size | Per-turn overhead | Drift re-activations | **Total / 20-turn session** |
|---|---|---|---|---|
| v2 (rules baked in) | ~450 tokens | 0 | 1 typical (~450t) | **~1,575 tokens** |
| v3+ (per-turn hook) | ~150 tokens | 25t × 20 = 500t | 0 (prevented) | **~1,325 tokens** |

16% lower token cost. Zero drift. The per-turn hook catches deactivation and level switches in-flight — no extra round trips.

`core-rules.md` is read at runtime, not baked into each stub. Edit the rules, restart your session, all five levels pick up the change instantly. No reinstall.

---

## Uninstall

**Mac / Linux**
```bash
./uninstall.sh
```

**Windows**
```powershell
.\uninstall.ps1
```

---

## File structure

```
claude-eli5/
├── skills/
│   ├── eli5-mode/               default level (age 5)
│   │   ├── SKILL.md
│   │   ├── evals/evals.json     8 test cases with pass/fail assertions
│   │   └── references/
│   │       ├── core-rules.md    shared enforcement rules (single source of truth)
│   │       ├── analogy-bank.md  40+ ready-to-use analogies
│   │       └── custom-analogies.md  add your own, checked first every session
│   │
│   ├── eli-kid/        eli-teen/        eli-adult/        eli-expert/
│   ├── eli-off/        eli-status/      eli-deeper/       eli-simpler/
│   │
│   ├── eli-compare/    eli-prereqs/     eli-teach/        eli-quiz/        eli-recap/
│   ├── eli-brief/      eli-tweet/       eli-tldr/
│   ├── eli-pr/         eli-commit/
│   ├── eli-remember/   eli-save/        eli-doc/
│   │
├── hooks/
│   ├── eli5-session-start.sh    SessionStart — rules injection, .eli5rc auto-activation,
│   │                            passive_mode and proactive flag support
│   ├── eli5-per-turn.js         UserPromptSubmit — 25-token drift prevention per turn
│   └── eli5-statusline.sh       Statusline badge — [ELI5] / [ELI5:TEEN] etc.
├── examples/
│   ├── eli5rc-example           sample .eli5rc with all options documented
│   └── CLAUDE.md                block added to ~/.claude/CLAUDE.md on install
├── install.sh / install.ps1
├── uninstall.sh / uninstall.ps1
├── update.sh
└── VERSION
```
