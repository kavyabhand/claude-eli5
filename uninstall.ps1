#Requires -Version 5.1
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$Skills    = @('eli5-mode','eli-kid','eli-teen','eli-adult','eli-expert',
               'eli-off','eli-status','eli-deeper','eli-simpler','eli-save','eli-quiz','eli-doc',
               'eli-pr','eli-brief','eli-commit','eli-compare','eli-prereqs','eli-teach',
               'eli-recap','eli-remember','eli-tweet','eli-tldr')
$ClaudeDir = Join-Path $env:USERPROFILE '.claude'
$SkillsDir = Join-Path $ClaudeDir 'skills'
$removed   = 0

function Write-Ok   ($msg) { Write-Host "  ✓ $msg" -ForegroundColor Green }
function Write-Warn ($msg) { Write-Host "  ! $msg" -ForegroundColor Yellow }

foreach ($skill in $Skills) {
    $dest = Join-Path $SkillsDir $skill
    if (Test-Path $dest) {
        Remove-Item -Recurse -Force $dest
        Write-Ok "Removed skill: $skill"
        $removed++
    }
}

foreach ($hookFile in @('eli5-session-start.sh','eli5-per-turn.js','eli5-statusline.sh')) {
    $hook = Join-Path $ClaudeDir "hooks\$hookFile"
    if (Test-Path $hook) {
        Remove-Item -Force $hook
        Write-Ok "Removed $hookFile"
    }
}

$settingsPath = Join-Path $ClaudeDir 'settings.json'
if ((Test-Path $settingsPath) -and (Get-Command node -ErrorAction SilentlyContinue)) {
    $sp = $settingsPath -replace '\\','\\\\'
    $nodeScript = @"
const fs = require('fs');
const sp = '$sp';
let s = {};
try { s = JSON.parse(fs.readFileSync(sp,'utf8')); } catch { process.exit(0); }

if (s.hooks?.SessionStart) {
  s.hooks.SessionStart = s.hooks.SessionStart.filter(
    h => !h.hooks?.some(hh => hh.command?.includes('eli5-session-start')));
  if (s.hooks.SessionStart.length === 0) delete s.hooks.SessionStart;
}
if (s.hooks?.UserPromptSubmit) {
  s.hooks.UserPromptSubmit = s.hooks.UserPromptSubmit.filter(
    h => !h.hooks?.some(hh => hh.command?.includes('eli5-per-turn')));
  if (s.hooks.UserPromptSubmit.length === 0) delete s.hooks.UserPromptSubmit;
}
if (s.statusLine?.command?.includes('eli5-statusline')) delete s.statusLine;
if (Object.keys(s.hooks || {}).length === 0) delete s.hooks;
fs.writeFileSync(sp, JSON.stringify(s,null,2));
"@
    node -e $nodeScript 2>$null
    Write-Ok "Removed from settings.json"
}

if ($removed -eq 0) {
    Write-Warn "No eli5-mode skills found — was it installed?"
} else {
    Write-Host ""
    Write-Host "  eli5-mode uninstalled."
    Write-Warn "CLAUDE.md patch was not removed — remove the '## eli5-mode' block manually if needed."
}
