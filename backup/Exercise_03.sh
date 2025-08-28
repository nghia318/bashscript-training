#!/bin/bash
# Script create single user with name or multiple user and backup
# Check for root
[[ $UID -ne 0 ]] && { echo "Error: Please run as root" >&2; exit 1; }

# Default params
PREFIX="user"
USERNAME=""
BACKUP_DIR="/backups"
TIMESTAMP=$(date +"%Y-%m-%d")

# Parse command-line options
while getopts "c:u:" OPTION; do
  case $OPTION in
    c) USER_COUNT="$OPTARG" ;;
    u) USERNAME="$OPTARG" ;;
    ?) echo "Usage: $0 [-c COUNT] | -u USERNAME]" >&2; exit 1;;
  esac
done

if [[ -n "$USERNAME" && -n "$USER_COUNT" ]]; then
  echo "Error: Cannot use -c and -u together" >&2
  exit 1
fi

mkdir -p "$BACKUP_DIR" || { echo "Error: Cannot create backup directory '$BACKUP_DIR'" >&2: exit 1; }

# Function to process user
process_user() {
  local USERNAME="$1"
  echo "Processing $USERNAME..."

  id "$USERNAME" &>/dev/null && { echo "Warning: $USERNAME already exists, skipping" >&2; return 1; }

  useradd -m "$USERNAME" || { echo "Error: Failed to create $USERNAME" >&2; return 1; }

  PASSWORD=$(head /dev/urandom | tr -dc 0-9 | head -c8)
  echo "$USERNAME:$PASSWORD" | chpasswd || {
    echo "Error: Failed to set password for $USERNAME" >&2
    userdel -r "$USERNAME" 2>/dev/null
    return 1
  }

  HOME_DIR="/home/$USERNAME"
  echo "Hello, your password is: ${PASSWORD}" > "$HOME_DIR/welcome.txt"
  chown "$USERNAME:$USERNAME" "$HOME_DIR/welcome.txt" || {
    echo "Error: Failed to create simple file for $USERNAME" >&2
    userdel -r "$USERNAME" 2>/dev/null
    return 1
  }

  FILENAME="backup-$USERNAME-$TIMESTAMP.tar.gz"
  tar -zcvf "$BACKUP_DIR/$FILENAME" -C "/home" "$USERNAME" 2>/dev/null || {
    echo "Error: Failed to create backup '$BACKUP_DIR/$FILENAME'" >&2
    return 1
  }

  echo "$USERNAME created with password: $PASSWORD"
  echo "Backup created: '$BACKUP_DIR/$FILENAME'"
}

if [[ -n "$USERNAME" ]]; then
  process_user "$USERNAME"
else
  for (( i=1; i<=USER_COUNT; i++ )); do
    process_user "${PREFIX}${i}"
  done
fi

echo "Completed!"
exit 0
