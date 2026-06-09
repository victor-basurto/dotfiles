<#
This script automates the organization of Obsidian Zettelkasten notes based on their tags.
It reads markdown files from a designated 'zettelkasten' directory, extracts the target_folder value
found in the YAML fronmmatter, and moves the note to a corresponding subdirectory
within the 'notes' directory. If the target_folder or target_folder does not exist, it will be created.
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
    function Get-ObsidianValue($key, $text) {
      # Matches the key at the start of a line and captures everything after the colon
      $pattern = "(?m)^${key}:\s*(.*)"

      if ($text -match $pattern) {
        # Clean out any accidental quotes or bracket remnants and trim whitespace
        return $Matches[1].Trim(" `"'[]`r`n")
      }
      return $null
    }
    $folder = Get-ObsidianValue "target_folder" $content
    $subFolder = Get-ObsidianValue "target_subfolder" $content

    Write-Host "Target Folder: '$folder'"
    Write-Host "Target Subfolder: '$subFolder'"

    if (-not [string]::IsNullOrEmpty($folder)) {
      # build the path structure properly
      $targetDir = if (-not [string]::IsNullOrEmpty($subFolder)) {
        # strutures: notes/bash/snippets/
        Join-Path (Join-Path $NOTES_DIR $folder) $subFolder
      } else {
        # strucures: notes/bash/
        Join-Path $NOTES_DIR $folder
      }

      # create directory path if missing
      if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        Write-Host "Created directory: $targetDir"
      }

      try {
        Move-Item -Path $filePath -Destination $targetDir -Force
        Write-Host "Successfully moved '$fileName'"
      } catch {
        Write-Host "Failed to move '$fileName'. Error: $($_.Exception.Message)" -ForegroundColor Red
      }
    } else {
      Write-Host "No valid target_folder defined. Skipping." -ForegroundColor Yellow
    }
  }
  Write-Host "---"
  Write-Host "Zettelkasten processing complete."
}
