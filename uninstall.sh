#!/usr/bin/env bash
set -e

SKILLS=(eli5-mode eli-kid eli-teen eli-adult eli-expert eli-off eli-status eli-deeper eli-simpler eli-save eli-quiz eli-doc)
CLAUDE_DIR="${HOME}/.claude"
SKILLS_DIR="${CLAUDE_DIR}/skills"
HOOKS_DIR="${CLAUDE_DIR}/hooks"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
success() { printf "${GREEN}  ✓${NC} %s\n" "$*"; }
warn()    { printf "${YELLOW}  !${NC} %s\n" "$*"; }

removed=0

# Remove skills
for skill in "${SKILLS[@]}"; do
  dest="${SKILLS_DIR}/${skill}"
  if [ -d "${dest}" ]; then
    rm -rf "${dest}"
    success "Removed skill: ${skill}"
    removed=$((removed + 1))
  fi
done

# Remove hooks
for hook_file in eli5-session-start.sh eli5-per-turn.js eli5-statusline.sh; do
  HOOK="${HOOKS_DIR}/${hook_file}"
  if [ -f "${HOOK}" ]; then
    rm -f "${HOOK}"
    success "Removed ${hook_file}"
  fi
done

# Remove hooks + statusline from settings.json
SETTINGS="${CLAUDE_DIR}/settings.json"
if [ -f "${SETTINGS}" ] && command -v node >/dev/null 2>&1; then
  node - "${SETTINGS}" <<'EOF'
const fs = require('fs');
const [,, sp] = process.argv;
let s = {};
try { s = JSON.parse(fs.readFileSync(sp, 'utf8')); } catch { process.exit(0); }

if (s.hooks?.SessionStart) {
  s.hooks.SessionStart = s.hooks.SessionStart.filter(
    h => !h.hooks?.some(hh => hh.command?.includes('eli5-session-start'))
  );
  if (s.hooks.SessionStart.length === 0) delete s.hooks.SessionStart;
}

if (s.hooks?.UserPromptSubmit) {
  s.hooks.UserPromptSubmit = s.hooks.UserPromptSubmit.filter(
    h => !h.hooks?.some(hh => hh.command?.includes('eli5-per-turn'))
  );
  if (s.hooks.UserPromptSubmit.length === 0) delete s.hooks.UserPromptSubmit;
}

if (s.statusLine?.command?.includes('eli5-statusline')) {
  delete s.statusLine;
}

if (Object.keys(s.hooks || {}).length === 0) delete s.hooks;
fs.writeFileSync(sp, JSON.stringify(s, null, 2));
EOF
  success "Removed from settings.json"
fi

if [ "${removed}" -eq 0 ]; then
  warn "No eli5-mode skills found — was it installed?"
else
  echo ""
  echo "  eli5-mode uninstalled."
  warn "CLAUDE.md patch was not removed — remove the '## eli5-mode' block manually if needed."
fi
