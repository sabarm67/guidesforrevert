# Copies canonical content JSON from content/seed/ into frontend/assets/content/
# so it can be declared as a Flutter asset and bundled into every platform
# build. Re-run this whenever content/seed/ changes.

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir
$src = Join-Path $repoRoot "content\seed"
$dest = Join-Path $repoRoot "frontend\assets\content"

if (Test-Path $dest) {
    Remove-Item -Recurse -Force $dest
}
New-Item -ItemType Directory -Force -Path $dest | Out-Null

Copy-Item -Path (Join-Path $src "*") -Destination $dest -Recurse -Force

Write-Host "Synced content/seed/ -> frontend/assets/content/"
