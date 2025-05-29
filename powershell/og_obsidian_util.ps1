<#
This script automates the organization of Obsidian Zettelkasten notes based on their tags.
It reads markdown files from a designated 'zettelkasten' directory, extracts the first tag
found in the YAML fronmmatter, and moves the note to a corresponding subdirectory
within the 'notes' directory. If the tag's subdirectory does not exist, it will be created.
#>
# obsidian vault directory
$VAULT_PATH = Join-Path $env:USERPROFILE "obsidian-work"
$ZETTELKASTEN_DIR = Join-Path $VAULT_PATH "zettelkasten"
$NOTES_DIR = Join-Path $vaultPath "notes"

function og {
  # check if zettelkasten directory exists
  if (-not (Test-Path $ZETTELKASTEN_DIR)) {
    Write-Host "Error: Zettelkasten directory not found at $ZETTELKASTEN_DIR" -ForegroundColor Red
    exit
  }
  # ensure the notes directory exists
  if (-not (Test-Path $NOTES_DIR)) {
    New-Item -ItemType Directory -Path $NOTES_DIR | Out-Null
    Write-Host "Created Notes directory at $NOTES_DIR"
  }
  Write-Host "Organizing Zettelkasten notes in: $ZETTELKASTEN_DIR"

  # Iterate through all markdown files in the zettelkasten directory
  Get-ChildItem -Path $ZETTELKASTEN_DIR -Filter "*.md" | ForEach-Object {
    $filePath = $_.FullName
    $fileName = $_.Name
    Write-Host "Processing file: $fileName"
    # Read the file content
    $content = Get-Content -Path $filePath -Raw
    # Regular expression to extract parent tags from the 'parent: []' frontmatter
    # It looks for 'parent: [' followed by anything not ']' (non-greedy), them ']'
    $parentMatch = [regex]::Match($content, 'parent:\s*\[([^\]]*)\]')

    $firstTag = $null
    $parentTag = $null

    # extract primary tag
    if ($tagMatch.Succes) {
      $tagsString = $tagMatch.Groups[1].Value.Trim()
      if (-not [string]::IsNullOrEmpty($tagsString)) {
        # ensure the result is always an array of string, even for a single tag
        $tempTags = @($tagsString.Split(',') | ForEach-Object { $_.Trim() | Where-Object { -not [string]::IsNullOrEmpty($_)})
        if ($tempTags.Count -gt 0) {
          $firstTag = $tempTags[0]  # Get the first tag
        }
      }
    }

    # extract parent tag
    if ($parentMatch.Succes) {
      $parentString = $parentMatch.Groups[1].Value.Trim()
      if (-not [string]::IsNullOrEmpty($parentString)) {
        # ensure the result is always an array of string, even for a single tag
        $tempParentTags = @($parentString.Split(',') | ForEach-Object { $_.Trim() | Where-Object { -not [string]::IsNullOrEmpty($_)})
        if ($tempParentTags.Count -gt 0) {
          $parentTag = $tempParentTags[0]  # Get the first tag
        }
      }
    }

    Write-Host "First Tag: $firstTag"
    Write-Host "Parent Tag: $parentTag"

    if (-not [string]::IsNullOrEmpty($firstTag)) {
      $targetBaseDir = $NOTES_DIR
      
      # construct the target directory path based on parent tag
      if (-not [string]::IsNullOrEmpty($parentTag)) {
        $targetTagDir = Join-Path (Join-Path $targetBaseDir $parentTag) $firstTag
        Write-Host " Destination path with parent: '$targetTagDir'"
      } else {
        $targetTagDir = Join-Path $targetBaseDir $firstTag
        Write-Host " Destination path without parent: '$targetTagDir'"
      }

      # check if the target directory exists, if not, create it
      # -Force parameter ensures parent directories are created if they don't exist
      if (-not (Test-Path $targetTagDir)) {
        New-Item -ItemType Directory -Path $targetTagDir -Force | Out-Null
        Write-Host "Created new directory: $targetTagDir"
      }

      # Move the file to the target directory
      try {
        Move-Item -Path $filePath -Destination $targetTagDir -Force
        Write-Host "Successfully moved '$fileName' to '$targetTagDir'"
      } catch {
        Write-Error "Failed to move '$fileName' to '$targetTagDir'. Error: $($_.Exception.Message)"
      }
    } else {
      Write-Host "No valid primary tag found for file: $fileName. Ignoring."
    }
    Write-Host "---"
    Write-Host "Zettelkasten processing complete."
  }
}
