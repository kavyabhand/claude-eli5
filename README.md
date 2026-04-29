# eli5-mode

<img width="200" height="200" alt="download" src="https://github.com/user-attachments/assets/fc455497-a820-428c-85b6-96ea3a2819fc" />

<br>
A Claude Code skill that makes Claude explain everything like you're 5 years old (or whatever age you pick).

Analogy-first. Zero jargon. Radically simplified but always accurate.

---

## What it does

`eli5-mode` is a **behavioral skill** — it changes how Claude communicates, not what it can help with. Once activated, every response uses physical analogies, short sentences, and plain words instead of technical definitions. It stays active until you turn it off.

## Installation

```bash
# Install via Claude plugin manager
claude plugin install kavyabhand/claude-eli5

# Or copy the skill directory to your skills folder
cp -r eli5-mode ~/.claude/skills/
```

## Usage

Say any of these to activate:

```
eli5
ELI5
/eli5
explain like i'm 5
dumb it down
explain simply
talk to me like a kid
pretend I'm 5
simplest possible explanation
```

To deactivate:

```
stop eli5
normal mode
talk normally
/eli-off
```

## Levels

| Command | Audience | Style |
|---|---|---|
| `/eli5` | 5-year-old (default) | Toys, food, animals. Max 15 words/sentence. No 2-syllable+ words. |
| `/eli-kid` | 10-year-old | School analogies, cause-effect, curious-kid energy. |
| `/eli-teen` | 15-year-old | Pop culture refs, social analogies, slightly more complexity. |
| `/eli-adult` | Smart non-expert | Real-world analogies, no jargon, assumes life experience. |
| `/eli-expert` | Expert in adjacent field | Cross-domain bridges (e.g., explain TCP/IP to a doctor). |

Switch levels any time mid-session.

## Examples

**eli5 — what is OAuth?**
> Imagine you have a house key. OAuth is like making a tiny special key that only opens the mailbox. You give it to the mailman so he can do his job, but he can never get inside your house.

**eli-teen — what is OAuth?**
> You know how you can "Login with Google" on apps? OAuth is the thing that makes that work. Instead of giving the app your Google password, Google hands them a special pass that only works for specific things — like a backstage wristband that gets you in but doesn't mean you own the venue.

**eli-adult — what is OAuth?**
> OAuth lets you grant an app limited access to another service without sharing your password. Like giving a parking valet a special valet key — it works for parking the car, but it can't open the glove box or trunk.

**eli-expert (doctor) — what is OAuth?**
> Think of it like a referral system. Instead of giving a specialist your full medical record, your GP sends a referral letter that authorizes exactly what the specialist needs to see. OAuth is that referral letter — scoped, time-limited, and doesn't expose the whole chart.

## Core rules

1. **Analogy first** — never define, always compare.
2. **Kill jargon** — if a word needs explaining, replace it.
3. **Short sentences** — one idea per sentence.
4. **Stay accurate** — simplification is not the same as wrong.
5. **Concrete over abstract** — food, toys, animals, buildings, weather.
6. **No condescension** — never say "simply", "obviously", "just", "easy".
7. **Persistence** — active every response until you say so.
8. **Safety exception** — warnings for destructive/irreversible actions are always written clearly.

## Files

```
eli5-mode/
├── SKILL.md                  # Skill instructions + core rules
├── evals/
│   └── evals.json            # 8 test cases with verifiable assertions
└── references/
    └── analogy-bank.md       # 30+ ready-to-use analogies for common tech concepts
```

## Analogy bank coverage

The included analogy bank covers: APIs, REST, WebSockets, HTTP/HTTPS, DNS, CDNs, load balancers, firewalls, databases, SQL, caching, memory/RAM, storage, data compression, functions, variables, loops, conditionals, arrays, objects, classes, inheritance, recursion, bugs, dependencies, servers, cloud, Docker, VMs, microservices, encryption, SSL, auth tokens, middleware, proxies, Git, branches, compilers, async/sync, threads, deadlocks, race conditions, design patterns, regex, ORMs, webhooks, and message queues.
