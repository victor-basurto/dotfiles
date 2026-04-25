# $HOME/.config/zsh/functions/custom-dirs.zsh

# Defining associative arrays
typeset -A CUSTOM_DIRS_DESC
typeset -A CUSTOM_DIRS_PATH

# Set custom directories
CUSTOM_DIRS_PATH=(
  brook "$HOME/projects/brookfield"
  conf  "$HOME/.config"
  dot   "$HOME/.config/.dotfiles"
  jsd   "$HOME/projects/js-projects"
  pers  "$HOME/projects/personal-projects"
  nex   "$HOME/projects/nextjs-projects"
  webd  "$HOME/projects/brookfield/websites"
  xmd   "$HOME/projects/brookfield/xmcloud"
  mono  "$HOME/projects/brookfield/xmcloud/brookfield-monorepo/"
  zshd  "$HOME/.config/.dotfiles/zsh/functions/"
  oo    "$HOME/Google Drive/My Drive/obsidian-work"
  reactd "$HOME/projects/react-projects"
  safer "$HOME/projects/safer-projects"
  strap "$HOME/projects/react-projects/strapi-projects"
  umbd  "$HOME/projects/umbraco"
  vimd  "$HOME/.config/nvim"
)

# Custom directories description
CUSTOM_DIRS_DESC=(
  brook  "Brookfield Projects Directory"
  conf   "Configuration Files Directory"
  dot    "Dotfiles Directory"
  jsd    "JavaScript Projects Directory"
  pers   "Personal Projects Directory"
  nex    "Nextjs Projects Directory"
  webd   "Websites Directory"
  xmd    "XM Cloud Projects Directory"
  mono   "XM Cloud Monorepo (Supports site args)"
  zshd   "ZSH Custom Functions Directory"
  oo     "Obsidian Work Directory"
  reactd "React Projects Directory"
  safer  "Safer Projects Directory"
  strap  "Strapi Projects Directory"
  umbd   "Umbraco Projects Directory"
  vimd   "Neovim Configuration Directory"
)

# Function to list custom directories
# Function to list custom directories
function list-dirs {
  echo "--- Custom Directory Shortcuts ---"
  echo "----------------------------------"

  local max_keyword_len=0
  for keyword in ${(k)CUSTOM_DIRS_PATH}; do
    if [[ ${#keyword} -gt $max_keyword_len ]]; then
      max_keyword_len=${#keyword}
    fi
  done

  # Iterate through the keywords
  for keyword in ${(k)CUSTOM_DIRS_PATH}; do
    local description="${CUSTOM_DIRS_DESC[$keyword]:-No description available}"
    local dir_path="${CUSTOM_DIRS_PATH[$keyword]:-Path not set}"
    
    # Expand $HOME to ~ for cleaner display
    dir_path="${dir_path/#$HOME/~}"

    # Special formatting for mono to show it accepts arguments
    local display_key="$keyword"
    if [[ "$keyword" == "mono" ]]; then
        display_key="$keyword [site]"
    fi

    printf "%-12s : %-40s (%s)\n" "$display_key" "$description" "$dir_path"
  done

  echo "----------------------------------"
  echo "Usage:"
  echo "  - Type 'Keyword' (e.g., 'xmd') to jump to a directory."
  echo "  - For 'mono', you can add a site name: 'mono sitea'"
}

# --- Functions ---
function brook { cd "$CUSTOM_DIRS_PATH[brook]" || echo "Error: Path not found"; }
function conf  { cd "$CUSTOM_DIRS_PATH[conf]"  || echo "Error: Path not found"; }
function dot   { cd "$CUSTOM_DIRS_PATH[dot]"   || echo "Error: Path not found"; }
function jsd   { cd "$CUSTOM_DIRS_PATH[jsd]"   || echo "Error: Path not found"; }
function pers  { cd "$CUSTOM_DIRS_PATH[pers]"  || echo "Error: Path not found"; }
function nex   { cd "$CUSTOM_DIRS_PATH[nex]"   || echo "Error: Path not found"; }
function webd  { cd "$CUSTOM_DIRS_PATH[webd]"  || echo "Error: Path not found"; }
function xmd   { cd "$CUSTOM_DIRS_PATH[xmd]"   || echo "Error: Path not found"; }
function mono  { cd "$CUSTOM_DIRS_PATH[mono]"  || echo "Error: Path not found"; }
function zshd  { cd "$CUSTOM_DIRS_PATH[zshd]"  || echo "Error: Path not found"; }
function oo    { cd "$CUSTOM_DIRS_PATH[oo]"    || echo "Error: Path not found"; }
function reactd { cd "$CUSTOM_DIRS_PATH[reactd]" || echo "Error: Path not found"; }
function safer { cd "$CUSTOM_DIRS_PATH[safer]" || echo "Error: Path not found"; }
function strap { cd "$CUSTOM_DIRS_PATH[strap]" || echo "Error: Path not found"; }
function umbd  { cd "$CUSTOM_DIRS_PATH[umbd]"  || echo "Error: Path not found"; }
function vimd  { cd "$CUSTOM_DIRS_PATH[vimd]"  || echo "Error: Path not found"; }

# The "mono" function with argument support
function mono {
  # Strip trailing slash from base_path if it exists to avoid // errors
  local base_path="${CUSTOM_DIRS_PATH[mono]%/}"
  
  if [[ -z "$1" ]]; then
    cd "$base_path" || echo "Error: monorepo root not found at $base_path"
    return
  fi

  local site_path="$base_path/src/rendering/sites/$1"

  if [[ -d "$site_path" ]]; then
    cd "$site_path"
  else
    # Fallback to root
    cd "$base_path" || echo "Error: monorepo root not found"
    echo "\033[33mWarning: Site '$1' doesn't exist. Moved to monorepo root.\033[0m"
    echo "Checked path: $site_path"
  fi
}

# Enable Tab-Completion for `monorepo` sites
local _mono_completion_path="${CUSTOM_DIRS_PATH[mono]%/}/src/rendering/sites/"
compdef "_path_files -W $_mono_completion_path" mono
