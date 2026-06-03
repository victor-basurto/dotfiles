# eza theme configuration
$env:EZA_CONFIG_DIR = "$env:USERPROFILE\.config\.dotfiles\eza"

# Utility functions
# Requirements: eza
#####################################################
# eza functions
#####################################################
function l {
  eza -l --tree --group-directories-first --icons=always --color=always --all --git-ignore --no-permissions --no-time --no-user --no-filesize --git $args
}
function l-all {
  eza -l --tree --group-directories-first --icons=always --color=always --all --git-ignore --git $args
}

#####################################################
# Print Architectual Tree only
#  folders only
#  recursive tree
#  icons
#  colors
#  hidden dirs
#  git-ignore behavior
#  no metadata
#####################################################
function lt-dirs-only {
  eza --tree --only-dirs --group-directories-first --icons=always --color=always --all --git-ignore $args
}

#####################################################
# Print Architectual Tree only but exclude folder
# This function also allows you to set the deep level
#  One folder to exclude
#  Multiple folders to exclude
#  Error checking for each folder
#  Folders‑only tree
#  Icons + color
#  No eza ignore flags (since eza removed them)
#  No modification to your real directory
# usage:
#   exclude one folder:
#   lt-dirs-exclude serialization
#
#   exclude multiple folders:
#   lt-dirs-exclude serialization
#   
#   exclude folders inside a specific path
#   lt-dirs-exclude node_modules .git build -Path C:\Projects\App
#
#   exclude multiple folder with 2 depth delimiter
#   lt-dirs-exclude serialization platform -Depth 2
#####################################################
function lt-dirs-exclude {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$true, Position=0, ValueFromRemainingArguments=$true)]
    [string[]]$ExcludeFolders,

    [Parameter()]
    [string]$Path = ".",

    [Parameter()]
    [int]$Depth = 0   # 0 = unlimited
  )

  # eza uses globs, so we format each folder name as '*folder_name*' 
  # to ensure it catches them regardless of where they are in the tree.
  $ignorePattern = $ExcludeFolders | ForEach-Object { "*$_*" }

  # build the depth argument
  $depthArg = @()
  if ($Depth -gt 0) {
    $depthArg = @("--level=$Depth")
  }

  # --ignore-glob: Skips the patterns we defined
  # --tree: Shows the hierarchy
  # --only-dirs: Keeps it focused on folders
  eza --tree --only-dirs --icons=always --color=always `
        --ignore-glob="$($ignorePattern -join '|')" `
        @depthArg $Path
}
#####################################################
# Print project tree while excluding folders
#
# Features:
#   • Tree view
#   • Files + folders by default
#   • Optional directories-only mode
#   • Multiple folder exclusions
#   • Respects .gitignore
#   • Icons + colors
#   • Optional depth limit
#   • Group directories first
#   • No file metadata (mode, size, dates, etc.)
#
# Parameters:
#   -ExcludeFolders
#       One or more folder names to exclude.
#
#   -Path
#       Root path to inspect.
#       Default: current directory (.)
#
#   -Depth
#       Maximum tree depth.
#       0 = unlimited depth.
#
#   -DirsOnly
#       Show directories only.
#
# Examples:
#
#   Exclude a single folder:
#   lt-exclude node_modules
#
#   Exclude multiple folders:
#   lt-exclude node_modules .git dist build
#
#   Limit tree depth:
#   lt-exclude node_modules .git -Depth 2
#
#   Show only directories:
#   lt-exclude node_modules .git -DirsOnly
#
#   Show only directories with depth limit:
#   lt-exclude node_modules .git -DirsOnly -Depth 3
#
#   Run against another path:
#   lt-exclude node_modules .git -Path C:\Projects\App
#
# Notes:
#   • Uses eza --tree
#   • Uses eza --git-ignore to respect .gitignore
#   • Exclusions are implemented through --ignore-glob
#   • Excluded folder names are matched recursively
#     throughout the tree
#####################################################
function lt-exclude {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, Position = 0, ValueFromRemainingArguments = $true)]
    [string[]]$ExcludeFolders,

    [Parameter()]
    [string]$Path = ".",

    [Parameter()]
    [int]$Depth = 0,

    [switch]$DirsOnly
  )

  # Build ignore patterns for eza
  $ignorePattern = $ExcludeFolders | ForEach-Object { "*$_*" }

  # Build eza arguments
  $ezaArgs = @(
    "--tree"
    "--group-directories-first"
    "--icons=always"
    "--color=always"
    "--git-ignore"
    "--ignore-glob=$($ignorePattern -join '|')"
  )

  if ($Depth -gt 0) {
    $ezaArgs += "--level=$Depth"
  }

  if ($DirsOnly) {
    $ezaArgs += "--only-dirs"
  }

  $ezaArgs += $Path

  eza @ezaArgs
}
#####################################################
# Quick project tree
#
# Convenience wrapper around lt-exclude that
# automatically excludes common development folders.
#
# Default exclusions:
#   • node_modules
#   • .git
#   • dist
#   • build
#
# Features:
#   • Tree view
#   • Files + folders
#   • Respects .gitignore
#   • Icons + colors
#   • Directories grouped first
#   • No file metadata
#
# Examples:
#
#   Show project tree:
#   lt
#
#   Limit depth:
#   lt -Depth 2
#
#   Directories only:
#   lt -DirsOnly
#
#   Directories only with depth:
#   lt -DirsOnly -Depth 3
#
#   Different root path:
#   lt -Path C:\Projects\App
#
# Equivalent to:
#
#   lt-exclude node_modules .git dist build @args
#
# Notes:
#   • Ideal for JavaScript, TypeScript, React,
#     Next.js, Angular, Vue, .NET, and monorepo
#     projects where generated folders create
#     excessive noise.
#####################################################
function lt {
  lt-exclude node_modules .git dist build @args
}
