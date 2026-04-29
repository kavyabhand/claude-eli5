#!/usr/bin/env bash
set -e

SKILLS=(eli5-mode eli-kid eli-teen eli-adult eli-expert)
SKILLS_DIR="${HOME}/.claude/skills"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
success() { printf "${GREEN}  ✓${NC} %s\n" "$*"; }
warn()    { printf "${YELLOW}  !${NC} %s\n" "$*"; }

removed=0
for skill in "${SKILLS[@]}"; do
  dest="${SKILLS_DIR}/${skill}"
  if [ -d "${dest}" ]; then
    rm -rf "${dest}"
    success "Removed ${skill}"
    removed=$((removed + 1))
  fi
done

if [ "${removed}" -eq 0 ]; then
  warn "Nothing to remove — eli5-mode was not installed."
else
  echo ""
  echo "  eli5-mode uninstalled."
fi
