#!/bin/bash

SOURCE_DIR="$HOME/documents"
BACKUP_DIR="$HOME/backups"

TIMESTAMP=$(date +"%Y-%m-%d")

FILENAME="backup-$(basename "$SOURCE_DIR")-$TIMESTAMP.tar.gz"

if [ ! -d "$BACKUP_DIR" ]; then
  echo "Creating backup dir: $BACKUP_DIR"
  mkdir -p "$BACKUP_DIR"
fi

echo "Starting backup of $SOURCE_DIR..."

tar -czvf "$BACKUP_DIR/$FILENAME" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")" 2>/dev/null || { echo "$SOURCE_DIR not exist" >&2; exit 1; }

echo "Backup complete!"
echo "Backup file created at: $BACKUP_DIR/$FILENAME"

exit 0