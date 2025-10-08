# ============================================
# $HOME/.config/zsh/functions/bko.zsh
# ============================================
#!/usr/bin/env zsh

# Obsidian Vault Backup Script for ZSH
# Backs up the Obsidian vault with timestamp

# Configuration
VAULT_PATH="${OBSIDIAN_VAULT:-$HOME/Google Drive/My Drive/obsidian-work}"
BACKUP_BASE_PATH="$HOME/backups/obsidian-work"
LOG_FILE="$HOME/backups/obsidian-backup.log"

# Create timestamp for this backup
TIMESTAMP=$(date "+%Y-%m-%d_%H-%M-%S")
CURRENT_BACKUP_PATH="$BACKUP_BASE_PATH/backup-$TIMESTAMP"

# Function to write log
log_message() {
  local message="$1"
  local log_entry="$(date '+%Y-%m-%d %H:%M:%S') - $message"
  echo "$log_entry" >> "$LOG_FILE"
  echo "\033[0;36m$log_entry\033[0m"
}

echo "\033[0;32m"
echo "=== Obsidian Vault Backup ==="
echo "Starting backup process..."
echo "\033[0m"

# Create backup directory if it doesn't exist
if [ ! -d "$BACKUP_BASE_PATH" ]; then
  mkdir -p "$BACKUP_BASE_PATH"
  log_message "Created backup directory: $BACKUP_BASE_PATH"
fi

# Check if vault exists
if [ ! -d "$VAULT_PATH" ]; then
  echo "\033[0;31m"
  echo "ERROR: Vault not found at $VAULT_PATH"
  echo "\033[0m"
  log_message "ERROR: Vault not found at $VAULT_PATH"
  return 1
fi

# Perform backup
log_message "Starting backup of Obsidian vault..."
log_message "Source: $VAULT_PATH"
log_message "Destination: $CURRENT_BACKUP_PATH"

echo "\033[0;33mCopying files...\033[0m"
cp -r "$VAULT_PATH" "$CURRENT_BACKUP_PATH"


if [ $? -eq 0 ]; then
  # Calculate size and file count
  if command -v du &> /dev/null; then
    SIZE=$(du -sh "$CURRENT_BACKUP_PATH" | cut -f1)
  else
    SIZE="N/A"
  fi
  
  FILE_COUNT=$(find "$CURRENT_BACKUP_PATH" -type f | wc -l | tr -d ' ')
  
  echo "\033[0;32m"
  echo "✓ Backup completed successfully!"
  echo "\033[0m"
  log_message "Backup completed successfully. Size: $SIZE, Files: $FILE_COUNT"
  
  # Keep only last 8 backups (2 months worth of weekly backups)
  BACKUP_COUNT=$(find "$BACKUP_BASE_PATH" -maxdepth 1 -type d -name "backup-*" | wc -l | tr -d ' ')
  
  if [ "$BACKUP_COUNT" -gt 8 ]; then
    echo "\033[0;33mCleaning up old backups...\033[0m"
    find "$BACKUP_BASE_PATH" -maxdepth 1 -type d -name "backup-*" | sort | head -n -8 | while read -r old_backup; do
      rm -rf "$old_backup"
      log_message "Deleted old backup: $(basename "$old_backup")"
    done
  fi
  
  # Recount after cleanup
  BACKUP_COUNT=$(find "$BACKUP_BASE_PATH" -maxdepth 1 -type d -name "backup-*" | wc -l | tr -d ' ')
  
  echo "\033[0;36m"
  echo "Backup Details:"
  echo "  Location: $CURRENT_BACKUP_PATH"
  echo "  Size: $SIZE"
  echo "  Files: $FILE_COUNT"
  echo "  Total backups: $BACKUP_COUNT"
  echo "\033[0m"
  
  log_message "Backup process finished. Total backups retained: $BACKUP_COUNT"
else
  echo "\033[0;31m"
  echo "ERROR: Backup failed!"
  echo "\033[0m"
  log_message "ERROR: Backup failed"
  return 1
fi
