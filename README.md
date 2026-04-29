# eli5-mode

> A Claude Code skill that makes Claude talk like you're 5.

<img width="200" height="200" alt="claude-eli5" src="https://github.com/user-attachments/assets/7622dfd7-e538-435e-91ac-eef11cf8b30f" />

No definitions. No jargon. No walls of text.

Just analogies, plain words, and explanations that actually stick — calibrated to exactly how much you want simplified.

---

## What it does

You're reading a codebase. You hit something you don't fully get. You ask Claude to explain it.

Normally you get a paragraph that starts with "X is a framework that enables Y to do Z via..." — which is technically correct and completely useless if you're not already in the domain.

With eli5-mode active:

```
You:    eli5 what is a load balancer

Claude: Imagine a traffic cop at a busy intersection. When too many cars
        head toward the same lane, the cop waves some into other lanes
        so nobody gets stuck.

        A load balancer does the same thing for your servers.
```

Every response. Every time. Until you turn it off.

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

Start a new Claude Code session. All five commands are live.

**Update anytime:**
```bash
./update.sh
```

---

## The commands

Five levels. Each is its own slash command.

| Command | Who it's for | What it sounds like |
|---|---|---|
| `/eli5` | 5-year-old | Toys, food, animals. ~15 words/sentence. |
| `/eli-kid` | 10-year-old | School analogies. Cause-and-effect. Lots of "but why?" |
| `/eli-teen` | 15-year-old | Gaming, pop culture, social stuff. Sharp but impatient. |
| `/eli-adult` | Smart non-expert adult | Real-world analogies. No jargon. Assumes life experience, not domain knowledge. |
| `/eli-expert` | Expert in a *different* field | Bridges your domain to this one. Doctor? Lawyer? Chef? Tell Claude. |

Use the command alone to activate, or with a question to get an answer immediately:

```
/eli5
/eli-teen explain what a race condition is
/eli-expert I'm a surgeon. What is async/await?
```

Switch levels any time — even mid-conversation. Just say the new command.

---

## Or just say it

Don't want a slash command? Any of these work too:

```
eli5                      ELI5
explain like i'm 5        dumb it down
explain simply            talk to me like a kid
pretend I'm 5             simplest possible explanation
i don't get it, explain simply
```

---

## Turn it off

```
stop eli5     normal mode     talk normally     /eli-off
```

---

## See the difference

Same topic. Five levels. Here's OAuth:

**`/eli5` — 5-year-old**
> Imagine you have a house key. OAuth is like making a tiny special key that only opens the mailbox. You give it to the mailman so he can do his job, but he can never get inside your house.

**`/eli-kid` — 10-year-old**
> You know how your parents have a spare key that only opens the front door — not the garage? OAuth works like that for apps. Instead of giving an app your whole password, it gets a tiny special key that only does one thing.

**`/eli-teen` — 15-year-old**
> You know how you can "Login with Google" on random apps? OAuth is the thing that makes that work. Google gives the app a special pass instead of your actual password — like a backstage wristband. Gets you in. Doesn't mean you own the venue.

**`/eli-adult` — smart non-expert**
> OAuth lets you grant an app limited access to another service without sharing your password. Like a parking valet key — it parks the car, it can't open the glove box.

**`/eli-expert` — doctor**
> Think of it like a referral letter. Your GP doesn't send the specialist your full chart — they send a referral authorizing exactly what's needed. OAuth is that letter. Scoped, time-limited, doesn't expose everything.

---

## How it works

eli5-mode is a **behavioral skill** — it changes *how* Claude communicates, not what Claude knows or can help with. The skill loads into Claude's context and overrides its communication defaults for the entire session.

Eight rules baked into every level:

1. **Analogy first** — never define, always compare
2. **Kill jargon** — if a word needs explaining, replace it entirely
3. **Short sentences** — one idea per sentence
4. **Stay accurate** — simpler is not the same as wrong
5. **Concrete over abstract** — food, toys, animals, buildings, not "systems" and "paradigms"
6. **No condescension** — "simply" and "obviously" are banned
7. **Persistence** — stays on every response until you turn it off
8. **Safety first** — warnings for destructive or irreversible actions are always written in plain clear language, no exceptions

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
│   ├── eli5-mode/              ← main skill (default, age 5)
│   │   ├── SKILL.md
│   │   ├── evals/
│   │   │   └── evals.json      ← 8 test cases with pass/fail assertions
│   │   └── references/
│   │       └── analogy-bank.md ← 30+ ready-to-use analogies
│   ├── eli-kid/SKILL.md        ← age 10
│   ├── eli-teen/SKILL.md       ← age 15
│   ├── eli-adult/SKILL.md      ← smart non-expert
│   └── eli-expert/SKILL.md     ← expert in adjacent field
├── install.sh                  ← Mac/Linux install
├── install.ps1                 ← Windows install
├── uninstall.sh
├── uninstall.ps1
└── update.sh                   ← git pull + reinstall
```

The analogy bank covers 40+ concepts: APIs, databases, caching, Git, Docker, encryption, DNS, load balancers, recursion, async, threads, microservices, regex, ORMs, WebSockets, message queues, and more.
