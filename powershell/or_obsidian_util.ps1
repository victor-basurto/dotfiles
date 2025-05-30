#
# Function: or
#
# Purpose:
#   Opens all files in your Obsidian vault's "inbox" directory in Neovim.
#
# Usage:
#   Simply type 'or' in your PowerShell terminal and press Enter.
#
# Behavior:
#   1. Changes the current PowerShell directory to $OBSIDIAN_PATH.
#   2. Scans $INBOX_PATH for all files.
#   3. Launches Neovim:
#      - If files are found, opens them as separate buffers.
#      - If no files, opens Neovim in the $OBSIDIAN_PATH directory.
#   4. Displays an error if $INBOX_PATH does not exist.
#
# Configuration:
#   Relies on $OBSIDIAN_PATH and $INBOX_PATH variables defined below.
#
# obsidian vault directory
$OBSIDIAN_PATH = "G:\My Drive\obsidian-work"
$INBOX_PATH = Join-Path $OBSIDIAN_PATH "inbox"

function or {
  # check if the $INBOX_PATH exists
  if (Test-Path $INBOX_PATH -PathType Container) {
    # store the current directory so we can return to it later if desired (optional)
    $originalLocation = Get-Location
    # change to the obsidian vault root
    Set-Location -Path $OBSIDIAN_PATH
    Write-Host "Changed to: $OBSIDIAN_PATH"

    Write-Host "Opening files from: $INBOX_PATH"
    # Get all files (not directories) in the inbox folder
    # -File ensures only files are returned
    $filesToOpen = Get-ChildItem -Path $INBOX_PATH -File | Select-Object -ExpandProperty FullName
    if ($filesToOpen.Count -eq 0) {
      Write-Host "No files found in $INBOX_PATH" -ForegroundColor Yellow
      # if no files found, still open nvim in teh obsidian vault root
      nvim .
    } else {
      Write-Host "Files found in $INBOX_PATH"
      # Start Neovim with all the found files.
      # Since we already CD'd to $OBSIDIAN_PATH, nvim will treat paths relative to it.
      # If you want to open in tabs, use 'nvim -p $filesToOpen'
      nvim $filesToOpen
    }
  } else {
    Write-Host "Error: $INBOX_PATH not found" -ForegroundColor Red
  }
}
