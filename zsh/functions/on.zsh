# !$HOME/.config/zsh/functions/on.zsh

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
  file_name=$(echo $1 | tr ' ' '-')
  formatted_file_name=$(date "+%Y-%m-%d")_${file_name}.md
  cd "${OBSIDIAN_VAULT:-$HOME/Google Drive/My Drive/obsidian-work}" || exit
  touch "inbox/${formatted_file_name}"
  nvim "inbox/${formatted_file_name}"
}

