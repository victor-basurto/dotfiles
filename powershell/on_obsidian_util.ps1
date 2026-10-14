# Helper function to dynamically resolve the vault path and prevent null parameter errors
function Get-ObsidianVaultPath {
  if ($env:GDRIVE) {
    return (Join-Path $env:GDRIVE 'obsidian-work')
  }

  # Fallback default if $env:GDRIVE is not defined in current session
  return (Join-Path $HOME 'Google Drive\obsidian-work')
}

function on {
param (
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Title
  )

  if ([string]::IsNullOrWhiteSpace($Title)) {
    Write-Error "Error: A file name must be set, e.g. 'on \"Newtons Laws of Motion\"'"
        return
  }

  $vaultPath = Get-ObsidianVaultPath
  $inboxPath = Join-Path $vaultPath 'inbox'

  # 'Newtons Laws of Motion' -> 'Newtons-Laws-of-Motion'
  $filename = $Title -replace ' ', '-'
  $date = Get-Date -Format 'yyyy-MM-dd'

  # e.g. 2026-04-27_Newtons-Laws-of-Motion.md
  $formattedFileName = "${date}_${filename}.md"
  $stem = [System.IO.Path]::GetFileNameWithoutExtension($formattedFileName)
  $fullFilePath = Join-Path $inboxPath $formattedFileName

  # Clean title: "newtons-laws-of-motion" -> "Newtons Laws Of Motion"
  $textInfo = (Get-Culture).TextInfo
  $cleanTitle = $textInfo.ToTitleCase($Title)

  # Ensure base vault directory exists before switching locations
  if (-not (Test-Path $vaultPath)) {
    New-Item -ItemType Directory -Path $vaultPath | Out-Null
  }

  Set-Location -Path $vaultPath

  if (-not (Test-Path $inboxPath)) {
    New-Item -ItemType Directory -Path $inboxPath | Out-Null
  }

  if (-not (Test-Path $fullFilePath)) {
    New-Item -ItemType File -Path $fullFilePath | Out-Null
  }

  # Build the nvim ex-command. The substitute pattern needs the literal '#'
  # plus the stem; we wrap it in single quotes so PowerShell does not interpret it.
  $subCmd = "%s/# $stem/# $cleanTitle/"

  nvim $fullFilePath `
  -c 'write' `
  -c 'Obsidian template notes' `
  -c $subCmd `
  -c 'write'
}

# Create a personal note at vault root level (not inbox).
# Usage:
#   onp "My Personal Note"
function onp {
param (
    [Parameter(Position = 0, Mandatory = $true)]
    [string]$FileName
  )

  if ([string]::IsNullOrWhiteSpace($FileName)) {
    Write-Error 'Error: a file name must be provided, e.g. onp "My Personal Note"'
    return
  }

  $vaultPath = Get-ObsidianVaultPath

  if (-not $vaultPath) {
    Write-Error 'Error: OBSIDIAN_VAULT environment variable is not set.'
    return
  }

  # Note structure
  $slug = $FileName -replace ' ', '-'
  $datePrefix = Get-Date -Format 'yyyy-MM-dd'
  $formattedFileName = "${datePrefix}_${slug}.md"
  $stem = [System.IO.Path]::GetFileNameWithoutExtension($formattedFileName)

  # Clean title: "testing-note" -> "Testing Note"
  $textInfo = (Get-Culture).TextInfo
  $cleanTitle = $textInfo.ToTitleCase($FileName)

  # Ensure base vault directory exists
  if (-not (Test-Path $vaultPath)) {
    New-Item -ItemType Directory -Path $vaultPath | Out-Null
  }

  # Switch to Obsidian vault
  Set-Location -Path $vaultPath -ErrorAction Stop

  $personalDir = Join-Path $vaultPath 'personal'
  if (-not (Test-Path $personalDir)) {
    New-Item -ItemType Directory -Path $personalDir | Out-Null
  }

  $filePath = Join-Path $personalDir $formattedFileName

  # Ensure file exists before opening
  if (-not (Test-Path $filePath)) {
    New-Item -ItemType File -Path $filePath | Out-Null
  }

  # Open in Neovim and run commands
  nvim $filePath `
  -c 'write' `
  -c 'Obsidian template personal' `
  -c "%s/# $stem/# $cleanTitle/" `
  -c 'write'
}
