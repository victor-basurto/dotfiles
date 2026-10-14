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
    echo "Error: A file name must be set, e.g. on \"Newtons Laws of Motion\""
    return 1
  fi

  local title="$1"

  # "Newtons Laws of Motion" -> "Newtons-Laws-of-Motion"
  local filename="${title// /-}"

  local date
  date=$(date "+%Y-%m-%d")

  # 2026-04-27_Newtons-Laws-of-Motion.md
  local formatted_file_name="${date}_${filename}.md"
  local stem="${formatted_file_name%.md}"

  local vault_path="${OBSIDIAN_VAULT:-$HOME/Google Drive/My Drive/obsidian-work}"
  local inbox_path="$vault_path/inbox"
  local full_file_path="$inbox_path/$formatted_file_name"

  # "newtons-laws-of-motion" -> "Newtons Laws Of Motion"
  local clean_title
  clean_title=$(echo "$filename" \
    | tr '-' ' ' \
    | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)}1')

  cd "$vault_path" || return 1

  # Ensure inbox exists
  mkdir -p "$inbox_path"

  # Create file if it doesn't exist
  [ -f "$full_file_path" ] || touch "$full_file_path"

  # Build nvim substitute command
  local sub_cmd="%s/# $stem/# $clean_title/"

  nvim "$full_file_path" \
    -c "write" \
    -c "Obsidian template notes" \
    -c "$sub_cmd" \
    -c "write"
}
# Create a personal note at vault root level (not inbox).
# Usage:
#   onp "My Personal Note"
onp() {
  if [ -z "$1" ]; then
    echo "Error: a file name must be provided, e.g. onp \"My Personal Note\""
    return 1
  fi

  # note structure
  local file_name=$(echo "$1" | tr ' ' '-')
  local formatted_file_name=$(date "+%Y-%m-%d")_${file_name}.md
  local stem="${formatted_file_name%.md}"
  # Clean title: "testing-note" → "Testing Note"
  local clean_title=$(echo "$file_name" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2); print}')

  # switch to obsidian vault
  cd "${OBSIDIAN_VAULT:?OBSIDIAN_VAULT is not set}" || return 1

  mkdir -p "personal"
  touch "personal/${formatted_file_name}"
  nvim "personal/${formatted_file_name}" \
    -c "write" \
    -c "Obsidian template personal" \
    -c "%s/# ${stem}/# ${clean_title}/" \
    -c "write"
}
