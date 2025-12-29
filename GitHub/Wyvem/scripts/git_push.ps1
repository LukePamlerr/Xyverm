param(
  [string]$RemoteUrl = $null,
  [string]$Branch = 'main',
  [string]$Message = 'Initial Wyvem scaffold: backend, frontend, docs, SSO, migration tools'
)

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
  Write-Error "Git is not installed or not in PATH. Install Git and re-run this script."
  exit 1
}

Push-Location -Path (Resolve-Path ".." ) | Out-Null
try {
  $root = Get-Location
  if (-not (Test-Path (Join-Path $root '.git'))) {
    git init
    Write-Host "Initialized empty git repository."
  }

  if ($RemoteUrl) {
    # set or update origin
    $existing = git remote get-url origin 2>$null
    if ($LASTEXITCODE -eq 0) {
      git remote remove origin
    }
    git remote add origin $RemoteUrl
    Write-Host "Remote 'origin' set to $RemoteUrl"
  }

  git add -A
  git commit -m "$Message" || Write-Host "No changes to commit or commit failed."

  if ($RemoteUrl) {
    git push -u origin $Branch
  } else {
    Write-Host "No remote provided. To push, provide a remote URL: ./scripts/git_push.ps1 -RemoteUrl 'git@github.com:you/repo.git'"
  }
} finally {
  Pop-Location | Out-Null
}
