#Requires -Version 5.1
[CmdletBinding()]
param([switch]$NoHooks)

$ErrorActionPreference = 'Stop'

$Skills     = @('eli5-mode','eli-kid','eli-teen','eli-adult','eli-expert',
                'eli-off','eli-status','eli-deeper','eli-simpler','eli-save','eli-quiz','eli-doc',
                'eli-pr','eli-brief','eli-commit','eli-compare','eli-prereqs','eli-teach',
                'eli-recap','eli-remember','eli-tweet','eli-tldr')
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

# ── Hooks ─────────────────────────────────────────────────────────────────────
if (-not $NoHooks) {
    Write-Host "`n  Installing hooks..."
    if (-not (Test-Path $HooksDir)) { New-Item -ItemType Directory -Path $HooksDir -Force | Out-Null }

    $sessionHookSrc  = Join-Path $ScriptDir 'hooks\eli5-session-start.sh'
    $sessionHookDest = Join-Path $HooksDir  'eli5-session-start.sh'
    $perTurnSrc      = Join-Path $ScriptDir 'hooks\eli5-per-turn.js'
    $perTurnDest     = Join-Path $HooksDir  'eli5-per-turn.js'
    $statuslineSrc   = Join-Path $ScriptDir 'hooks\eli5-statusline.sh'
    $statuslineDest  = Join-Path $HooksDir  'eli5-statusline.sh'

    Copy-Item $sessionHookSrc  $sessionHookDest  -Force; Write-Ok "SessionStart     → $sessionHookDest"
    Copy-Item $perTurnSrc      $perTurnDest      -Force; Write-Ok "UserPromptSubmit → $perTurnDest"
    Copy-Item $statuslineSrc   $statuslineDest   -Force; Write-Ok "Statusline       → $statuslineDest"

    $settingsPath = Join-Path $ClaudeDir 'settings.json'
    if (-not (Test-Path $settingsPath)) { '{}' | Set-Content $settingsPath }

    if (Get-Command node -ErrorAction SilentlyContinue) {
        $sp  = $settingsPath  -replace '\\','\\\\'
        $shp = $sessionHookDest -replace '\\','\\\\'
        $ptp = $perTurnDest     -replace '\\','\\\\'
        $slp = $statuslineDest  -replace '\\','\\\\'
        $nodeScript = @"
const fs = require('fs');
const sp = '$sp', shp = '$shp', ptp = '$ptp', slp = '$slp';
let s = {};
try { s = JSON.parse(fs.readFileSync(sp,'utf8')); } catch {}
s.hooks = s.hooks || {};

s.hooks.SessionStart = s.hooks.SessionStart || [];
const sCmd = 'bash "' + shp + '"';
if (!s.hooks.SessionStart.some(h => h.hooks?.some(hh => hh.command === sCmd)))
  s.hooks.SessionStart.push({hooks:[{type:'command',command:sCmd}]});

s.hooks.UserPromptSubmit = s.hooks.UserPromptSubmit || [];
const ptCmd = 'node "' + ptp + '"';
if (!s.hooks.UserPromptSubmit.some(h => h.hooks?.some(hh => hh.command === ptCmd)))
  s.hooks.UserPromptSubmit.push({hooks:[{type:'command',command:ptCmd}]});

const statuslineSet = !s.statusLine;
if (statuslineSet) s.statusLine = {type:'command',command:'bash "' + slp + '"'};
fs.writeFileSync(sp, JSON.stringify(s,null,2));
console.log(statuslineSet ? 'statusline_set' : 'statusline_skip');
"@
        $result = node -e $nodeScript 2>$null
        Write-Ok "Registered SessionStart + UserPromptSubmit in settings.json"
        if ($result -eq 'statusline_set') {
            Write-Ok "Statusline badge registered [ELI5] / [ELI5:TEEN] etc."
        } else {
            Write-Warn "Statusline already configured — add manually to settings.json if desired:"
            Write-Warn "  `"statusLine`": { `"type`": `"command`", `"command`": `"bash \`"$statuslineDest\`"`" }"
        }
    } else {
        Write-Warn "Node.js not found — add hooks to settings.json manually (see examples/CLAUDE.md)"
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
Write-Host ""
Write-Host "  Learning:   /eli-compare · /eli-prereqs · /eli-teach · /eli-quiz · /eli-recap"
Write-Host "  Formats:    /eli-brief · /eli-tweet · /eli-tldr"
Write-Host "  Workflow:   /eli-pr · /eli-commit"
Write-Host "  Memory:     /eli-remember · /eli-save · /eli-doc [--team]"
Write-Host ""
Write-Host "  Turn off:   /eli-off · stop eli5 · normal mode"
Write-Host ""
Write-Host "  Auto-activate: drop a .eli5rc in your project (see examples/eli5rc-example)"
Write-Host "  Passive mode:  add passive_mode=true to .eli5rc for background jargon nudges"
Write-Host ""
