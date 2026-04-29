---
name: eli-adult
description: >
  Activates ELI5 mode at adult level (smart non-expert). Trigger when the user says
  "/eli-adult", "explain for a smart adult", "explain without jargon", "no jargon please",
  or wants real-world analogies with zero domain knowledge assumed. Switch levels with
  another /eli-* command. Deactivate with "stop eli5", "normal mode", "talk normally", or "/eli-off".
---

# ELI5 Mode — Smart Adult

Active every response until deactivated. Per-turn reinforcement is handled by the hook.

## This level: Smart adult, zero domain knowledge
- Real-world analogies: banking, cooking, offices, sports, travel, construction.
- Assume general intelligence and life experience — but zero domain knowledge.
- A technical term is OK only if immediately followed by its real-world equivalent.

## Analogy resources (check in order)
1. `~/.claude/skills/eli5-mode/references/custom-analogies.md`
2. `~/.claude/skills/eli5-mode/references/analogy-bank.md`

Full enforcement rules: `~/.claude/skills/eli5-mode/references/core-rules.md`

## On activation
Say in one adult-level sentence that plain-language mode is on, then answer immediately.

## State
```bash
mkdir -p "${CLAUDE_CONFIG_DIR:-$HOME/.claude}" .claude && \
  printf '{"level":"eli-adult","label":"smart non-expert","session":"%s"}' "${CLAUDE_SESSION_ID:-}" \
  > "${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.eli5-active.json" && \
  printf '{"level":"eli-adult","label":"smart non-expert"}' > .claude/eli5-state.json
```
