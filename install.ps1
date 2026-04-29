#Requires -Version 5.1
[CmdletBinding()]
param([switch]$NoHooks)

$ErrorActionPreference = 'Stop'

$Skills     = @('eli5-mode','eli-kid','eli-teen','eli-adult','eli-expert',
                'eli-off','eli-status','eli-deeper','eli-simpler','eli-save','eli-quiz','eli-doc')
$ClaudeDir  = Join-Path $env:USERPROFILE '.claude'
$SkillsDir  = Join-Path $ClaudeDir 'skills'
$HooksDir   = Join-Path $ClaudeDir 'hooks'
$ScriptDir  = Split-Path -Parent $MyInvocation.MyCommand.Path
$Version    = (Get-Content (Join-Path $ScriptDir 'VERSION') -ErrorAction SilentlyContinue) ?? '?'

function Write-Step  ($msg) { Write-Host "  → $msg" -ForegroundColor Cyan }
function Write-Ok    ($msg) { Write-Host "  ✓ $msg" -ForegroundColor Green }
function Write-Warn  ($msg) { Write-Host "  ! $msg" -ForegroundColor Yellow }
function Write-Fail  ($msg) { Write-Host "  ✗ $msg" -ForegroundColor Red; exit 1 }

Write-Host ""
Write-Host "  eli5-mode v$Version installer" -ForegroundColor White
Write-Host "  ------------------------------"
Write-Host ""

if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    Write-Fail "claude not found. Install Claude Code: https://claude.ai/code"
}

# ── Skills ────────────────────────────────────────────────────────────────────
Write-Host "`n  Installing skills..."
if (-not (Test-Path $SkillsDir)) { New-Item -ItemType Directory -Path $SkillsDir -Force | Out-Null }

foreach ($skill in $Skills) {
    $src  = Join-Path $ScriptDir "skills\$skill"
    $dest = Join-Path $SkillsDir $skill

    if (-not (Test-Path $src -PathType Container)) {
        Write-Warn "Skill source not found: $src"
        continue
    }

    if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
    Copy-Item -Recurse $src $dest
    Write-Ok $skill
}

# ── Hook ──────────────────────────────────────────────────────────────────────
if (-not $NoHooks) {
    Write-Host "`n  Installing SessionStart hook..."
    if (-not (Test-Path $HooksDir)) { New-Item -ItemType Directory -Path $HooksDir -Force | Out-Null }

    $hookSrc  = Join-Path $ScriptDir 'hooks\eli5-session-start.sh'
    $hookDest = Join-Path $HooksDir  'eli5-session-start.sh'
    Copy-Item $hookSrc $hookDest -Force
    Write-Ok "Hook → $hookDest"

    # Register in settings.json via Node if available
    $settingsPath = Join-Path $ClaudeDir 'settings.json'
    if (-not (Test-Path $settingsPath)) { '{}' | Set-Content $settingsPath }

    if (Get-Command node -ErrorAction SilentlyContinue) {
        $nodeScript = @"
const fs = require('fs');
const sp = '$($settingsPath -replace '\\','\\\\')';
const hp = '$($hookDest -replace '\\','\\\\')';
let s = {};
try { s = JSON.parse(fs.readFileSync(sp,'utf8')); } catch {}
s.hooks = s.hooks || {};
s.hooks.SessionStart = s.hooks.SessionStart || [];
const cmd = 'bash "' + hp + '"';
const already = s.hooks.SessionStart.some(h => h.hooks?.some(hh => hh.command === cmd));
if (!already) s.hooks.SessionStart.push({hooks:[{type:'command',command:cmd}]});
fs.writeFileSync(sp, JSON.stringify(s,null,2));
console.log('ok');
"@
        $result = node -e $nodeScript 2>$null
        if ($result -eq 'ok') { Write-Ok "Registered in settings.json" }
        else { Write-Warn "Could not auto-register hook — add manually (see examples/CLAUDE.md)" }
    } else {
        Write-Warn "Node.js not found — add hook to settings.json manually (see examples/CLAUDE.md)"
    }
}

# ── CLAUDE.md patch ───────────────────────────────────────────────────────────
Write-Host "`n  Patching ~/.claude/CLAUDE.md..."
$globalMd  = Join-Path $ClaudeDir 'CLAUDE.md'
$exampleMd = Join-Path $ScriptDir 'examples\CLAUDE.md'
$newBlock  = "`n" + (Get-Content $exampleMd -Raw) + "`n"

if (-not (Test-Path $globalMd)) { '' | Set-Content $globalMd }
$existing = Get-Content $globalMd -Raw

if ($existing -match '(?s)<!-- eli5-mode:start -->.*?<!-- eli5-mode:end -->') {
    # New-style versioned block — replace it
    $updated = $existing -replace '(?s)\n?<!-- eli5-mode:start -->.*?<!-- eli5-mode:end -->\n?', ''
    Set-Content $globalMd ($updated.TrimEnd())
    Add-Content $globalMd $newBlock
    Write-Ok "Updated CLAUDE.md block"
} elseif ($existing -match '# eli5-mode: auto-activation') {
    # Old-style block (pre-v2) — remove old block and append new
    $lines    = Get-Content $globalMd
    $oldLine  = ($lines | Select-String '# eli5-mode: auto-activation' | Select-Object -First 1).LineNumber
    $trimTo   = [Math]::Max(0, $oldLine - 3)
    $lines[0..($trimTo)] | Set-Content $globalMd
    Add-Content $globalMd $newBlock
    Write-Ok "Upgraded CLAUDE.md block (old -> new)"
} else {
    Add-Content $globalMd $newBlock
    Write-Ok "Patched CLAUDE.md"
}

# ── Done ──────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  ------------------------------"
Write-Host "  All done. Start a new Claude Code session." -ForegroundColor Green
Write-Host ""
Write-Host "  Activate:   eli5 · ELI5 · /eli5 · dumb it down · explain simply"
Write-Host "  Levels:     /eli-kid · /eli-teen · /eli-adult · /eli-expert"
Write-Host "  Navigate:   /eli-deeper · /eli-simpler"
Write-Host "  Utilities:  /eli-status · /eli-save · /eli-quiz · /eli-doc"
Write-Host "  Turn off:   /eli-off · stop eli5 · normal mode"
Write-Host ""
Write-Host "  Auto-activate: drop a .eli5rc in your project (see examples/eli5rc-example)"
Write-Host ""
