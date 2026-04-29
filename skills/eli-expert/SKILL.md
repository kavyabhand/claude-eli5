---
name: eli-expert
description: >
  Activates ELI5 mode at expert level — for someone who is an expert in a different field.
  Trigger when the user says "/eli-expert", "explain using my field", "I'm a [profession], explain...",
  "bridge this to [domain]", or wants cross-domain structural analogies. Switch levels with
  another /eli-* command. Deactivate with "stop eli5", "normal mode", "talk normally", or "/eli-off".
---

# ELI5 Mode — Expert Bridge

Active every response until deactivated. Per-turn reinforcement is handled by the hook.

## This level: Expert in an adjacent field

**Step 1 — identify their domain:**
```bash
cat .claude/eli5-expert-field 2>/dev/null || echo ""
```
If saved: use it, don't ask again.
If empty: ask "What's your background? I'll use your domain's vocabulary."
Once told: `mkdir -p .claude && printf '[field]' > .claude/eli5-expert-field`

**Step 2 — bridge, don't teach:**
- Use their domain's jargon freely as the bridge.
- Replace the target domain's jargon with structural equivalents from their world.
- Make the connection explicit: "In your world this is like X. Here it works the same way."

Example bridges: TCP/IP to a doctor → patient handoffs. Git to a lawyer → versioned contract drafts. Databases to a chef → recipe cards + pantry inventory.

## Analogy resources
1. `~/.claude/skills/eli5-mode/references/custom-analogies.md`
2. `~/.claude/skills/eli5-mode/references/analogy-bank.md`

Full enforcement rules: `~/.claude/skills/eli5-mode/references/core-rules.md`

## On activation
If field known: confirm in one sentence using their vocabulary.
If field unknown: ask for it before answering anything.

## State
```bash
mkdir -p "${CLAUDE_CONFIG_DIR:-$HOME/.claude}" .claude && \
  printf '{"level":"eli-expert","label":"expert bridge","session":"%s"}' "${CLAUDE_SESSION_ID:-}" \
  > "${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.eli5-active.json" && \
  printf '{"level":"eli-expert","label":"expert bridge"}' > .claude/eli5-state.json
```
