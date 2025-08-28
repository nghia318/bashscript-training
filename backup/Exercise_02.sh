#!/bin/bash

# Check for root
[[ $UID -ne 0 ]] && { echo "Please run as root" >&2; exit 1;}

USER_COUNT=${1:-1}
PREFIX="user"
BACKUP_DIR="/backups"
TIMESTAMP=$(date +"%Y-%m-%d")

# Validate USER_COUNT
[[ "$USER_COUNT" =~ ^[0-9]+$ ]] || { echo "User count must be a number" >&2; exit 1;}

# Create backup dir
mkdir -p "$BACKUP_DIR" || { echo "Cannot create backup dir '$BACKUP_DIR'" >&2; exit 1;}

for (( i=1; i<=USER_COUNT; i++ )); do
  USERNAME="${PREFIX}${i}"
  echo "Processing $USERNAME..."

  id "$USERNAME" &>/dev/null && { echo "Warning: $USERNAME already exists, skipping" >&2; continue; }

  useradd -m "$USERNAME" || { echo "Error: Failed to create $USERNAME" >&2; continue; }

  PASSWORD=$(head /dev/urandom | tr -dc 0-9 | head -c8)
  echo "$USERNAME:$PASSWORD" | chpasswd || {
    echo "Error: Failed to set password for $USERNAME" >&2
    userdel -r "$USERNMAE" 2>/dev/null
    continue
  }

  HOME_DIR="/home/$USERNAME"
  echo "Hello, your password is: ${PASSWORD}" > "$HOME_DIR/welcome-${USERNAME}.txt"
  chown "$USERNAME:$USERNAME" "$HOME_DIR/welcome-${USERNAME}.txt" || {
    echo "Error: Failed to create sample file for $USERNAME" >&2
    userdel -r "$USERNAME" 2>/dev/null
    continue
  }

  FILENAME="backup-$USERNAME-$TIMESTAMP.tar.gz"
  tar -czf "$BACKUP_DIR/$FILENAME" -C "/home" "$USERNAME" 2>/dev/null || {
    echo "Error: Failed to create backup '$BACKUP_DIR/$FILENAME'" >&2
    continue
  }

  echo "$USERNAME created with password: $PASSWORD"
  echo "Backup created: '$BACKUP_DIR/$FILENAME'"
done

echo "Completed!"

exit 0
