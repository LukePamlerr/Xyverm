Write-Host "Wyvem scaffold Windows helper"
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
  Write-Host "Docker not found. Please install Docker Desktop for Windows."
  exit 1
}

Write-Host "Copying .env.example to .env"
Copy-Item -Path .\.env.example -Destination .\.env -Force
Write-Host "Run: docker compose up -d --build"
Write-Host "Wyvem scaffold Windows helper"
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
  Write-Host "Docker not found. Please install Docker Desktop for Windows."
  exit 1
}

Write-Host "Copying .env.example to .env"
Copy-Item -Path .\.env.example -Destination .\.env -Force
Write-Host "Run: docker compose up -d --build"
