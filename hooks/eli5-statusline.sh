#!/usr/bin/env bash
# eli5-statusline.sh — statusline badge for Claude Code
#
# Shows current eli5 level in the status bar.
# Configure in ~/.claude/settings.json:
#   "statusLine": { "type": "command", "command": "bash ~/.claude/hooks/eli5-statusline.sh" }

FLAG="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.eli5-active.json"

# Refuse symlinks
[ -L "$FLAG" ] && exit 0
[ ! -f "$FLAG" ] && exit 0

# Read and cap at 256 bytes
RAW=$(head -c 256 "$FLAG" 2>/dev/null | tr -d '\n\r')
[ -z "$RAW" ] && exit 0

# Extract level — only allow known values
LEVEL=$(printf '%s' "$RAW" | grep -o '"level":"[a-z5-]*"' | head -1 | cut -d'"' -f4)

case "$LEVEL" in
  eli5)        printf '\033[38;5;214m[ELI5]\033[0m' ;;
  eli-kid)     printf '\033[38;5;214m[ELI5:KID]\033[0m' ;;
  eli-teen)    printf '\033[38;5;214m[ELI5:TEEN]\033[0m' ;;
  eli-adult)   printf '\033[38;5;214m[ELI5:ADULT]\033[0m' ;;
  eli-expert)  printf '\033[38;5;214m[ELI5:EXPERT]\033[0m' ;;
  *) exit 0 ;;
esac
