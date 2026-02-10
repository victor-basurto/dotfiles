# Utility functions
# Requirements: eza, fzf, bat

#####################################################
# eza functions (already there)
#####################################################
function l {
  eza -l --tree --group-directories-first --icons=always --color=always --all --git-ignore --no-permissions --no-time --no-user --no-filesize --git $args
}
function l-all {
  eza -l --tree --group-directories-first --icons=always --color=always --all --git-ignore --git $args
}

# eza theme configuration
$env:EZA_CONFIG_DIR = "$env:USERPROFILE\.config\.dotfiles\eza"

#####################################################
# fzf function (already there)
#####################################################
function fz {
  fzf --style full --preview 'bat -n --color=always {}'
}

#####################################################
# Global Aliases
#####################################################
# Aliases
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
$ObsidianDir = "G:\My Drive\obsidian-work"
$ConfigDir = Join-Path $env:USERPROFILE ".config"
$DotfilesDir = Join-Path $env:USERPROFILE ".config\.dotfiles"
$NvimDir = Join-Path $env:USERPROFILE ".config\.dotfiles\nvim"
$PowerShellDir = Join-Path $env:USERPROFILE ".config\.dotfiles\powershell"
$WebsitesDir = Join-Path $env:USERPROFILE "projects\brookfield\websites"
$SitecoreDir = Join-Path $env:USERPROFILE "projects\brookfield\sitecore"
$XMDir = Join-Path $env:USERPROFILE "projects\brookfield\xmcloud\work"
$XMWork = Join-Path $env:USERPROFILE "projects\brookfield\xmcloud\work\brookfield-monorepo"
$NextJSDir = Join-Path $env:USERPROFILE "projects\nextjs-projects"
$ReactDir = Join-Path $env:USERPROFILE "projects\react-projects"
$StrapiDir = Join-Path $env:USERPROFILE "projects\nextjs-projects\strapi-cms"


#####################################################
# Custom directory navigation functions
#####################################################
# obsidian
function oo {
  if (Test-Path $ObsidianDir -PathType Container) {
    Set-Location -Path $ObsidianDir
    Write-Host "switched to: $ObsidianDir"
  } else {
    Write-Host "Error: $ObsidianDir not found" -ForegroundColor Red
  }
}
# .config
function configdir {
  if (Test-Path $ConfigDir -PathType Container) {
    Set-Location -Path $ConfigDir
    Write-Host "switched to: $ConfigDir"
  } else {
    Write-Host "Error: $ConfigDir not found" -ForegroundColor Red
  }
}
# .dotfiles
function dotfiles {
  if (Test-Path $DotfilesDir -PathType Container) {
    Set-Location -Path $DotfilesDir
    Write-Host "switched to: $DotfilesDir"
  } else {
    Write-Host "Error: $DotfilesDir not found" -ForegroundColor Red
  }
}
# nvimdir
function vimdir {
  if (Test-Path $NvimDir -PathType Container) {
    Set-Location -Path $NvimDir
    Write-Host "switched to: $NvimDir"
  } else {
    Write-Host "Error: $NvimDir not found" -ForegroundColor Red
  }
}
# powershell
function psdir {
  if (Test-Path $PowerShellDir -PathType Container) {
    Set-Location -Path $PowerShellDir
    Write-Host "switched to: $PowerShellDir"
  } else {
    Write-Host "Error: $PowerShellDir not found" -ForegroundColor Red
  }
}
# umbraco webdir
function webdir {
  if (Test-Path $WebsitesDir -PathType Container) {
    Set-Location -Path $WebsitesDir
    Write-Host "switched to: $WebsitesDir"
  } else {
    Write-Host "Error: $WebsitesDir not found" -ForegroundColor Red
  }
}
# sitecore
function sitecoredir {
  if (Test-Path $SitecoreDir -PathType Container) {
    Set-Location -Path $SitecoreDir
    Write-Host "switched to: $SitecoreDir"
  } else {
    Write-Host "Error: $SitecoreDir not found" -ForegroundColor Red
  }
}
# xmcloud
function xmdir {
  if (Test-Path $XMDir -PathType Container) {
    Set-Location -Path $XMDir
    Write-Host "switched to: $XMDir"
  } else {
    Write-Host "Error: $XMDir not found" -ForegroundColor Red
  }
}
# xmcloud work
function xmwork {
  if (Test-Path $XMWork -PathType Container) {
    Set-Location -Path $XMWork
    Write-Host "switched to: $XMWork"
  } else {
    Write-Host "Error: $XMWork not found" -ForegroundColor Red
  }
}
# nextjs
function nextdir {
  if (Test-Path $NextJSDir -PathType Container) {
    Set-Location -Path $NextJSDir
    Write-Host "switched to: $NextJSDir"
  } else {
    Write-Host "Error: $NextJSDir not found" -ForegroundColor Red
  }
}
# strapi
function strapidir {
  if (Test-Path $StrapiDir -PathType Container) {
    Set-Location -Path $StrapiDir
    Write-Host "switched to: $StrapiDir"
  } else {
    Write-Host "Error: $StrapiDir not found" -ForegroundColor Red
  }
}
# react
function reactdir {
  if (Test-Path $ReactDir -PathType Container) {
    Set-Location -Path $ReactDir
    Write-Host "switched to: $ReactDir"
  } else {
    Write-Host "Error: $ReactDir not found" -ForegroundColor Red
  }
}
# Custom 'which' command
function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

# Function to list custom directory shortcuts.
function list-dirs {
  Write-Host "--- Custom Directory Shortcuts ---"
  Write-Host "----------------------------------"

  # Define an array of objects for custom directory functions.
  $customDirs = @(
    @{ Keyword = "oo";        Description = "Obsidian-work vault"; Path = $ObsidianDir },
    @{ Keyword = "vimdir";    Description = "nvim configuration directory"; Path = $NvimDir },
    @{ Keyword = "configdir"; Description = "Configuration directory"; Path = $ConfigDir },
    @{ Keyword = "dotfiles";  Description = "Dotfiles directory"; Path = $DotfilesDir },
    @{ Keyword = "psdir";     Description = "PowerShell configuration directory"; Path = $PowerShellDir },
    @{ Keyword = "webdir";    Description = "Brookfield websites project directory"; Path = $WebsitesDir },
    @{ Keyword = "sitecoredir";Description = "Sitecore project directory"; Path = $SitecoreDir },
    @{ Keyword = "xmdir";     Description = "XMCloud project directory"; Path = $XMDir },
    @{ Keyword = "xmwork";    Description = "XMCloud Work project directory"; Path = $XMWork },
    @{ Keyword = "nextdir"; Description = "NextJS project directory"; Path = $NextJSDir },
    @{ Keyword = "strapidir"; Description = "Strapi project directory"; Path = $StrapiDir },
    @{ Keyword = "reactdir"; Description = "React project directory"; Path = $ReactDir }
  )

  # Iterate through the array and display each function's details.
  foreach ($dir in $customDirs) {
    Write-Host ("{0,-10} : {1,-40} ({2})" -f $dir.Keyword, $dir.Description, $dir.Path)
  }

  Write-Host "----------------------------------"
  Write-Host "To use, simply type the 'Keyword' (e.g., 'oo') and press Enter."
}
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
function gst { git status }
function gco { param($b) git switch $b }
function gbr { git branch }
function gnb { param($b) git switch -c $b }
function glast { git log -1 --oneline }

# commit w/message
function gitc {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Message
  )
  git commit -m $Message
}
# usage:
# gitc "feat: message here"

# sync feature branch with main
function gsync {
  git fetch origin
  git rebase origin/main
}
# usage:
# gsync

# safe force push (rebase)
function gpushf {
  git push --force-with-lease
}
# usage:
# gpushf

# start a feature branch from clean main
function gbfrommain {
  param(
    [Parameter(Mandatory = $true)]
    [string]$BranchName
  )

  git switch main
  git pull origin main
  git switch -c $BranchName
}
function gbfromdev {
  param(
    [Parameter(Mandatory = $true)]
    [string]$BranchName
  )

  git switch develop
  git pull origin develop
  git switch -c $BranchName
}
# usage -> create from main:
# go and sync main and create a new branch from main
# gbfrommain feature/heaer-component
#
# usage -> create from develop:
# go and sync develop and create a new branch from develop
# gbfromdev feature/heaer-component

# finish reminder
function gfinish {
  Write-Host "✅ Open a PR. Do NOT merge locally."
}
