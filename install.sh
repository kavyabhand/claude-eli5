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

# ── Hooks ─────────────────────────────────────────────────────────────────────
header "  Installing hooks..."
mkdir -p "${HOOKS_DIR}"

SESSION_HOOK_SRC="${REPO_DIR}/hooks/eli5-session-start.sh"
SESSION_HOOK_DEST="${HOOKS_DIR}/eli5-session-start.sh"
PER_TURN_SRC="${REPO_DIR}/hooks/eli5-per-turn.js"
PER_TURN_DEST="${HOOKS_DIR}/eli5-per-turn.js"
STATUSLINE_SRC="${REPO_DIR}/hooks/eli5-statusline.sh"
STATUSLINE_DEST="${HOOKS_DIR}/eli5-statusline.sh"

cp "${SESSION_HOOK_SRC}" "${SESSION_HOOK_DEST}" && chmod +x "${SESSION_HOOK_DEST}"
success "SessionStart  → ${SESSION_HOOK_DEST}"

cp "${PER_TURN_SRC}" "${PER_TURN_DEST}"
success "UserPromptSubmit → ${PER_TURN_DEST}"

cp "${STATUSLINE_SRC}" "${STATUSLINE_DEST}" && chmod +x "${STATUSLINE_DEST}"
success "Statusline    → ${STATUSLINE_DEST}"

# Register hooks in settings.json
SETTINGS="${CLAUDE_DIR}/settings.json"
if [ ! -f "${SETTINGS}" ]; then
  echo '{}' > "${SETTINGS}"
fi

if command -v node >/dev/null 2>&1; then
  node - "${SETTINGS}" "${SESSION_HOOK_DEST}" "${PER_TURN_DEST}" "${STATUSLINE_DEST}" <<'EOF'
const fs = require('fs');
const [,, sp, sessionHook, perTurnHook, statuslineHook] = process.argv;
let s = {};
try { s = JSON.parse(fs.readFileSync(sp, 'utf8')); } catch {}
s.hooks = s.hooks || {};

// SessionStart
s.hooks.SessionStart = s.hooks.SessionStart || [];
const sessionCmd = `bash "${sessionHook}"`;
if (!s.hooks.SessionStart.some(h => h.hooks?.some(hh => hh.command === sessionCmd))) {
  s.hooks.SessionStart.push({ hooks: [{ type: 'command', command: sessionCmd }] });
}

// UserPromptSubmit (per-turn reinforcement)
s.hooks.UserPromptSubmit = s.hooks.UserPromptSubmit || [];
const perTurnCmd = `node "${perTurnHook}"`;
if (!s.hooks.UserPromptSubmit.some(h => h.hooks?.some(hh => hh.command === perTurnCmd))) {
  s.hooks.UserPromptSubmit.push({ hooks: [{ type: 'command', command: perTurnCmd }] });
}

// Statusline — only set if not already configured
if (!s.statusLine) {
  s.statusLine = { type: 'command', command: `bash "${statuslineHook}"` };
  console.log('statusline_set');
} else {
  console.log('statusline_skip');
}

fs.writeFileSync(sp, JSON.stringify(s, null, 2));
EOF
  if [ $? -eq 0 ]; then
    success "Registered SessionStart + UserPromptSubmit in settings.json"
    # Check if statusline was set or skipped (last stdout line)
    STATUSLINE_RESULT=$(node - "${SETTINGS}" "${STATUSLINE_DEST}" <<'JSEOF'
const fs = require('fs');
const [,, sp, sh] = process.argv;
const s = JSON.parse(fs.readFileSync(sp,'utf8'));
console.log(s.statusLine?.command?.includes('eli5-statusline') ? 'active' : 'other');
JSEOF
)
    if [ "${STATUSLINE_RESULT}" = "active" ]; then
      success "Statusline badge registered [ELI5] / [ELI5:TEEN] etc."
    else
      warn "Statusline already configured — add manually to settings.json if desired:"
      warn "  \"statusLine\": { \"type\": \"command\", \"command\": \"bash \\\"${STATUSLINE_DEST}\\\"\" }"
    fi
  fi
else
  warn "Node.js not found — add hooks to settings.json manually (see examples/CLAUDE.md)"
fi

# ── CLAUDE.md patch ───────────────────────────────────────────────────────────
header "  Patching ~/.claude/CLAUDE.md..."
GLOBAL_MD="${CLAUDE_DIR}/CLAUDE.md"
touch "${GLOBAL_MD}"

_append_block() {
  { echo ""; cat "${REPO_DIR}/examples/CLAUDE.md"; echo ""; } >> "${GLOBAL_MD}"
}

if grep -q "<!-- eli5-mode:end -->" "${GLOBAL_MD}" 2>/dev/null; then
  # New-style versioned block exists — replace it
  awk '/^<!-- eli5-mode:start -->/{skip=1; next} /^<!-- eli5-mode:end -->/{skip=0; next} !skip{print}' \
    "${GLOBAL_MD}" > "${GLOBAL_MD}.tmp" && mv "${GLOBAL_MD}.tmp" "${GLOBAL_MD}"
  _append_block
  success "Updated CLAUDE.md block"
elif grep -q "# eli5-mode: auto-activation" "${GLOBAL_MD}" 2>/dev/null; then
  # Old-style block (pre-v2) — find its start line and truncate, then append new
  OLD_LINE=$(grep -n "# eli5-mode: auto-activation" "${GLOBAL_MD}" | head -1 | cut -d: -f1)
  TRIM_TO=$(( OLD_LINE - 2 ))
  [ "${TRIM_TO}" -lt 0 ] && TRIM_TO=0
  head -n "${TRIM_TO}" "${GLOBAL_MD}" > "${GLOBAL_MD}.tmp" && mv "${GLOBAL_MD}.tmp" "${GLOBAL_MD}"
  _append_block
  success "Upgraded CLAUDE.md block (old → new)"
else
  # Fresh install — append
  _append_block
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
