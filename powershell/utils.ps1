# Utility functions
# Requirements: eza, fzf, bat

# eza functions (already there)
function l {
    eza -l --tree --group-directories-first --icons=always --color=always --all --git-ignore --no-permissions --no-time --no-user --no-filesize --git $args
}
function l-all {
    eza -l --tree --group-directories-first --icons=always --color=always --all --git-ignore --git $args
}

# fzf function (already there)
function fz {
    fzf --style full --preview 'bat -n --color=always {}'
}

# Aliases
Set-Alias -Name "vim" -Value "nvim"
Set-Alias -Name "ll" -Value "ls"
Set-Alias -Name "g" -Value "git"
Set-Alias -Name "grep" -Value "findstr"
Set-Alias -Name "tig" -Value "C:\Program Files\Git\usr\bin\tig.exe"
Set-Alias -Name "less" -Value "C:\Program Files\Git\usr\bin\less.exe"

# eza theme configuration
$env:EZA_CONFIG_DIR = "$env:USERPROFILE\.config\.dotfiles\eza"

# Working directory definitions
$ObsidianDir = Join-Path $env:USERPROFILE "obsidian-work"
$ConfigDir = Join-Path $env:USERPROFILE ".config"
$DotfilesDir = Join-Path $env:USERPROFILE ".config\.dotfiles"
$NvimDir = Join-Path $env:USERPROFILE ".config\.dotfiles\nvim"
$PowerShellDir = Join-Path $env:USERPROFILE ".config\.dotfiles\powershell"
$WebsitesDir = Join-Path $env:USERPROFILE "projects\brookfield\websites"
$SitecoreDir = Join-Path $env:USERPROFILE "projects\brookfield\sitecore"

# Custom directory navigation functions
function oo {
    if (Test-Path $ObsidianDir -PathType Container) {
        Set-Location -Path $ObsidianDir
        Write-Host "switched to: $ObsidianDir"
    } else {
        Write-Host "Error: $ObsidianDir not found" -ForegroundColor Red
    }
}

function configdir {
    if (Test-Path $ConfigDir -PathType Container) {
        Set-Location -Path $ConfigDir
        Write-Host "switched to: $ConfigDir"
    } else {
        Write-Host "Error: $ConfigDir not found" -ForegroundColor Red
    }
}

function dotfiles {
    if (Test-Path $DotfilesDir -PathType Container) {
        Set-Location -Path $DotfilesDir
        Write-Host "switched to: $DotfilesDir"
    } else {
        Write-Host "Error: $DotfilesDir not found" -ForegroundColor Red
    }
}

function vimdir {
    if (Test-Path $NvimDir -PathType Container) {
        Set-Location -Path $NvimDir
        Write-Host "switched to: $NvimDir"
    } else {
        Write-Host "Error: $NvimDir not found" -ForegroundColor Red
    }
}

function psdir {
    if (Test-Path $PowerShellDir -PathType Container) {
        Set-Location -Path $PowerShellDir
        Write-Host "switched to: $PowerShellDir"
    } else {
        Write-Host "Error: $PowerShellDir not found" -ForegroundColor Red
    }
}

function webdir {
    if (Test-Path $WebsitesDir -PathType Container) {
        Set-Location -Path $WebsitesDir
        Write-Host "switched to: $WebsitesDir"
    } else {
        Write-Host "Error: $WebsitesDir not found" -ForegroundColor Red
    }
}

function xmdir {
    if (Test-Path $SitecoreDir -PathType Container) {
        Set-Location -Path $SitecoreDir
        Write-Host "switched to: $SitecoreDir"
    } else {
        Write-Host "Error: $SitecoreDir not found" -ForegroundColor Red
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
        @{ Keyword = "xmdir";     Description = "XMCloud project directory"; Path = $SitecoreDir }
    )

    # Iterate through the array and display each function's details.
    foreach ($dir in $customDirs) {
        Write-Host ("{0,-10} : {1,-40} ({2})" -f $dir.Keyword, $dir.Description, $dir.Path)
    }

    Write-Host "----------------------------------"
    Write-Host "To use, simply type the 'Keyword' (e.g., 'oo') and press Enter."
}
