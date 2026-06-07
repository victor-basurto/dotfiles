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
      # 1. Find line matching the key (e.g., target_folder: terminal)
      # 2. Extract everything after the first colon
      # 3. Strip out unwanted quotes if they slip in, and trim spaces
      echo "$content" | \
        ggrep -i "^${key}:" | \
        sed -E "s/^${key}:[[:space:]]*//" | \
        tr -d '"'\''[]' | \
        sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | \
        head -n 1
    }

    content=$(cat "$file")
    
    # extract explicit routing keys
    folder=$(extract_val "target_folder" "$content")
    subFolder=$(extract_val "target_subfolder" "$content")

    echo "Found Target Folder: '$folder'"
    echo "Found Target Subfolder: '$subFolder'"

    if [ -n "$folder" ]; then
      targetBaseDir="$VAULT_DIR/$DEST_DIR"
      
      if [ -n "$subFolder" ]; then
        targetTagDir="$targetBaseDir/$folder/$subFolder"
      else
        targetTagDir="$targetBaseDir/$folder"
      fi

      # The -p flag ensures it creates the parent and the tag folder correctly
      mkdir -p "$targetTagDir"
      
      if mv "$file" "$targetTagDir/"; then
        echo "Successfully moved to $targetTagDir/"
      else
        echo "Failed to move $filename"
      fi
    else
      echo "No target_folder defined for $filename, skipping"
    fi
  done
  echo "-----"
  echo "Zettelkasten complete."
}
