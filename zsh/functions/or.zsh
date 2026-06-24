# $HOME/.config/.dotfiles/zsh/functions/or.zsh

# Documentation for `og.zsh`
#
# Purpose:
#   Opens all files in your Obsidian vault's "inbox" directory in Neovim as buffers.
#
# Usage:
#   Simply type 'or' from your terminal and press Enter.
#
# Behavior:
#   1. Changes the current terminal directory to $VAULT_DIR
#   2. Scans all files in $INBOX_PATH
#   3. Launches Neovim:
#     - if files ar found, opens them as separate buffers.
#     - if no files, opens Neovim in the $VAULT_DIR.
#   4. Displays an error if $INBOX_PATH does not exist.
#
# Configuration:
#   Relies on $VAULT_DIR and $INBOX_PATH variables defined below

VAULT_DIR="${OBSIDIAN_VAULT:-$HOME/Google Drive/My Drive/obsidian-work}"
INBOX_PATH="$VAULT_DIR/inbox"

or() {
  # check if the $INBOX_PATH exists
  if [[ ! -d $VAULT_DIR ]]; then
    # print error in bold red (%F{red}...%f)
    print -P "%F{red}Error: $INBOX_PATH not found%f"
    return 1   
  fi

  # change to the obsidian vault root
  cd "$VAULT_DIR" || return 1
  print "Changed to: $PWD"
  print "Opening files from: $INBOX_PATH"

  # scan for files inside the inbox directory
  # (.-N) is a Zsh glob qualifier:
  #   . = regular files only (no directories)
  #   - = follow symbolic links
  #   N = Sets NULL_GLOB, so it returns empty instead of throwing an error if no files match
  local files_to_open=("$INBOX_PATH"/*(.-N))

  # launch Neovim based on file counts
  if (( ${#files_to_open} == 0 )); then
    # print warning in yellow
    print -P "%F{yellow}No files found in $INBOX_PATH%f"
    nvim .
  else
    print "Files found in $INBOX_PATH. Opening in Neovim..."
    # expands the array properly into separate arguments for nvim
    nvim "${files_to_open[@]}"
  fi
}

# legacy command/alias
# 
# Obsidian review alias
# alias or='cd ${OBSIDIAN_VAULT:-$HOME/Google Drive/My Drive/obsidian-work} && nvim ./inbox/*.md'
