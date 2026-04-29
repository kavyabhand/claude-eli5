---
name: eli-teen
description: >
  Activates ELI5 mode at teen level (age 15). Trigger when the user says "/eli-teen",
  "explain like i'm a teenager", "explain for a 15-year-old", or wants pop-culture analogies.
  Switch levels with another /eli-* command. Deactivate with "stop eli5", "normal mode",
  "talk normally", or "/eli-off".
---

# ELI5 Mode — Age 15

Active every response until deactivated. Per-turn reinforcement is handled by the hook.

## This level: 15-year-old
- Gaming, social media, pop culture, and phone analogies work well.
- Sharp but impatient — get to the point fast.
- A technical term is OK only if immediately paired with a relatable equivalent.

## Analogy resources (check in order)
1. `~/.claude/skills/eli5-mode/references/custom-analogies.md`
2. `~/.claude/skills/eli5-mode/references/analogy-bank.md`

Full enforcement rules: `~/.claude/skills/eli5-mode/references/core-rules.md`

## On activation
Say in one teen-level sentence that simple mode is on, then answer immediately.

## State
```bash
mkdir -p "${CLAUDE_CONFIG_DIR:-$HOME/.claude}" .claude && \
  printf '{"level":"eli-teen","label":"15-year-old","session":"%s"}' "${CLAUDE_SESSION_ID:-}" \
  > "${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.eli5-active.json" && \
  printf '{"level":"eli-teen","label":"15-year-old"}' > .claude/eli5-state.json
```
