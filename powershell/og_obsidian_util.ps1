<#
This script automates the organization of Obsidian Zettelkasten notes based on their tags.
It reads markdown files from a designated 'zettelkasten' directory, extracts the first tag
found in the YAML fronmmatter, and moves the note to a corresponding subdirectory
within the 'notes' directory. If the tag's subdirectory does not exist, it will be created.
#>
# obsidian vault directory
$VAULT_PATH = "$env:GDRIVE\obsidian-work"
$ZETTELKASTEN_DIR = Join-Path $VAULT_PATH "zettelkasten"
$NOTES_DIR = Join-Path $VAULT_PATH "notes"

function og {
  # check if zettelkasten directory exists
  if (-not (Test-Path $ZETTELKASTEN_DIR)) {
    Write-Host "Error: Zettelkasten directory not found at $ZETTELKASTEN_DIR" -ForegroundColor Red
    return
  }

  if (-not (Test-Path $NOTES_DIR)) {
    New-Item -ItemType Directory -Path $NOTES_DIR | Out-Null
    Write-Host "Created Notes directory at $NOTES_DIR"
  }

  Write-Host "Organizing Zettelkasten notes in: $ZETTELKASTEN_DIR"

  # Iterate through all markdown files in the zettelkasten directory
  Get-ChildItem -Path $ZETTELKASTEN_DIR -Filter "*.md" | ForEach-Object {
    $filePath = $_.FullName
    $fileName = $_.Name
    Write-Host "---"
    Write-Host "Processing file: $fileName"
    # Read the file content
    $content = Get-Content -Path $filePath -Raw
    # Helper function to extract tags from both formats
    # Helper function to extract tags from both formats
    function Get-ObsidianTag($key, $text) {
      # Using ${key} to prevent PowerShell from misinterpreting the colon as a scope modifier
      $pattern = "(?m)^${key}:\s*(?:\[([^\]]*)\]|(?:\r?\n)\s*-\s*([^\s\r\n]+))"
      $match = [regex]::Match($text, $pattern)

      if ($match.Success) {
        # Group 1 is the inline [value], Group 2 is the list - value
        $val = if ($match.Groups[1].Success) { $match.Groups[1].Value } else { $match.Groups[2].Value }

        if ($val) {
          # Trim leading/trailing spaces, brackets, and the YAML dash
          return $val.Split(',')[0].Trim(" []-")
        }
      }
      return $null
    }
    $firstTag = Get-ObsidianTag "tags" $content
    $parentTag = Get-ObsidianTag "parent" $content

    # Final sanitization: ensure we don't have empty strings or just brackets
    if ($firstTag -eq "[" -or $firstTag -eq "]") { $firstTag = $null }
    if ($parentTag -eq "[" -or $parentTag -eq "]") { $parentTag = $null }

    Write-Host "First Tag: '$firstTag'"
    Write-Host "Parent Tag: '$parentTag'"

    if (-not [string]::IsNullOrEmpty($firstTag)) {
      $targetTagDir = if (-not [string]::IsNullOrEmpty($parentTag)) {
        Join-Path (Join-Path $NOTES_DIR $parentTag) $firstTag
      } else {
        Join-Path $NOTES_DIR $firstTag
      }

      if (-not (Test-Path $targetTagDir)) {
        New-Item -ItemType Directory -Path $targetTagDir -Force | Out-Null
        Write-Host "Created directory: $targetTagDir"
      }

      try {
        Move-Item -Path $filePath -Destination $targetTagDir -Force
        Write-Host "Successfully moved '$fileName'"
      } catch {
        Write-Host "Failed to move '$fileName'. Error: $($_.Exception.Message)" -ForegroundColor Red
      }
    } else {
      Write-Host "No valid tag found. Skipping." -ForegroundColor Yellow
    }
  }
  Write-Host "---"
  Write-Host "Zettelkasten processing complete."
}
