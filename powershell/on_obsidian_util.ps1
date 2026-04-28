# obsidian vault directory
$vaultPath = "$env:GDRIVE\obsidian-work"
$inboxPath = Join-Path $vaultPath "inbox"

function on {
param (
    [Parameter(Mandatory = $true)]
    [string]$Title
  )

  if (-not $Title) {
    Write-Error "Error: A file name must be set, e.g. '$ on Newtons Laws of Motion'"
    return
  }

  # 'Newtons Laws of Motion' -> 'Newtons-Laws-of-Motion'
  $filename = $Title -replace ' ', '-'
  $date = Get-Date -Format "yyyy-MM-dd"

  # e.g. 2026-04-27_Newtons-Laws-of-Motion.md
  $formattedFileName = "${date}_${filename}.md"
  $stem = [System.IO.Path]::GetFileNameWithoutExtension($formattedFileName)
  $fullFilePath = Join-Path $inboxPath $formattedFileName

  # Clean title: "newtons-laws-of-motion" -> "Newtons Laws Of Motion"
  $textInfo = (Get-Culture).TextInfo
  $cleanTitle = ($filename -replace '-', ' ') -replace '\b(\w)', { $_.Value.ToUpper() }

  Set-Location $vaultPath

  if (-not (Test-Path $inboxPath)) {
    New-Item -ItemType Directory -Path $inboxPath | Out-Null
  }

  if (-not (Test-Path $fullFilePath)) {
    New-Item -ItemType File -Path $fullFilePath | Out-Null
  }

  # Build the nvim ex-commands. The substitute pattern needs the literal '#'
  # plus the stem; we wrap it in single quotes so PowerShell doesn't interpret
  # anything, then pass it through to nvim.
  $subCmd = "%s/# $stem/# $cleanTitle/"

  nvim $fullFilePath `
  -c "write" `
  -c "Obsidian template notes" `
  -c $subCmd `
  -c "write"
}
