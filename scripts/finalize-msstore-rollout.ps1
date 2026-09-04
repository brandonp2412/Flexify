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

function ConvertFrom-StoreJson($Output, [string]$Description) {
  $text = ($Output | ForEach-Object { $_.ToString() }) -join [Environment]::NewLine
  $jsonStart = $text.IndexOf("{")
  $jsonEnd = $text.LastIndexOf("}")

  if ($jsonStart -lt 0 -or $jsonEnd -le $jsonStart) {
    throw "Microsoft Store CLI returned no $Description JSON."
  }

  return $text.Substring($jsonStart, $jsonEnd - $jsonStart + 1) |
    ConvertFrom-Json
}

Set-FinalizedOutput $false

$appResult = Invoke-StoreCommand @(
  "apps", "get", $ProductId, "--verbose"
)

if ($appResult.ExitCode -ne 0) {
  Write-Error "Could not retrieve the Microsoft Store application."
  exit $appResult.ExitCode
}

try {
  $application = ConvertFrom-StoreJson $appResult.Output "application"
} catch {
  Write-Error $_.Exception.Message
  exit 1
}

$submissionId = $application.LastPublishedApplicationSubmission.Id
if (-not $submissionId) {
  Write-Error "Microsoft Store returned no last published submission ID."
  exit 1
}

$getResult = Invoke-StoreCommand @(
  "submission", "rollout", "get", $ProductId,
  "--submissionId", $submissionId, "--verbose"
)

if ($getResult.ExitCode -ne 0) {
  Write-Error "Could not retrieve the Microsoft Store package rollout."
  exit $getResult.ExitCode
}

try {
  $rollout = ConvertFrom-StoreJson $getResult.Output "rollout"
} catch {
  Write-Error $_.Exception.Message
  exit 1
}

if (
  -not $rollout.IsPackageRollout -or
  $rollout.PackageRolloutStatus -eq "PackageRolloutComplete"
) {
  Set-FinalizedOutput $true
  Write-Host "No active Microsoft Store package rollout remains."
  exit 0
}

if ([double]$rollout.packageRolloutPercentage -lt 100) {
  Write-Host "Package rollout is at $($rollout.packageRolloutPercentage)%; waiting for 100%."
  exit 0
}

$finalizeResult = Invoke-StoreCommand @(
  "submission", "rollout", "finalize", $ProductId,
  "--submissionId", $submissionId, "--verbose"
)

if ($finalizeResult.ExitCode -ne 0) {
  Write-Error "Microsoft Store package rollout finalization failed."
  exit $finalizeResult.ExitCode
}

Set-FinalizedOutput $true
Write-Host "Finalized the completed Microsoft Store package rollout."
exit 0
