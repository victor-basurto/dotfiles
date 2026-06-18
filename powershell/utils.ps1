#####################################################
# fzf function (already there)
#####################################################
function fz {
  nvim (fzf --style full --preview 'bat -n --color=always {}')
}

function fzg {
<#
.SYNOPSIS
Static, codebase-wide fuzzy text search utilizing Ripgrep and FZF.
.DESCRIPTION
Scans all files in the current directory tree for text contents using Ripgrep,
pipes the consolidated list into FZF for fuzzy filtering, and previews the file
using Bat. Selecting a line automatically opens Neovim directly at that line number.
.INPUTS
None.
.OUTPUTS
None.
.EXAMPLE
fzg
Launches the interface. Type your search string (e.g., "function fz") to filter.
#>
  $selection = rg --line-number --no-heading --color=always --smart-case "" | 
  fzf --ansi `
  --style full `
  --delimiter ':' `
  --bind 'ctrl-j:down,ctrl-k:up' `
  --preview 'bat --color=always --highlight-line {2} {1}' `
  --preview-window 'right,60%'

  if ($selection) {
    # Split cleanly by the first colons to separate file, line, and content
    $parts = $selection -split ':'

    $file = $parts[0].Trim()
    $line = $parts[1].Trim()

    # Absolute path fallback check (e.g., C:\path\file.ps1)
    if ($parts[0].Length -eq 1) {
      $file = "$($parts[0]):$($parts[1])".Trim()
      $line = $parts[2].Trim()
    }

    nvim "+$line" $file
  }
}
function fzlive {
<#
.SYNOPSIS
Dynamic Live Grep matching text interactively as you type.
.DESCRIPTION
Instead of searching everything at startup, this maps your active keystrokes
directly to a live background Ripgrep query. Ideal for large codebases or monorepos
where a blank startup search is resource-heavy. Previews with syntax highlighting.
.INPUTS
None.
.OUTPUTS
None.
.EXAMPLE
fzlive
Launches a blank prompt. Type any phrase (e.g., "Set-Alias") to query files on the fly.
#>
  $selection = fzf --ansi --disabled --style full `
  --bind "start:reload(rg --column --line-number --no-heading --color=always --smart-case '')" `
  --bind "change:reload(rg --column --line-number --no-heading --color=always --smart-case {q} || true)" `
  --bind 'ctrl-j:down,ctrl-k:up' `
  --delimiter ':' `
  --preview 'bat --color=always --highlight-line {2} {1}' `
  --preview-window 'right,60%'

  if ($selection) {
    $parts = $selection -split ':'
    $file = $parts[0].Trim()
    $line = $parts[1].Trim()

    if ($parts[0].Length -eq 1) {
      $file = "$($parts[0]):$($parts[1])".Trim()
      $line = $parts[2].Trim()
    }

    nvim "+$line" $file
  }
}
#####################################################
# Global Aliases
#####################################################
# Aliases
Set-Alias -Name "v" -Value "nvim"
Set-Alias -Name "vim" -Value "nvim"
Set-Alias -Name "ll" -Value "ls"
Set-Alias -Name "g" -Value "git"
Set-Alias -Name "grep" -Value "findstr"
Set-Alias -Name "tig" -Value "C:\Program Files\Git\usr\bin\tig.exe"
Set-Alias -Name "less" -Value "C:\Program Files\Git\usr\bin\less.exe"

#####################################################
# Definitions
#####################################################
# Working directory definitions
$ObsidianDir    = "$env:GDRIVE\obsidian-work"
$ConfigDir      = Join-Path $env:USERPROFILE ".config"
$DotfilesDir    = Join-Path $env:USERPROFILE ".config\.dotfiles"
$NvimDir        = Join-Path $env:USERPROFILE ".config\.dotfiles\nvim"
$PowerShellDir  = Join-Path $env:USERPROFILE ".config\.dotfiles\powershell"
$WebsitesDir    = Join-Path $env:USERPROFILE "projects\brookfield\websites"
$SitecoreDir    = Join-Path $env:USERPROFILE "projects\brookfield\sitecore"
$XMDir          = Join-Path $env:USERPROFILE "projects\brookfield\xmcloud\work"
$MonoDir        = Join-Path $env:USERPROFILE "projects\brookfield\xmcloud\work\brookfield-monorepo"
$BrookDir       = Join-Path $env:USERPROFILE "projects\brookfield"
$NextJSDir      = Join-Path $env:USERPROFILE "projects\nextjs-projects"
$ReactDir       = Join-Path $env:USERPROFILE "projects\react-projects"
$StrapiDir      = Join-Path $env:USERPROFILE "projects\nextjs-projects\strapi-cms"
$PersonalDir    = Join-Path $env:USERPROFILE "projects\personal-projects"
$JSDir          = Join-Path $env:USERPROFILE "projects\js-projects"
$SaferDir       = Join-Path $env:USERPROFILE "projects\safer-projects"
$UmbracoDir     = Join-Path $env:USERPROFILE "projects\umbraco"
$ZshFuncDir     = Join-Path $env:USERPROFILE ".config\.dotfiles\zsh\functions"

#####################################################
# Helper: navigate to a directory
#####################################################
function _GoTo {
  param(
    [string]$Path,
    [string]$Label
  )
  if (Test-Path $Path -PathType Container) {
    Set-Location -Path $Path
    Write-Host "switched to: $Path"
  } else {
    Write-Host "Error: $Label not found at '$Path'" -ForegroundColor Red
  }
}

#####################################################
# Custom directory navigation functions
#####################################################
function oo        { _GoTo $ObsidianDir   "Obsidian Work Directory" }
function conf      { _GoTo $ConfigDir     "Configuration Files Directory" }
function dot       { _GoTo $DotfilesDir   "Dotfiles Directory" }
function vimd      { _GoTo $NvimDir       "Neovim Configuration Directory" }
function ps1       { _GoTo $PowerShellDir "PowerShell Configuration Directory" }
function webd      { _GoTo $WebsitesDir   "Websites Directory" }
function sitecore  { _GoTo $SitecoreDir "Sitecore Project Directory" }
function xmd       { _GoTo $XMDir        "XM Cloud Projects Directory" }
function brook     { _GoTo $BrookDir     "Brookfield Projects Directory" }
function nex       { _GoTo $NextJSDir    "Next.js Projects Directory" }
function reactd    { _GoTo $ReactDir     "React Projects Directory" }
function strap     { _GoTo $StrapiDir    "Strapi Projects Directory" }
function pers      { _GoTo $PersonalDir  "Personal Projects Directory" }
function jsd       { _GoTo $JSDir        "JavaScript Projects Directory" }
function safer     { _GoTo $SaferDir     "Safer Projects Directory" }
function umbd      { _GoTo $UmbracoDir   "Umbraco Projects Directory" }
function zshd      { _GoTo $ZshFuncDir   "ZSH Custom Functions Directory" }

#####################################################
# mono — navigate to monorepo root or a specific site
#####################################################
function mono {
  param(
    [string]$Site = ""
  )

  # Strip any trailing backslash from the base path
  $BasePath = $MonoDir.TrimEnd('\')

  if ([string]::IsNullOrEmpty($Site)) {
    _GoTo $BasePath "Monorepo Root"
    return
  }

  $SitePath = Join-Path $BasePath "src\rendering\sites\$Site"

  if (Test-Path $SitePath -PathType Container) {
    Set-Location -Path $SitePath
    Write-Host "switched to: $SitePath"
  } else {
    # Fallback to monorepo root
    if (Test-Path $BasePath -PathType Container) {
      Set-Location -Path $BasePath
      Write-Host "switched to: $BasePath"
    } else {
      Write-Host "Error: Monorepo root not found at '$BasePath'" -ForegroundColor Red
      return
    }
    Write-Host "Warning: Site '$Site' not found. Moved to monorepo root." -ForegroundColor Yellow
    Write-Host "Checked path: $SitePath"
  }
}
# Enable Tab-Completion for mono sites
Register-ArgumentCompleter -CommandName mono -ParameterName Site -ScriptBlock {
  param($commandName, $parameterName, $wordToComplete)
  
  $SitesPath = Join-Path $MonoDir "src\rendering\sites"
  
  if (Test-Path $SitesPath -PathType Container) {
    Get-ChildItem -Path $SitesPath -Directory |
      Where-Object { $_.Name -like "$wordToComplete*" } |
      ForEach-Object { $_.Name }
  }
}
#####################################################
# list-dirs — display all shortcuts
#####################################################
function list-dirs {
  Write-Host "--- Custom Directory Shortcuts ---"
  Write-Host "----------------------------------"

  $customDirs = @(
    @{ Keyword = "oo";          Description = "Obsidian Work Directory";              Path = $ObsidianDir },
    @{ Keyword = "conf";        Description = "Configuration Files Directory";        Path = $ConfigDir },
    @{ Keyword = "dot";         Description = "Dotfiles Directory";                   Path = $DotfilesDir },
    @{ Keyword = "vimd";        Description = "Neovim Configuration Directory";       Path = $NvimDir },
    @{ Keyword = "ps1";         Description = "PowerShell Configuration Directory";   Path = $PowerShellDir },
    @{ Keyword = "webd";        Description = "Websites Directory";                   Path = $WebsitesDir },
    @{ Keyword = "sitecore";    Description = "Sitecore Project Directory";           Path = $SitecoreDir },
    @{ Keyword = "xmd";         Description = "XM Cloud Projects Directory";          Path = $XMDir },
    @{ Keyword = "brook";       Description = "Brookfield Projects Directory";        Path = $BrookDir },
    @{ Keyword = "nex";         Description = "Next.js Projects Directory";           Path = $NextJSDir },
    @{ Keyword = "reactd";      Description = "React Projects Directory";             Path = $ReactDir },
    @{ Keyword = "strap";       Description = "Strapi Projects Directory";            Path = $StrapiDir },
    @{ Keyword = "pers";        Description = "Personal Projects Directory";          Path = $PersonalDir },
    @{ Keyword = "jsd";         Description = "JavaScript Projects Directory";        Path = $JSDir },
    @{ Keyword = "safer";       Description = "Safer Projects Directory";             Path = $SaferDir },
    @{ Keyword = "umbd";        Description = "Umbraco Projects Directory";           Path = $UmbracoDir },
    @{ Keyword = "zshd";        Description = "ZSH Custom Functions Directory";       Path = $ZshFuncDir },
    @{ Keyword = "mono [site]"; Description = "XM Cloud Monorepo (Supports site args)"; Path = $MonoDir }
  )

  foreach ($dir in $customDirs) {
    Write-Host ("{0,-14} : {1,-45} ({2})" -f $dir.Keyword, $dir.Description, $dir.Path)
  }

  Write-Host "----------------------------------"
  Write-Host "Usage:"
  Write-Host "  - Type the Keyword (e.g., 'xmd') to jump to a directory."
  Write-Host "  - For 'mono', you can add a site name: 'mono sitea'"
}
#####################################################
# Other:
# Custom 'which' command
#####################################################
function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}
#####################################################
# Serialization
#####################################################
function serlogin { dotnet sitecore cloud login }
function serdev { dotnet sitecore ser pull -n dev }
#####################################################
# Prompt Generator Template
#####################################################
function New-WorkPrompt {
  param(
    [string]$FileName = "task.md"
  )
  $TemplatePath = "$HOME\.config\.dotfiles\prompt-generator\templates\work-prompt.md"

  if (Test-Path $TemplatePath) {
    # Construct content: Date + Newline + Template Content
    $DateHeader = "# Date: $(Get-Date -Format 'yyyy-MM-dd')`n" 
    $TemplateContent = Get-Content $TemplatePath -Raw

    # Write to file (UTF8 ensures characters like ✅ render correctly)
    Set-Content -Path $FileName -Value ($DateHeader + $TemplateContent) -Encoding UTF8

    Write-Host "✅ Created $FileName from template." -ForegroundColor Green
    nvim $FileName 
  } else {
    Write-Host "❌ Error: Template not found at $TemplatePath" -ForegroundColor Red
  }
}
#####################################################
# Git Alias
#####################################################
function g { & git $args }
function gst { git status }
function gco { param($b) git switch $b }
function gbr { git branch }
function gnb { param($b) git switch -c $b }
function glast { git log -1 --oneline }

# commit w/message
# usage: gitc "feat: message here"
function gitc {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Message
  )
  git commit -m $Message
}

# sync feature branch with main
# usage: gsync
function gsync {
  git fetch origin
  git rebase origin/main
}

# first push
# usage: gpushu feature/new-working-branch
function gpushu {
  param(
    [Parameter(Mandatory = $true)]
    [string]$BranchName
  )

  git push -u origin $BranchName
}

# safe force push (rebase)
# usage: gpushf
function gpushf {
  git push --force-with-lease
}

# start a feature branch from clean main
# usage: gbfrommain feature/heaer-component
function gbfrommain {
  param(
    [Parameter(Mandatory = $true)]
    [string]$BranchName
  )

  git switch main
  git pull origin main
  git switch -c $BranchName
}

# start a feature branch from clean develop
# usage: gbfromdev feature/heaer-component
function gbfromdev {
  param(
    [Parameter(Mandatory = $true)]
    [string]$BranchName
  )

  git switch develop
  git pull origin develop
  git switch -c $BranchName
}

# finish reminder
function gfinish {
  Write-Host "✅ Open a PR. Do NOT merge locally."
}

#####################################################
# tuxedo todo app aliases
#####################################################
<#
.SYNOPSIS
Runs Tuxedo from the directory defined by TODO_DIR while protecting the existing todo file.

.DESCRIPTION
Invoke-Tuxedo is a wrapper around tuxedo.exe that:

- Verifies TODO_DIR is set.
- Verifies TODO_DIR points to a valid directory.
- Ensures todo.txt exists in TODO_DIR without overwriting an existing file.
- Temporarily changes to TODO_DIR before launching tuxedo.exe.
- Restores the original working directory afterward.

This is useful when you want Tuxedo to always operate on the same todo.txt file,
especially when working across multiple machines or shells.

.PARAMETER Args
Arguments passed directly through to tuxedo.exe.

.EXAMPLE
tux
Runs Tuxedo using the configured TODO_DIR.

.EXAMPLE
todo add "buy milk"
Passes the add command to tuxedo.exe while keeping file operations in TODO_DIR.

.NOTES
Place this function in your PowerShell profile or dot-source it from a separate script file.
The function is designed to avoid accidental overwrites of the todo.txt file.
#>
function Invoke-Tuxedo {
  param (
    [Parameter(ValueFromRemainingArguments = $true)]
    $Args
  )

  if (-not $env:TODO_DIR) {
    throw "TODO_DIR is not set."
  }

  if (-not (Test-Path -LiteralPath $env:TODO_DIR -PathType Container)) {
    throw "TODO_DIR is not a valid directory: $env:TODO_DIR"
  }

  $old = Get-Location
  try {
    Set-Location -LiteralPath $env:TODO_DIR -ErrorAction Stop

    $todoFile = Join-Path -Path $env:TODO_DIR -ChildPath 'todo.txt'
    if (-not (Test-Path -LiteralPath $todoFile -PathType Leaf)) {
      New-Item -ItemType File -Path $todoFile -Force | Out-Null
    }

    tuxedo.exe @Args
  }
  finally {
    Set-Location -LiteralPath $old -ErrorAction SilentlyContinue
  }
}
Set-Alias tux Invoke-Tuxedo
Set-Alias todo Invoke-Tuxedo

# autocompletion for tuxedo and aliases
Register-ArgumentCompleter -Native -CommandName todo -ScriptBlock {
  param($wordToComplete, $commandAst, $cursorPosition)
  tuxedo.exe completions powershell | Invoke-Expression
}
Register-ArgumentCompleter -Native -CommandName tux -ScriptBlock {
  param($wordToComplete, $commandAst, $cursorPosition)
  tuxedo.exe completions powershell | Invoke-Expression
}
