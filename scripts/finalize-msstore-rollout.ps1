param(
  [Parameter(Mandatory = $true)]
  [string]$ProductId
)

$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $false

function Set-FinalizedOutput([bool]$finalized) {
  if ($env:GITHUB_OUTPUT) {
    $value = $finalized.ToString().ToLowerInvariant()
    Add-Content -Path $env:GITHUB_OUTPUT -Value "finalized=$value"
  }
}

function Invoke-StoreCommand([string[]]$Arguments) {
  $output = @(& msstore @Arguments 2>&1)
  $exitCode = $LASTEXITCODE
  $output | ForEach-Object { Write-Host $_.ToString() }

  return @{
    ExitCode = $exitCode
    Output = $output
  }
}

Set-FinalizedOutput $false

$getResult = Invoke-StoreCommand @(
  "submission", "rollout", "get", $ProductId, "--verbose"
)

if ($getResult.ExitCode -ne 0) {
  Write-Error "Could not retrieve the Microsoft Store package rollout."
  exit $getResult.ExitCode
}

$rolloutJson = $getResult.Output |
  ForEach-Object { $_.ToString().Trim() } |
  Where-Object { $_.StartsWith("{") -and $_.EndsWith("}") } |
  Select-Object -Last 1

if (-not $rolloutJson) {
  Write-Error "Microsoft Store CLI returned no rollout JSON."
  exit 1
}

try {
  $rollout = $rolloutJson | ConvertFrom-Json
} catch {
  Write-Error "Microsoft Store CLI returned invalid rollout JSON: $($_.Exception.Message)"
  exit 1
}

if (-not $rollout.isPackageRollout) {
  Set-FinalizedOutput $true
  Write-Host "No active Microsoft Store package rollout remains."
  exit 0
}

if ([double]$rollout.packageRolloutPercentage -lt 100) {
  Write-Host "Package rollout is at $($rollout.packageRolloutPercentage)%; waiting for 100%."
  exit 0
}

$finalizeResult = Invoke-StoreCommand @(
  "submission", "rollout", "finalize", $ProductId, "--verbose"
)

if ($finalizeResult.ExitCode -ne 0) {
  Write-Error "Microsoft Store package rollout finalization failed."
  exit $finalizeResult.ExitCode
}

Set-FinalizedOutput $true
Write-Host "Finalized the completed Microsoft Store package rollout."
exit 0
