#Requires -Version 5.1
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$SkillName  = 'eli5-mode'
$SkillsDir  = Join-Path $env:USERPROFILE '.claude\skills'
$Dest       = Join-Path $SkillsDir $SkillName
$ScriptDir  = Split-Path -Parent $MyInvocation.MyCommand.Path
$Source     = Join-Path $ScriptDir $SkillName

Write-Host "Installing $SkillName..."

if (-not (Test-Path $Source -PathType Container)) {
    Write-Error "Skill directory not found at: $Source`nRun this script from the root of the cloned repository."
    exit 1
}

if (-not (Test-Path $SkillsDir)) {
    New-Item -ItemType Directory -Path $SkillsDir -Force | Out-Null
}

if (Test-Path $Dest) {
    Write-Host "Existing install found — replacing it."
    Remove-Item -Recurse -Force $Dest
}

Copy-Item -Recurse $Source $Dest

Write-Host "Done. $SkillName installed to $Dest"
Write-Host ""
Write-Host "Start a new Claude Code session and say 'eli5' to activate."
