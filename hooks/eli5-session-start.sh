#!/usr/bin/env bash
# eli5-session-start.sh — SessionStart hook
#
# Auto-activates eli5-mode if .eli5rc is found in the project dir or ~/.eli5rc.
# Also reads passive_mode and proactive flags for background jargon awareness.
# Writes ~/.claude/.eli5-active.json for per-turn hook + statusline to read.
# Reads core-rules.md at runtime so edits propagate without reinstall.

RC_FILE=""
[ -f ".eli5rc" ]        && RC_FILE=".eli5rc"
[ -z "$RC_FILE" ] && [ -f "$HOME/.eli5rc" ] && RC_FILE="$HOME/.eli5rc"
[ -z "$RC_FILE" ] && exit 0

LEVEL=$(grep -E "^level=" "$RC_FILE" 2>/dev/null | head -1 | cut -d= -f2 | tr -d '[:space:]')
EXPERT_FIELD=$(grep -E "^expert_field=" "$RC_FILE" 2>/dev/null | head -1 | cut -d= -f2 | tr -d '[:space:]')
PASSIVE_MODE=$(grep -E "^passive_mode=" "$RC_FILE" 2>/dev/null | head -1 | cut -d= -f2 | tr -d '[:space:]')
PROACTIVE=$(grep -E "^proactive=" "$RC_FILE" 2>/dev/null | head -1 | cut -d= -f2 | tr -d '[:space:]')

# Exit if nothing to do
[ -z "$LEVEL" ] && [ "$PASSIVE_MODE" != "true" ] && [ "$PROACTIVE" != "true" ] && exit 0

CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
FLAG="$CLAUDE_DIR/.eli5-active.json"
SESSION="${CLAUDE_SESSION_ID:-}"
SKILL_DIR="$(dirname "$0")/../skills/eli5-mode/references"

# ── Level activation ──────────────────────────────────────────────────────────

LABEL="" CMD="" HINT=""
if [ -n "$LEVEL" ]; then
  case "$LEVEL" in
    eli5|5)               LABEL="5-year-old"         CMD="/eli5"       HINT="Toys/food/animals. ≤15 words/sentence." ;;
    eli-kid|kid|10)       LABEL="10-year-old"        CMD="/eli-kid"    HINT="School analogies. Cause-effect framing." ;;
    eli-teen|teen|15)     LABEL="15-year-old"        CMD="/eli-teen"   HINT="Pop culture/gaming. Get to the point fast." ;;
    eli-adult|adult)      LABEL="smart non-expert"   CMD="/eli-adult"  HINT="Real-world analogies. No domain knowledge assumed." ;;
    eli-expert|expert)    LABEL="expert bridge"      CMD="/eli-expert" HINT="Use their domain vocabulary as the bridge." ;;
    *) LEVEL="" ;;
  esac
fi

# Write global flag file (for per-turn hook + statusline)
if [ -n "$LEVEL" ]; then
  mkdir -p "$CLAUDE_DIR"
  printf '{"level":"%s","label":"%s","session":"%s"}' "$LEVEL" "$LABEL" "$SESSION" \
    > "${FLAG}.tmp" && mv "${FLAG}.tmp" "$FLAG"
fi

# Save expert field if provided
if [ -n "$EXPERT_FIELD" ] && [ "$LEVEL" = "eli-expert" -o "$LEVEL" = "expert" ]; then
  mkdir -p .claude
  printf '%s' "$EXPERT_FIELD" > .claude/eli5-expert-field
fi

# ── Compose context ───────────────────────────────────────────────────────────

CONTEXT=""

# Active level context
if [ -n "$LEVEL" ]; then
  FIELD_CONTEXT=""
  if [ -n "$EXPERT_FIELD" ]; then
    FIELD_CONTEXT=" User's expert field: ${EXPERT_FIELD}. Use this vocabulary as your bridge — do not ask for it again."
  fi

  CORE_RULES=""
  if [ -f "$SKILL_DIR/core-rules.md" ]; then
    CORE_RULES=$(cat "$SKILL_DIR/core-rules.md")
  fi

  CONTEXT="eli5-mode AUTO-ACTIVATED. Level: ${LABEL} (${CMD}).${FIELD_CONTEXT}

Level style: ${HINT}

Your first response must already be in eli5 style. Do not wait for the user to ask."

  if [ -n "$CORE_RULES" ]; then
    CONTEXT="${CONTEXT}

${CORE_RULES}"
  else
    CONTEXT="${CONTEXT}

Core rules: analogy-first (never define, always compare), kill jargon (replace not explain), short sentences, accurate (simpler ≠ wrong), concrete over abstract (food/toys/buildings not systems), no condescension (ban simply/obviously/just/easy), persist every response, safety exception (warnings always plain first).

Drift protocol: if jargon creeps in, correct immediately. Treat drift as a bug.
Different analogy protocol: if user says 'different analogy', 'that didn't help', 'try again' — generate a completely new analogy, never reuse one from this session.
Deactivate on: stop eli5 · normal mode · talk normally · /eli-off"
  fi
fi

# Passive jargon scan (works even without a level — background mode)
if [ "$PASSIVE_MODE" = "true" ]; then
  PASSIVE_CTX="PASSIVE JARGON SCAN ACTIVE: After each response, review what you wrote. If you used any unexplained technical term, append a brief plain-language note at the end using this format: '📌 Quick note: [term] = [plain-language equivalent in ≤ 10 words]'. Only add the note if there's actual unexplained jargon — don't add it to simple responses."
  if [ -n "$CONTEXT" ]; then
    CONTEXT="${CONTEXT}

${PASSIVE_CTX}"
  else
    CONTEXT="$PASSIVE_CTX"
  fi
fi

# Proactive eli5 offer (works even without a level)
if [ "$PROACTIVE" = "true" ]; then
  PROACTIVE_CTX="PROACTIVE ELI5 ACTIVE: When you use a technical term for the first time in this session (not already discussed), add exactly one line after your response: '→ Want me to eli5 [term]?' Choose only the single most unfamiliar-looking term per response. Do not add this line if the response is already in eli5 style."
  if [ -n "$CONTEXT" ]; then
    CONTEXT="${CONTEXT}

${PROACTIVE_CTX}"
  else
    CONTEXT="$PROACTIVE_CTX"
  fi
fi

[ -z "$CONTEXT" ] && exit 0

cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": $(printf '%s' "$CONTEXT" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')
  }
}
EOF
