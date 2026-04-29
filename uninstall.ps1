#Requires -Version 5.1
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$SkillName = 'eli5-mode'
$Dest      = Join-Path $env:USERPROFILE ".claude\skills\$SkillName"

if (-not (Test-Path $Dest)) {
    Write-Host "$SkillName is not installed."
    exit 0
}

Remove-Item -Recurse -Force $Dest
Write-Host "Uninstalled $SkillName."
