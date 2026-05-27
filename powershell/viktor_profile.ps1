# ==========================================
# THEME TOGGLE CONFIGURATION
# ==========================================
# Set to $true for your custom 'zeus' theme, or $false to use the built-in default theme
$UseCustomTheme = $false

# ==========================================
# UTILITY DOT-SCRIPTS (Your Rock-Solid Config)
# ==========================================
. (Join-Path (Split-Path $MyInvocation.MyCommand.Path) "odn_obsidian_util.ps1")
. (Join-Path (Split-Path $MyInvocation.MyCommand.Path) "og_obsidian_util.ps1")
. (Join-Path (Split-Path $MyInvocation.MyCommand.Path) "on_obsidian_util.ps1")
. (Join-Path (Split-Path $MyInvocation.MyCommand.Path) "or_obsidian_util.ps1")
. (Join-Path (Split-Path $MyInvocation.MyCommand.Path) "utils.ps1")
. (Join-Path (Split-Path $MyInvocation.MyCommand.Path) "eza-utils.ps1")

# Prompt Requirements
Import-Module posh-git

# ==========================================
# LOAD PROMPT (DYNAMIC SWITCH)
# ==========================================
if ($UseCustomTheme) {
    # Load your custom theme folder layout
    function Get-ScriptDirectory { Split-Path $MyInvocation.ScriptName }
    $PROMPT_CONFIG = Join-Path (Get-ScriptDirectory) 'zeus.omp.json'
    oh-my-posh --init --shell pwsh --config $PROMPT_CONFIG | Invoke-Expression
} else {
    # Load a clean, built-in Oh-My-Posh default theme (no local json file needed)
    oh-my-posh init pwsh --config ~/jandedobbeleer.omp.json | Invoke-Expression
}

# ==========================================
# ICONS & TERMINAL PLUGINS
# ==========================================
Import-Module -Name Terminal-Icons
Import-Module PSReadLine

# PSReadLine Configurations
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView

# FZF Setup
Import-Module PSFzf
Set-PSFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

# Prompt Generator Alias
Set-Alias gprompt New-WorkPrompt
