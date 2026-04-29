#Requires -Version 5.1
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$Skills    = @('eli5-mode', 'eli-kid', 'eli-teen', 'eli-adult', 'eli-expert')
$SkillsDir = Join-Path $env:USERPROFILE '.claude\skills'
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host ""
Write-Host "  eli5-mode installer"
Write-Host "  -------------------"
Write-Host ""

if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    Write-Error "claude not found. Install Claude Code first: https://claude.ai/code"
    exit 1
}

if (-not (Test-Path $SkillsDir)) {
    New-Item -ItemType Directory -Path $SkillsDir -Force | Out-Null
}

foreach ($skill in $Skills) {
    $src  = Join-Path $ScriptDir "skills\$skill"
    $dest = Join-Path $SkillsDir $skill

    if (-not (Test-Path $src -PathType Container)) {
        Write-Host "  ! Skill not found at ${src} — skipping." -ForegroundColor Yellow
        continue
    }

    if (Test-Path $dest) {
        Write-Host "  → Updating ${skill}..." -ForegroundColor Cyan
        Remove-Item -Recurse -Force $dest
    } else {
        Write-Host "  → Installing ${skill}..." -ForegroundColor Cyan
    }

    Copy-Item -Recurse $src $dest
    Write-Host "  ✓ ${skill} → ${dest}" -ForegroundColor Green
}

Write-Host ""
Write-Host "  All done. Start a new Claude Code session and try:"
Write-Host ""
Write-Host "    /eli5          -> 5-year-old level (default)"
Write-Host "    /eli-kid       -> 10-year-old"
Write-Host "    /eli-teen      -> 15-year-old"
Write-Host "    /eli-adult     -> smart non-expert"
Write-Host "    /eli-expert    -> expert in adjacent field"
Write-Host ""
Write-Host "  Or just say: eli5, dumb it down, explain like i'm 5"
Write-Host ""
