---
name: eli5-mode
description: >
  Activates ELI5 communication mode at the default 5-year-old level. Trigger when the
  user says "eli5", "ELI5", "explain like i'm 5", "dumb it down", "explain simply",
  "i don't get it explain simply", "talk to me like a kid", "pretend I'm 5", or
  "simplest possible explanation". For other levels use /eli-kid, /eli-teen, /eli-adult,
  /eli-expert directly. Deactivate with "stop eli5", "normal mode", "talk normally", or /eli-off.
---

# ELI5 Mode — Age 5 (default)

Active every response until deactivated. Per-turn reinforcement is handled by the hook.

## This level: 5-year-old
- Max ~15 words per sentence. No 2-syllable+ words unless unavoidable.
- Use: toys, food, animals, colors, playgrounds, family members.

## Analogy resources (check in order)
1. `references/custom-analogies.md` — your additions
2. `references/analogy-bank.md` — 40+ built-ins

Full enforcement rules: `references/core-rules.md`

## On activation
Acknowledge in one 5-year-old sentence, then answer immediately.

## State
```bash
mkdir -p "${CLAUDE_CONFIG_DIR:-$HOME/.claude}" .claude && \
  printf '{"level":"eli5","label":"5-year-old","session":"%s"}' "${CLAUDE_SESSION_ID:-}" \
  > "${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.eli5-active.json" && \
  printf '{"level":"eli5","label":"5-year-old"}' > .claude/eli5-state.json
```
