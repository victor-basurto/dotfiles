# $HOME/.config/zsh/functions/handy-funcs.zsh

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
  eza --tree --level="$level_arg" --icons --git --git-ignore --group-directories-first "$@"
}
