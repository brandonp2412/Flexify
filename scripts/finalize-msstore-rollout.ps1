param(
  [Parameter(Mandatory = $true)]
  [string]$ProductId
)

$ErrorActionPreference = "Continue"
$PSNativeCommandUseErrorActionPreference = $false

function Set-FinalizedOutput([bool]$finalized) {
  if ($env:GITHUB_OUTPUT) {
    $value = $finalized.ToString().ToLowerInvariant()
    Add-Content -Path $env:GITHUB_OUTPUT -Value "finalized=$value"
  }
}

& msstore submission rollout finalize $ProductId 2>&1 |
  ForEach-Object { Write-Host $_.ToString() }
$commandExitCode = $LASTEXITCODE

if ($commandExitCode -eq 0) {
  Set-FinalizedOutput $true
  Write-Host "Finalized the completed Microsoft Store package rollout."
} else {
  Set-FinalizedOutput $false
  Write-Host "No package rollout is ready to finalize; leaving it unchanged."
}

exit 0
