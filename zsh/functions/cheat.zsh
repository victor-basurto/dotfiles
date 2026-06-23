#! /.config/.dotfiles/zsh/functions/cheat.zsh
# Public Dotfiles Cheatsheet Viewer
# Usage:
#   cheat          -> Open interactive fuzzy finder for all sheets
#   cheat git      -> Directly open the git cheatsheet if found
#   cheat nvim     -> Directly open the nvim cheatsheet if found
function cheat() {
  local cheat_dir="$HOME/.config/.dotfiles/cheatsheets"

  # ensure directory exists
  if [[ ! -d "$cheat_dir" ]]; then
    echo "❌ Error: Cheatsheet directory not found at ${cheat_dir/#$HOME/~}"
    return 1
  fi

  local file
  if [[ -n "$1" ]]; then
    # direct matching logic (e.g., 'cheat zsh' matches 'zsh.md')
    file=$(fd -t f -e md . "$cheat_dir" | grep -i "$1" | head -n 1)

    # fallback to `fzf` with pre-filled query if exact match isn't immediate
    if [[ -z "$file" ]]; then
      file=$(fd -t f -e md . "$cheat_dir" | fzf --query="$1" \
        --preview "bat --color=always --style=numbers {}")
    fi
  else
    # no arguments passed: open full interactive list
    file=$(fd -t f -e md . "$cheat_dir" | fzf \
      --preview "bat --color=always --style=numbers {}")
  fi

  # action execution
  if [[ -n "$file" ]]; then
    # opens in read-only mode to prevent accidental typos in your current repo
    # hit :q to exit instantly back to your terminal prompt
    nvim -R "$file"
  fi
}

# enable tab-completion for custom cheatsheet files
local _cheat_completion_path="$HOME/.config/.dotfiles/cheatsheets/"
compdef "_path_files -W _cheat_completion_path -g '*.md'" cheat
