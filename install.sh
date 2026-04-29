#!/usr/bin/env bash
set -e

SKILLS=(eli5-mode eli-kid eli-teen eli-adult eli-expert)
SKILLS_DIR="${HOME}/.claude/skills"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Colors ────────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'; BLUE='\033[0;34m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
info()    { printf "${BLUE}  →${NC} %s\n" "$*"; }
success() { printf "${GREEN}  ✓${NC} %s\n" "$*"; }
warn()    { printf "${YELLOW}  !${NC} %s\n" "$*"; }
error()   { printf "${RED}  ✗${NC} %s\n" "$*"; exit 1; }

echo ""
echo "  eli5-mode installer"
echo "  ───────────────────"
echo ""

command -v claude >/dev/null 2>&1 || error "claude not found. Install Claude Code first: https://claude.ai/code"

mkdir -p "${SKILLS_DIR}"

for skill in "${SKILLS[@]}"; do
  src="${REPO_DIR}/skills/${skill}"
  dest="${SKILLS_DIR}/${skill}"

  if [ ! -d "${src}" ]; then
    warn "Skill not found at ${src} — skipping."
    continue
  fi

  if [ -d "${dest}" ]; then
    info "Updating ${skill}..."
    rm -rf "${dest}"
  else
    info "Installing ${skill}..."
  fi

  cp -r "${src}" "${dest}"
  success "${skill} → ${dest}"
done

echo ""
echo "  All done. Start a new Claude Code session and try:"
echo ""
echo "    /eli5          → 5-year-old level (default)"
echo "    /eli-kid       → 10-year-old"
echo "    /eli-teen      → 15-year-old"
echo "    /eli-adult     → smart non-expert"
echo "    /eli-expert    → expert in adjacent field"
echo ""
echo "  Or just say: eli5, dumb it down, explain like i'm 5"
echo ""
