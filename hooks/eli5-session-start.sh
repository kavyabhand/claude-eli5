#!/usr/bin/env bash
# eli5-session-start.sh
# SessionStart hook: auto-activates eli5-mode if .eli5rc is present in the
# current project directory or in the home directory.

RC_FILE=""

if [ -f ".eli5rc" ]; then
  RC_FILE=".eli5rc"
elif [ -f "$HOME/.eli5rc" ]; then
  RC_FILE="$HOME/.eli5rc"
fi

# No config found — do nothing
[ -z "$RC_FILE" ] && exit 0

# Parse config
LEVEL=$(grep -E "^level=" "$RC_FILE" 2>/dev/null | head -1 | cut -d= -f2 | tr -d '[:space:]')
EXPERT_FIELD=$(grep -E "^expert_field=" "$RC_FILE" 2>/dev/null | head -1 | cut -d= -f2 | tr -d '[:space:]')

[ -z "$LEVEL" ] && exit 0

# Map to display name
case "$LEVEL" in
  eli5|5)              LABEL="5-year-old"         CMD="/eli5"      ;;
  eli-kid|kid|10)      LABEL="10-year-old"        CMD="/eli-kid"   ;;
  eli-teen|teen|15)    LABEL="15-year-old"        CMD="/eli-teen"  ;;
  eli-adult|adult)     LABEL="smart non-expert"   CMD="/eli-adult" ;;
  eli-expert|expert)   LABEL="expert bridge"      CMD="/eli-expert" ;;
  *) exit 0 ;;
esac

FIELD_CONTEXT=""
if [ -n "$EXPERT_FIELD" ] && [ "$LEVEL" = "eli-expert" -o "$LEVEL" = "expert" ]; then
  FIELD_CONTEXT=" The user's expert field is: ${EXPERT_FIELD}. Use this field's vocabulary as the bridge — do not ask for it again."
  # Save it for the session
  mkdir -p .claude
  printf '%s' "$EXPERT_FIELD" > .claude/eli5-expert-field
fi

# Write state file for /eli-status
mkdir -p .claude
printf '{"level":"%s","label":"%s"}' "$LEVEL" "$LABEL" > .claude/eli5-state.json

cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "eli5-mode is AUTO-ACTIVATED. Level: ${LABEL} (${CMD}).${FIELD_CONTEXT}\n\nApply all eli5-mode communication rules from this point forward — do NOT wait for the user to ask. Your first response must already be in eli5 style at the ${LABEL} level.\n\nRules: analogy-first, kill jargon, short sentences, accurate, concrete over abstract, no condescension, persistent every response, safety exception for destructive actions.\n\nThe user configured this project with .eli5rc. Treat it as if they typed ${CMD} at the start of this session."
  }
}
EOF
