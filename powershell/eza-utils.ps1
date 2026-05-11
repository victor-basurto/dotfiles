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
