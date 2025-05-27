# obsidian vault directory
$vaultPath = Join-Path $env:USERPROFILE "obsidian-work"
$inboxPath = Join-Path $vaultPath "inbox"

function on {
  # take title as argument
  param (
    [Parameter(Mandatory = $true)]
    [string]$Title
  )

  # if title arg is not provided, throw an error with a hint
  if (-not $Title) {
    Write-Error "Error: A file name must be set, e.g. '$ on Newtons Laws of Motion'"
    return
  }

  # format title 'Newtons Laws of Motion' to 'Newtons-Laws-of-Motion'
  $filename = $Title -replace ' ', '-'
  $date = Get-Date -Format "yyyy-MM-dd"
  # example of formatted filename -> 2025-04-19_Newtons-Laws-of-Motion
  $formattedFileName = "${date}_${filename}.md"
  $fullFilePath = Join-Path $inboxPath $formattedFileName

  Set-Location $vaultPath
  if (-not (Test-Path $inboxPath)) {
    New-Item -ItemType Directory -Path $inboxPath | Out-Null
  }

  if (-not(Test-Path $fullFilePath)) {
    New-Item -ItemType File -Path $fullFilePath | Out-Null
  }

  # start neovim
  nvim $fullFilePath
}
