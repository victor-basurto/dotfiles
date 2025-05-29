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
VAULT_DIR="$HOME/obsidian-work"
SOURCE_DIR="zettelkasten"
DEST_DIR="notes"

og() {
  echo "Organizing Zettelkasten notes in: $VAULT_DIR/$SOURCE_DIR"

  # check if zettelkasten directory exists
  if [ ! -d "$VAULT_DIR/$SOURCE_DIR" ]; then
    echo "Zettelkasten directory does not exist: $VAULT_DIR/$SOURCE_DIR"
    return 1
  fi

  # ensure notes directory exists
  mkdir -p "$VAULT_DIR/$DEST_DIR"
  echo "Ensured notes directory exists: $VAULT_DIR/$DEST_DIR"

  # iterate through all markdown files in the source directory
  find "$VAULT_DIR/$SOURCE_DIR" -type f -name "*.md" | while read -r file; do
  echo "-----"
  echo "Processing $(basename $file)"

    # read the file content
    content=$(cat "$file")

    # extract the first tag from 'tags: []'
    tag=$(echo "$content" | ggrep -oP 'tags:\s*\[\s*\K[^\]\s,]+' | head -n 1)

    # extract the first parent tag from 'parent: []'
    parentTag=$(echo "$content" | ggrep -oP 'parent:\s*\[\s*\K[^\]\s,]+' | head -n 1)

    echo "Found tag: $tag"
    echo "Found parent tag: $parentTag"

    if [ ! -z "$tag" ]; then
      targetBaseDir="$VAULT_DIR/$DEST_DIR"
      local targetTagDir

      # construct the target directory based on the parent tag
      if [ ! -z "$parentTag" ]; then
        targetTagDir="$targetBaseDir/$parentTag/$tag"
        echo "Destination directory with parent tag: $targetTagDir"
      else
        targetTagDir="$targetBaseDir/$tag"
        echo "Destination directory without parent tag: $targetTagDir"
      fi

      # create the target directory if it doesn't exist
      mkdir -p "$targetTagDir"

      # move the file to the target directory
      if mv "$file" "$targetTagDir/"; then
        echo "Moved $(basename $file) to $targetTagDir/"
      else
        echo "Failed to move $(basename $file) to $targetTagDir/"
      fi
    else
      echo "No tag found for $(basename $file), skipping."
    fi
  done
  echo "-----"
  echo "Zettelkasten complete."
}
