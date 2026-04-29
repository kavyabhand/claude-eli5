#!/usr/bin/env bash
set -e

SKILLS=(eli5-mode eli-kid eli-teen eli-adult eli-expert eli-off eli-status eli-deeper eli-simpler eli-save eli-quiz eli-doc)
SKILLS_DIR="${HOME}/.claude/skills"
HOOKS_DIR="${HOME}/.claude/hooks"
CLAUDE_DIR="${HOME}/.claude"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION="$(cat "${REPO_DIR}/VERSION" 2>/dev/null || echo "?")"

# ── Colors ────────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'; BLUE='\033[0;34m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BOLD='\033[1m'; NC='\033[0m'
info()    { printf "${BLUE}  →${NC} %s\n" "$*"; }
success() { printf "${GREEN}  ✓${NC} %s\n" "$*"; }
warn()    { printf "${YELLOW}  !${NC} %s\n" "$*"; }
error()   { printf "${RED}  ✗${NC} %s\n" "$*"; exit 1; }
header()  { printf "\n${BOLD}%s${NC}\n" "$*"; }

echo ""
printf "${BOLD}  eli5-mode v${VERSION} installer${NC}\n"
echo "  ──────────────────────────────"
echo ""

command -v claude >/dev/null 2>&1 || error "claude not found. Install Claude Code: https://claude.ai/code"

# ── Skills ────────────────────────────────────────────────────────────────────
header "  Installing skills..."
mkdir -p "${SKILLS_DIR}"

for skill in "${SKILLS[@]}"; do
  src="${REPO_DIR}/skills/${skill}"
  dest="${SKILLS_DIR}/${skill}"

  if [ ! -d "${src}" ]; then
    warn "Skill source not found: ${src}"
    continue
  fi

  [ -d "${dest}" ] && rm -rf "${dest}"
  cp -r "${src}" "${dest}"
  success "${skill}"
done

# ── Hook ──────────────────────────────────────────────────────────────────────
header "  Installing SessionStart hook..."
mkdir -p "${HOOKS_DIR}"

HOOK_SRC="${REPO_DIR}/hooks/eli5-session-start.sh"
HOOK_DEST="${HOOKS_DIR}/eli5-session-start.sh"

cp "${HOOK_SRC}" "${HOOK_DEST}"
chmod +x "${HOOK_DEST}"
success "Hook → ${HOOK_DEST}"

# Register hook in settings.json
SETTINGS="${CLAUDE_DIR}/settings.json"
if [ ! -f "${SETTINGS}" ]; then
  echo '{}' > "${SETTINGS}"
fi

if command -v node >/dev/null 2>&1; then
  node - "${SETTINGS}" "${HOOK_DEST}" <<'EOF'
const fs = require('fs');
const [,, settingsPath, hookPath] = process.argv;
let s = {};
try { s = JSON.parse(fs.readFileSync(settingsPath, 'utf8')); } catch {}
s.hooks = s.hooks || {};
s.hooks.SessionStart = s.hooks.SessionStart || [];
const cmd = `bash "${hookPath}"`;
const already = s.hooks.SessionStart.some(h => h.hooks?.some(hh => hh.command === cmd));
if (!already) {
  s.hooks.SessionStart.push({ hooks: [{ type: 'command', command: cmd }] });
}
fs.writeFileSync(settingsPath, JSON.stringify(s, null, 2));
console.log('ok');
EOF
  success "Registered in settings.json"
else
  warn "Node.js not found — add the hook to settings.json manually (see examples/CLAUDE.md)"
fi

# ── CLAUDE.md patch ───────────────────────────────────────────────────────────
header "  Patching ~/.claude/CLAUDE.md..."
GLOBAL_MD="${CLAUDE_DIR}/CLAUDE.md"
MARKER="## eli5-mode"

if grep -q "${MARKER}" "${GLOBAL_MD}" 2>/dev/null; then
  warn "eli5-mode block already present in CLAUDE.md — skipping"
else
  {
    echo ""
    cat "${REPO_DIR}/examples/CLAUDE.md"
    echo ""
  } >> "${GLOBAL_MD}"
  success "Patched CLAUDE.md"
fi

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo "  ──────────────────────────────"
printf "  ${GREEN}${BOLD}All done.${NC} Start a new Claude Code session.\n"
echo ""
echo "  Activate:   eli5 · ELI5 · /eli5 · dumb it down · explain simply"
echo "  Levels:     /eli-kid · /eli-teen · /eli-adult · /eli-expert"
echo "  Navigate:   /eli-deeper · /eli-simpler"
echo "  Utilities:  /eli-status · /eli-save · /eli-quiz · /eli-doc"
echo "  Turn off:   /eli-off · stop eli5 · normal mode"
echo ""
echo "  Auto-activate: drop a .eli5rc in your project (see examples/eli5rc-example)"
echo ""
