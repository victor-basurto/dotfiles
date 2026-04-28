# ------------------------------------------------------------
# odn — Obsidian Daily Note
# ------------------------------------------------------------
function odn {
    param (
        [string]$TaskContent = ""
    )

    # ── Configuration ───────────────────────────────────────
    $MAIN_NOTE_DIR = "$env:GDRIVE\obsidian-work\daily"
    
    # ── Date Components ─────────────────────────────────────
    $date = Get-Date
    $currentYear      = $date.ToString("yyyy")
    $currentMonthNum  = $date.ToString("MM") # Fixed to MM for Month Number
    $currentMonthAbbr = $date.ToString("MMM").ToLower()
    $currentDay       = $date.ToString("dd")
    $currentWeekday   = $date.ToString("dddd").ToLower()
    $fullDateString   = $date.ToString("yyyy-MM-dd")

    # ── Paths ───────────────────────────────────────────────
    $noteDir = Join-Path $MAIN_NOTE_DIR (Join-Path $currentYear $currentMonthAbbr)
    $noteName = "${fullDateString}_${currentWeekday}.md"
    $fullPath = Join-Path $noteDir $noteName

    # ── Create Directory ────────────────────────────────────
    if (-not (Test-Path $noteDir)) {
        New-Item -ItemType Directory -Path $noteDir -Force | Out-Null
    }

    # ── Write Template (Including hidden summary tags) ──────
    if (-not (Test-Path $fullPath)) {
        $template = @"
---
id: $($fullDateString)_Obsidian-Daily-Notes
aliases:
  - odn
  - daily-logs
tags:
  - daily-notes
date: $fullDateString
hubs:
  - "[[daily-notes]]"
parent:
  - work
urls: []
---
# $fullDateString ($currentWeekday)

## WORK DAILY NOTE

## Incomplete Tasks
- [ ] $currentWeekday initial log

## Completed Tasks

---
📋 Tasks: 0  |  ✅ Done: 0  |  🔲 Undone: 0
"@
        $template | Out-File -FilePath $fullPath -Encoding utf8
        Write-Host "✓ Created: $fullPath" -ForegroundColor Cyan
    } else {
        Write-Host "✓ Note exists: $fullPath" -ForegroundColor Gray
    }

    # ── Append optional task ───────────────────────────────
    if (-not [string]::IsNullOrWhiteSpace($TaskContent)) {
        $fileContent = Get-Content -Path $fullPath -Raw
        $newTask = "- [ ] $TaskContent"
        $fileContent = $fileContent -replace "(## Incomplete Tasks\r?\n)", "`$1$newTask`r`n"
        $fileContent | Set-Content -Path $fullPath -Encoding utf8
        Write-Host "  ↳ Appended task: '$TaskContent'" -ForegroundColor Green
    }

    # ── Update Summary ─────────────────────────────────────
    Update-OdnTaskSummary -FilePath $fullPath

    # ── Open in Neovim ─────────────────────────────────────
    nvim -c "lua require('utilities.odn').setup()" $fullPath
}

# ------------------------------------------------------------
# Internal Helper: Update Task Summary
# ------------------------------------------------------------
function Update-OdnTaskSummary {
    param ([string]$FilePath)

    # Read the entire file as one single string
    $content = Get-Content -Path $FilePath -Raw
    if ([string]::IsNullOrWhiteSpace($content)) { return }

    # Count the tasks using the whole text
    $total   = ([regex]::Matches($content, '(?m)^\- \[.\]')).Count
    $done    = ([regex]::Matches($content, '(?m)^\- \[x\]')).Count
    $undone  = ([regex]::Matches($content, '(?m)^\- \[ \]')).Count

    $summaryLine = "📋 Tasks: $total  |  ✅ Done: $done  |  🔲 Undone: $undone"
    
    # Define the markers (MUST match the template exactly)
    $startTag = ""
    $endTag   = ""

    # Split the file using the markers as anchors
    $parts = $content -split "(?s)$startTag.*?$endTag"

    # If the split worked, we should have two parts
    if ($parts.Count -eq 2) {
        $newContent = $parts[0] + $startTag + "`r`n" + $summaryLine + "`r`n" + $endTag + $parts[1]
        $newContent | Set-Content -Path $FilePath -Encoding utf8 -NoNewline
    }

    # Terminal Output
    Write-Host ""
    Write-Host "  ┌─────────────────────────────┐" -ForegroundColor Yellow
    Write-Host ("  │  📋 Tasks     {0,-3}           │" -f $total) -ForegroundColor Yellow
    Write-Host ("  │  ✅ Done      {0,-3}           │" -f $done) -ForegroundColor Yellow
    Write-Host ("  │  🔲 Undone    {0,-3}           │" -f $undone) -ForegroundColor Yellow
    Write-Host "  └─────────────────────────────┘" -ForegroundColor Yellow
    Write-Host ""
}
