#!/usr/bin/env bash
# eli5-session-start.sh — SessionStart hook
#
# Auto-activates eli5-mode if .eli5rc is found in the project dir or ~/.eli5rc.
# Writes ~/.claude/.eli5-active.json for per-turn hook + statusline to read.
# Reads core-rules.md at runtime so edits to it propagate automatically.

RC_FILE=""
[ -f ".eli5rc" ]        && RC_FILE=".eli5rc"
[ -z "$RC_FILE" ] && [ -f "$HOME/.eli5rc" ] && RC_FILE="$HOME/.eli5rc"
[ -z "$RC_FILE" ] && exit 0

LEVEL=$(grep -E "^level=" "$RC_FILE" 2>/dev/null | head -1 | cut -d= -f2 | tr -d '[:space:]')
EXPERT_FIELD=$(grep -E "^expert_field=" "$RC_FILE" 2>/dev/null | head -1 | cut -d= -f2 | tr -d '[:space:]')
[ -z "$LEVEL" ] && exit 0

case "$LEVEL" in
  eli5|5)               LABEL="5-year-old"         CMD="/eli5"       HINT="Toys/food/animals. ≤15 words/sentence." ;;
  eli-kid|kid|10)       LABEL="10-year-old"        CMD="/eli-kid"    HINT="School analogies. Cause-effect framing." ;;
  eli-teen|teen|15)     LABEL="15-year-old"        CMD="/eli-teen"   HINT="Pop culture/gaming. Get to the point fast." ;;
  eli-adult|adult)      LABEL="smart non-expert"   CMD="/eli-adult"  HINT="Real-world analogies. No domain knowledge assumed." ;;
  eli-expert|expert)    LABEL="expert bridge"      CMD="/eli-expert" HINT="Use their domain vocabulary as the bridge." ;;
  *) exit 0 ;;
esac

CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
FLAG="$CLAUDE_DIR/.eli5-active.json"
SESSION="${CLAUDE_SESSION_ID:-}"

# Write global flag file (for per-turn hook + statusline)
mkdir -p "$CLAUDE_DIR"
printf '{"level":"%s","label":"%s","session":"%s"}' "$LEVEL" "$LABEL" "$SESSION" > "${FLAG}.tmp" && mv "${FLAG}.tmp" "$FLAG"

# Save expert field if provided
if [ -n "$EXPERT_FIELD" ] && [ "$LEVEL" = "eli-expert" -o "$LEVEL" = "expert" ]; then
  mkdir -p .claude
  printf '%s' "$EXPERT_FIELD" > .claude/eli5-expert-field
fi

# Read core-rules.md at runtime (single source of truth)
# Looks in the skills dir adjacent to this hooks dir, then falls back to minimal inline rules.
SKILL_DIR="$(dirname "$0")/../skills/eli5-mode/references"
CORE_RULES=""
if [ -f "$SKILL_DIR/core-rules.md" ]; then
  CORE_RULES=$(cat "$SKILL_DIR/core-rules.md")
fi

FIELD_CONTEXT=""
if [ -n "$EXPERT_FIELD" ]; then
  FIELD_CONTEXT=" User's expert field: ${EXPERT_FIELD}. Use this vocabulary as your bridge — do not ask for it again."
fi

# Compose context: activation notice + level hint + core rules (once, not per-turn)
CONTEXT="eli5-mode AUTO-ACTIVATED. Level: ${LABEL} (${CMD}).${FIELD_CONTEXT}

Level style: ${HINT}

Your first response must already be in eli5 style. Do not wait for the user to ask."

if [ -n "$CORE_RULES" ]; then
  CONTEXT="${CONTEXT}

${CORE_RULES}"
else
  # Fallback minimal rules if core-rules.md not found
  CONTEXT="${CONTEXT}

Core rules: analogy-first (never define, always compare), kill jargon (replace not explain), short sentences, accurate (simpler ≠ wrong), concrete over abstract (food/toys/buildings not systems), no condescension (ban simply/obviously/just/easy), persist every response, safety exception (warnings always plain first).

Drift protocol: if jargon creeps in, correct immediately. Treat drift as a bug.
Different analogy protocol: if user says 'different analogy', 'that didn't help', 'try again' — generate a completely new analogy, never reuse one from this session.
Deactivate on: stop eli5 · normal mode · talk normally · /eli-off"
fi

cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": $(printf '%s' "$CONTEXT" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')
  }
}
EOF
