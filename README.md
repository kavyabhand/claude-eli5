# eli5-mode

> A Claude Code skill that makes Claude talk like you're 5.

<img width="200" height="200" alt="claude-eli5" src="https://github.com/user-attachments/assets/7622dfd7-e538-435e-91ac-eef11cf8b30f" />

No definitions. No jargon. No walls of text.

Analogy-first explanations at exactly the level you choose — and they actually stick.

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

Start a new Claude Code session. All 12 commands are live.

**Update:**
```bash
./update.sh
```

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

### Navigation

| Command | What it does |
|---|---|
| `/eli-deeper` | Step one level more technical. Re-explains the last concept at the new level. |
| `/eli-simpler` | Step one level simpler. Re-explains the last concept at the new level. |

### Utilities

| Command | What it does |
|---|---|
| `/eli-status` | Show current mode and level. |
| `/eli-save` | Export all eli5 explanations from this session to `eli5-notes.md`. |
| `/eli-quiz` | Test your understanding of the last explanation. |
| `/eli-doc` | Scan the current codebase and write `ELI5.md` — a plain-language glossary. |

### Deactivate

```
/eli-off      stop eli5      normal mode      talk normally
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
level=eli-adult

# for /eli-expert, add your field:
# expert_field=medicine
```

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

## Different analogy? Just ask.

If an analogy doesn't click, say any of these and Claude will generate a completely different one — never reusing one it already gave:

```
different analogy    another analogy    that didn't help
try again           give me another one   that one didn't click
```

---

## How it works

`eli5-mode` is a **behavioral skill** — it changes *how* Claude communicates, not what it knows. Each level is a registered slash command with its own `SKILL.md`. A `SessionStart` hook auto-activates for projects with `.eli5rc`. All levels share a central rules file so they stay consistent.

Eight rules baked into every level:

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

Every token you spend on meta-instructions is a token not spent on your actual answer. eli5-mode v3 is engineered to minimize that overhead without letting quality drift.

### Three-hook architecture

| Hook | When it fires | What it does |
|---|---|---|
| `SessionStart` | Once per session | Reads `core-rules.md` at runtime — full rules injected once, not on every activation |
| `UserPromptSubmit` | Every turn | 25-token reinforcement prevents drift; detects level switches and deactivation in-flight |
| Statusline | Every turn | Zero-token — renders the `[ELI5]` badge from the flag file, no prompt overhead |

### Measured overhead per 20-turn session

| | Level stub size | Per-turn overhead | Drift re-activations | **Total eli5 overhead** |
|---|---|---|---|---|
| v2 (rules baked in) | ~450 tokens | 0 | 1 typical (~450t) | **~1,575 tokens** |
| v3 (per-turn hook) | ~150 tokens | 25t × 20 = 500t | 0 (prevented) | **~1,325 tokens** |

That's **~16% lower** in the typical case — but the real win is that v2's number gets *worse* every time Claude drifts (each re-activation costs another 450 tokens). v3's number is a fixed ceiling.

### How drift is prevented

Without reinforcement, Claude gradually stops following eli5 rules after 10–15 turns. The `UserPromptSubmit` hook fires before every response and injects a 25-token reminder:

```
ELI5 ACTIVE (eli-teen / 15yo). Pop culture/gaming. Get to the point fast.
Core rules: analogy-first, kill jargon, short sentences, accurate, concrete, no condescension.
Persist every response. /eli-off to deactivate.
```

25 tokens per turn. No drift. No re-activation cost.

### Single source of truth

`core-rules.md` is read at runtime by the `SessionStart` hook — not duplicated into each level stub. Edit the file, restart your session, and all five levels pick up the change instantly. No reinstall needed.

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
│   │       └── custom-analogies.md  add your own
│   ├── eli-kid/SKILL.md         age 10
│   ├── eli-teen/SKILL.md        age 15
│   ├── eli-adult/SKILL.md       smart non-expert
│   ├── eli-expert/SKILL.md      expert in adjacent field (with field memory)
│   ├── eli-off/SKILL.md         deactivate
│   ├── eli-status/SKILL.md      check current level
│   ├── eli-deeper/SKILL.md      step one level more technical
│   ├── eli-simpler/SKILL.md     step one level simpler
│   ├── eli-save/SKILL.md        export session explanations to file
│   ├── eli-quiz/SKILL.md        test your understanding
│   └── eli-doc/SKILL.md         generate ELI5.md for the codebase
├── hooks/
│   ├── eli5-session-start.sh    SessionStart — reads core-rules.md, auto-activates from .eli5rc
│   ├── eli5-per-turn.js         UserPromptSubmit — 25-token per-turn reinforcement, drift prevention
│   └── eli5-statusline.sh       Statusline — orange [ELI5] / [ELI5:TEEN] badge
├── examples/
│   ├── eli5rc-example           sample .eli5rc config
│   └── CLAUDE.md                block to add to your project's CLAUDE.md
├── install.sh / install.ps1
├── uninstall.sh / uninstall.ps1
├── update.sh
└── VERSION
```
