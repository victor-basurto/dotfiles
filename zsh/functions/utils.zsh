# $HOME/.config/.dotfiles/zsh/functions/utils.zsh

# Function to display a directory tree using 'eza' with a customizable depth.
#
# Usage:
#   ltree           # Displays tree with default level 3
#   ltree <level>   # Displays tree up to <level> depth
#   ltree <level> <path> # Displays tree of <path> up to <level> depth
#   ltree <level> -L # Displays tree at <level> and passes -L to eza
#
# Arguments:
#   $1: Optional. The desired tree level (a positive integer). Defaults to 3.
#   $@: Any additional arguments are passed directly to 'eza'.
#
# Requires 'eza' to be installed.
ltree() {
  local level_arg=3 # Default level if no argument is provided
  local path_arg="" # Initialize path argument

  # Check if the first argument is a number (for the level)
  if [[ -n "$1" && "$1" =~ ^[0-9]+$ ]]; then
    level_arg="$1"
    shift # Remove the level argument from the list of arguments
  fi

  # All remaining arguments are passed to eza.
  # This allows for additional eza flags or a specific path.
  eza --tree --level="$level_arg" --icons --color --git --git-ignore --group-directories-first "$@"
  # eza -l --tree --level="$level_arg" --group-directories-first --icons=always --color=always --all --git-ignore --no-permissions --no-time --no-user --no-filesize --git "$@"
}

# Function to handle Obsidian vault note creation.
# It ensures a file name is provided and then sources the main logic
# from 'on.zsh'.
#
# Usage:
#   on "My New Note Title"
#   on 'Another Note'
on() {
  if [ -z "$1" ]; then
    echo "Error: a file name must be provided., e.g. on \"The Space Oddyssey\""
    exit 1
  fi
  # source the logic to handle the `on` functionality
  source $HOME/.config/zsh/functions/on.zsh
}

# EZA Theme
export EZA_CONFIG_DIR="$HOME/.config/.dotfiles/eza"

# obsidian review
alias or="cd ${OBSIDIAN_VAULT:-G:/My Drive/obsidian-work} && nvim ./inbox/*.md"
