#Requires -Version 5.1
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$Skills    = @('eli5-mode', 'eli-kid', 'eli-teen', 'eli-adult', 'eli-expert')
$SkillsDir = Join-Path $env:USERPROFILE '.claude\skills'
$removed   = 0

foreach ($skill in $Skills) {
    $dest = Join-Path $SkillsDir $skill
    if (Test-Path $dest) {
        Remove-Item -Recurse -Force $dest
        Write-Host "  ✓ Removed ${skill}" -ForegroundColor Green
        $removed++
    }
}

if ($removed -eq 0) {
    Write-Host "  ! Nothing to remove — eli5-mode was not installed." -ForegroundColor Yellow
} else {
    Write-Host ""
    Write-Host "  eli5-mode uninstalled."
}
