# eli5-mode

<img width="200" height="200" alt="claude-eli5" src="https://github.com/user-attachments/assets/7622dfd7-e538-435e-91ac-eef11cf8b30f" />

**A Claude Code skill that makes Claude talk like you're 5.**

No jargon. No walls of text. Just analogies, plain words, and explanations that actually stick.

Pick your age. Ask anything. Get it.

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

> Windows script blocked? Run `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` first.

Start a new Claude Code session. Done.

---

## Use it

Just say the word — Claude flips into simple mode instantly.

```
eli5          ELI5          /eli5
explain like i'm 5          dumb it down
explain simply              talk to me like a kid
pretend I'm 5               simplest possible explanation
```

Turn it off just as easy:
```
stop eli5     normal mode     talk normally     /eli-off
```

---

## Pick your level

| Command | Who it's for |
|---|---|
| `/eli5` | 5-year-old. Toys, food, animals. Tiny sentences. |
| `/eli-kid` | 10-year-old. School stuff, cause-and-effect, "but why?" energy. |
| `/eli-teen` | 15-year-old. Pop culture, gaming, no patience for boring. |
| `/eli-adult` | Smart person, zero domain knowledge. Real-world analogies. |
| `/eli-expert` | Expert in *another* field. Cross-domain bridges, your vocabulary. |

Switch levels any time, mid-conversation.

---

## See it in action

One topic. Five levels. Here's OAuth:

> **5-year-old**
> Imagine you have a house key. OAuth is like making a tiny special key that only opens the mailbox — you give it to the mailman so he can do his job, but he can never get inside your house.

> **Teen**
> You know how you can "Login with Google" on apps? OAuth is the thing that makes that work. Google hands the app a special pass instead of your password — like a backstage wristband. Gets you in. Doesn't mean you own the venue.

> **Adult**
> OAuth lets you grant an app limited access to another service without handing over your password. Like a valet key — it parks the car, it can't open the glove box.

> **Expert (doctor)**
> Think referral letter. Your GP doesn't send the specialist your full chart — they send a referral authorizing exactly what's needed. OAuth is that letter. Scoped, time-limited, doesn't expose the whole record.

---

## How it works

`eli5-mode` is a **behavioral skill** — it changes *how* Claude talks, not what Claude knows. Every response becomes analogy-first, jargon-free, and short. It stays on until you say otherwise.

Eight rules baked in:

- **Analogy first** — never define, always compare
- **Kill jargon** — replace words that need explaining, don't explain them
- **Short sentences** — one idea, one sentence
- **Stay accurate** — simpler is not the same as wrong
- **Concrete over abstract** — food, toys, animals, buildings, not "systems" and "frameworks"
- **No condescension** — "simply" and "obviously" are banned
- **Persistence** — stays on every response until you turn it off
- **Safety first** — destructive/irreversible action warnings are always written clearly, no exceptions

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

## What's inside

```
eli5-mode/
├── SKILL.md                   # The skill brain — rules, levels, examples
├── evals/
│   └── evals.json             # 8 test cases with verifiable pass/fail checks
└── references/
    └── analogy-bank.md        # 30+ ready-to-use analogies for common tech
install.sh / install.ps1       # One-command install
uninstall.sh / uninstall.ps1   # One-command remove
```

The analogy bank covers: APIs, databases, caching, Git, Docker, encryption, DNS, load balancers, recursion, async, threads, microservices, regex, ORMs, webhooks, and a lot more.
