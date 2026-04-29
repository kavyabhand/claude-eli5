# eli5-mode

<<<<<<< Updated upstream
<img width="200" height="200" alt="download" src="https://github.com/user-attachments/assets/fc455497-a820-428c-85b6-96ea3a2819fc" />

<br>
A Claude Code skill that makes Claude explain everything like you're 5 years old (or whatever age you pick).
=======
A Claude Code skill that makes Claude explain everything like you're 5 years old — or whatever age you pick.
>>>>>>> Stashed changes

Analogy-first. Zero jargon. Radically simplified but always accurate.

---

## Install

### Mac / Linux

```bash
git clone https://github.com/kavyabhand/claude-eli5.git
cd claude-eli5
chmod +x install.sh
./install.sh
```

### Windows (PowerShell)

```powershell
git clone https://github.com/kavyabhand/claude-eli5.git
cd claude-eli5
.\install.ps1
```

> If you get a script execution error on Windows, run:
> `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`
> then retry.

That's it. Start a new Claude Code session — the skill is live.

---

## Uninstall

### Mac / Linux

```bash
./uninstall.sh
```

### Windows (PowerShell)

```powershell
.\uninstall.ps1
```

---

## What it does

`eli5-mode` is a **behavioral skill** — it changes how Claude communicates, not what it can help with. Once activated, every response uses physical analogies, short sentences, and plain words. It stays on until you turn it off.

---

## Usage

Say any of these to activate in Claude Code:

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

---

## Levels

Switch levels any time — even mid-session.

| Command | Audience | Style |
|---|---|---|
| `/eli5` | 5-year-old (default) | Toys, food, animals. Max ~15 words/sentence. |
| `/eli-kid` | 10-year-old | School analogies, cause-effect, curious-kid energy. |
| `/eli-teen` | 15-year-old | Pop culture refs, gaming, social analogies. |
| `/eli-adult` | Smart non-expert | Real-world analogies, no jargon, assumes life experience. |
| `/eli-expert` | Expert in adjacent field | Cross-domain bridges using their own vocabulary. |

---

## Examples

**eli5 — OAuth:**
> Imagine you have a house key. OAuth is like making a tiny special key that only opens the mailbox. You give it to the mailman so he can do his job, but he can never get inside your house.

**eli-teen — OAuth:**
> You know how you can "Login with Google" on apps? OAuth is the thing that makes that work. Instead of giving the app your Google password, Google hands them a special pass — like a backstage wristband that gets you in but doesn't mean you own the venue.

**eli-adult — OAuth:**
> OAuth lets you grant an app limited access to another service without sharing your password. Like giving a parking valet a special valet key — works for parking, can't open the glove box.

**eli-expert (doctor) — OAuth:**
> Think of it like a referral letter. Instead of handing a specialist your full chart, your GP sends a referral that authorizes exactly what they need to see. OAuth is that letter — scoped, time-limited, doesn't expose everything.

---

## Core rules

1. **Analogy first** — never define, always compare.
2. **Kill jargon** — if a word needs explaining, replace it.
3. **Short sentences** — one idea per sentence.
4. **Stay accurate** — simplification is not the same as wrong.
5. **Concrete over abstract** — food, toys, animals, buildings, weather.
6. **No condescension** — never say "simply", "obviously", "just", "easy".
7. **Persistence** — active every response until explicitly turned off.
8. **Safety exception** — warnings for destructive/irreversible actions are always written clearly first.

---

## Files

```
eli5-mode/
├── SKILL.md                  # Skill instructions + core rules
├── evals/
│   └── evals.json            # 8 test cases with verifiable assertions
└── references/
    └── analogy-bank.md       # 30+ ready-to-use analogies for common tech concepts
install.sh                    # Mac/Linux installer
install.ps1                   # Windows PowerShell installer
uninstall.sh                  # Mac/Linux uninstaller
uninstall.ps1                 # Windows PowerShell uninstaller
```

## Analogy bank coverage

APIs · REST · WebSockets · HTTP/HTTPS · DNS · CDNs · load balancers · firewalls · databases · SQL · indexes · caching · memory/RAM · disk storage · data compression · functions · variables · loops · conditionals · arrays · objects · classes · inheritance · recursion · bugs · dependencies · servers · cloud · Docker · virtual machines · microservices · monoliths · encryption · SSL · auth tokens · middleware · proxies · Git · branches · merging · compilers · interpreters · async/sync · threads · deadlocks · race conditions · design patterns · regex · ORMs · webhooks · message queues
