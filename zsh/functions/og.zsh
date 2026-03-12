# $HOME/.config/.dotfiles/zsh/functions/og.zsh

# Documentation for og.zsh

# This script provides the `og` (Organize Zettelkasten) function for your Zsh shell.
# It automates the organization of markdown notes from your Obsidian `zettelkasten`
# directory into a structured `notes` directory based on frontmatter tags.

# How it works:
# 1. Scans all `.md` files in the `VAULT_DIR/SOURCE_DIR` (your zettelkasten).
# 2. Reads the file content to extract the first 'tags' and 'parent' values
#    from your Obsidian frontmatter (e.g., `tags: [sitecore]`, `parent: [front-end]`).
# 3. If a 'parent' tag is found (e.g., `front-end`), it creates a nested directory
#    structure: `VAULT_DIR/DEST_DIR/parent-tag/primary-tag`
#    (e.g., `notes/front-end/sitecore`).
# 4. If no 'parent' tag is found, it creates a flat structure:
#    `VAULT_DIR/DEST_DIR/primary-tag` (e.g., `notes/sitecore`).
# 5. Moves the processed markdown file into its respective organized directory.

# Prerequisites:
# - **GNU Grep (ggrep):** This script requires GNU Grep for its Perl-compatible
#   regular expressions (`-P` option). On macOS, you can install it via Homebrew:
#   `brew install grep` (it will be installed as `ggrep`).
#   Ensure the `ggrep` command is used in the script.

# Usage:
# 1. Ensure this file is sourced in your .zshrc (e.g., `source ~/.config/zsh/functions/og.zsh`).
# 2. Run the function from your terminal: `og`

# Configuration:
# Adjust the VAULT_DIR, SOURCE_DIR, and DEST_DIR variables below to match your Obsidian setup.
# Directory containing markdown files
VAULT_DIR="${OBSIDIAN_VAULT:-$HOME/Google Drive/My Drive/obsidian-work}"
SOURCE_DIR="zettelkasten"
DEST_DIR="notes"

og() {
  echo "Organizing Zettelkasten notes in: $VAULT_DIR/$SOURCE_DIR"

  if [ ! -d "$VAULT_DIR/$SOURCE_DIR" ]; then
    echo "Zettelkasten directory does not exist: $VAULT_DIR/$SOURCE_DIR"
    return 1
  fi

  mkdir -p "$VAULT_DIR/$DEST_DIR"

  find "$VAULT_DIR/$SOURCE_DIR" -type f -name "*.md" | while read -r file; do
    echo "-----"
    filename=$(basename "$file")
    echo "Processing $filename"

    # Extract function: Strips leading dashes, brackets, and spaces
    extract_val() {
        local key=$1
        local content=$2
        # 1. Find the key line and the line after it
        # 2. Remove the key name (e.g., 'tags:')
        # 3. Strip brackets []
        # 4. Remove the leading dash '-' and any space following it
        # 5. Trim leading/trailing whitespace
        echo "$content" | ggrep -A 1 "^${key}:" | \
        sed "/^${key}:/d" | \
        tr -d '[]' | \
        sed 's/^[[:space:]]*-//' | \
        sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | \
        head -n 1
    }

    content=$(cat "$file")
    
    tag=$(extract_val "tags" "$content")
    parentTag=$(extract_val "parent" "$content")

    # Final Safety Check for weird characters
    [[ "$tag" == "[" || "$tag" == "]" || -z "$tag" ]] && tag=""
    [[ "$parentTag" == "[" || "$parentTag" == "]" || -z "$parentTag" ]] && parentTag=""

    echo "Found tag: '$tag'"
    echo "Found parent tag: '$parentTag'"

    if [ -n "$tag" ]; then
      targetBaseDir="$VAULT_DIR/$DEST_DIR"
      
      if [ -n "$parentTag" ]; then
        targetTagDir="$targetBaseDir/$parentTag/$tag"
      else
        targetTagDir="$targetBaseDir/$tag"
      fi

      # The -p flag ensures it creates the parent and the tag folder correctly
      mkdir -p "$targetTagDir"
      
      if mv "$file" "$targetTagDir/"; then
        echo "Successfully moved to $targetTagDir/"
      else
        echo "Failed to move $filename"
      fi
    else
      echo "No valid tag found for $filename, skipping."
    fi
  done
  echo "-----"
  echo "Zettelkasten complete."
}
