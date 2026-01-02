# $HOME/.config/zsh/functions/custom-dirs.zsh

# Defining associative arrays
typeset -A CUSTOM_DIRS_DESC
typeset -A CUSTOM_DIRS_PATH

# Set custom directories
CUSTOM_DIRS_PATH=(
  brookfielddir "$HOME/projects/brookfield"
  configdir     "$HOME/.config"
  dotfiles      "$HOME/.config/.dotfiles"
  jsdir         "$HOME/projects/js-projects"
  oo            "$HOME/Google Drive/My Drive/obsidian-work"
  ppdir         "$HOME/projects/personal-projects"
  reactdir      "$HOME/projects/react-projects"
  nextdir       "$HOME/projects/nextjs-projects"
  saferdir      "$HOME/projects/safer-projects"
  strapidir     "$HOME/projects/react-projects/strapi-projects"
  umbdir        "$HOME/projects/umbraco"
  vimdir        "$HOME/.config/nvim"
  webdir        "$HOME/projects/brookfield/websites"
  xmdir         "$HOME/projects/brookfield/xm-cloud"
  xmwork        "$HOME/projects/brookfield/xm-cloud/work/brookfield-monorepo/"
  zshdir        "$HOME/.config/zsh/functions/"
)

# Custom directories description
CUSTOM_DIRS_DESC=(
  brookfielddir "Brookfield Projects Directory"
  configdir     "Configuration Files Directory"
  dotfiles      "Dotfiles Directory"
  jsdir         "JavaScript Projects Directory"
  oo            "Obsidian Work Directory"
  ppdir         "Personal Projects Directory"
  reactdir      "React Projects Directory"
  nextdir       "Nextjs Projects Directory"
  saferdir      "Safer Projects Directory"
  strapidir     "Strapi Projects Directory"
  umbdir        "Umbraco Projects Directory"
  vimdir        "Neovim Configuration Directory"
  webdir        "Websites Directory"
  xmdir         "XM Cloud Projects Directory"
  xmwork        "XM Cloud Work Project Directory"
  zshdir        "ZSH Custom Functions Directory"
)

# Function to list custom directories
function list-dirs {
  echo "--- Custom Directory Shortcuts ---"
  echo "----------------------------------"

  # Get the longest keyword length for formatting
  local max_keyword_len=0
  for keyword in ${(k)CUSTOM_DIRS_PATH}; do
    if [[ -n "$keyword" && ${#keyword} -gt $max_keyword_len ]]; then
      max_keyword_len=${#keyword}
    fi
  done

  # Iterate through the keywords and display details
  for keyword in ${(k)CUSTOM_DIRS_PATH}; do
    # Skip empty or invalid keywords
    if [[ -z "$keyword" ]]; then
      echo "WARNING: Skipping empty keyword in CUSTOM_DIRS_PATH."
      continue
    fi

    # Access description and path with default values
    local description="${CUSTOM_DIRS_DESC[$keyword]:-No description available}"
    local dir_path="${CUSTOM_DIRS_PATH[$keyword]:-Path not set or invalid}"

    # Verify that dir_path is a valid string
    if [[ -z "$dir_path" ]]; then
      echo "WARNING: Path for keyword '$keyword' is empty or unset."
      continue
    fi

    # Expand $HOME in dir_path for display (optional, for cleaner output)
    dir_path="${dir_path/#$HOME/~}"

    # Print formatted output
    printf "%-${max_keyword_len}s : %-40s (%s)\n" "$keyword" "$description" "$dir_path"
  done

  echo "----------------------------------"
  echo "To use, simply type the 'Keyword' (e.g., 'oo') and press Enter."
}
# brookfielddir "Brookfield Projects Directory"
function brookfielddir {
  cd "$CUSTOM_DIRS_PATH[brookfielddir]" || echo "Error: brookfielddir not found at ${CUSTOM_DIRS_PATH[brookfielddir]}"
}
# configdir "Configuration Files Directory"
function configdir {
  cd "$CUSTOM_DIRS_PATH[configdir]" || echo "Error: configdir not found at ${CUSTOM_DIRS_PATH[configdir]}"
}
# dotfiles "Dotfiles Directory"
function dotfiles {
  cd "$CUSTOM_DIRS_PATH[dotfiles]" || echo "Error: dotfiles not found at ${CUSTOM_DIRS_PATH[dotfiles]}"
}
# jsdir "JavaScript Projects Directory"
function jsdir {
  cd "$CUSTOM_DIRS_PATH[jsdir]" || echo "Error: jsdir not found at ${CUSTOM_DIRS_PATH[jsdir]}"
}
# oo "Obsidian Work Directory"
function oo {
  cd "$CUSTOM_DIRS_PATH[oo]" || echo "Error: Obsidian vault not found at ${CUSTOM_DIRS_PATH[oo]}"
}
# ppdir "Personal Projects Directory"
function ppdir {
  cd "$CUSTOM_DIRS_PATH[ppdir]" || echo "Error: ppdir not found at ${CUSTOM_DIRS_PATH[ppdir]}"
}
# reactdir "React Projects Directory"
function reactdir {
  cd "$CUSTOM_DIRS_PATH[reactdir]" || echo "Error: reactdir not found at ${CUSTOM_DIRS_PATH[reactdir]}"
}
# nextdir "Nextjs Projects Directory"
function nextdir {
  cd "$CUSTOM_DIRS_PATH[nextdir]" || echo "Error: nextdir not found at ${CUSTOM_DIRS_PATH[nextdir]}"
}
# saferdir "Safer Projects Directory"
function saferdir {
  cd "$CUSTOM_DIRS_PATH[saferdir]" || echo "Error: saferdir not found at ${CUSTOM_DIRS_PATH[saferdir]}"
}
# strapidir "Strapi Projects Directory"
function strapidir {
  cd "$CUSTOM_DIRS_PATH[strapidir]" || echo "Error: strapidir not found at ${CUSTOM_DIRS_PATH[strapidir]}"
}
# umbdir "Umbraco Projects Directory"
function umbdir {
  cd "$CUSTOM_DIRS_PATH[umbdir]" || echo "Error: umbdir not found at ${CUSTOM_DIRS_PATH[umbdir]}"
}
# vimdir "Neovim Configuration Directory"
function vimdir {
  cd "$CUSTOM_DIRS_PATH[vimdir]" || echo "Error: Nvim config not found at ${CUSTOM_DIRS_PATH[vimdir]}"
}
# webdir "Websites Directory"
function webdir {
  cd "$CUSTOM_DIRS_PATH[webdir]" || echo "Error: webdir not found at ${CUSTOM_DIRS_PATH[webdir]}"
}
# xmdir "XM Cloud Projects Directory"
function xmdir {
  cd "$CUSTOM_DIRS_PATH[xmdir]" || echo "Error: xmdir not found at ${CUSTOM_DIRS_PATH[xmdir]}"
}
# xmwork "XMCloud Wrok Project Directory"
function xmwork {
  cd "$CUSTOM_DIRS_PATH[xmwork]" || echo "Error: xmwork not found at ${CUSTOM_DIRS_PATH[xmwork]}"
}
# zshdir "zshdir custom directory"
function zshdir {
  cd "$CUSTOM_DIRS_PATH[zshdir]" || echo "Error: zshdir not found at ${CUSTOM_DIRS_PATH[zshdir]}"
}
