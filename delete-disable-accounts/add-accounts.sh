#!/bin/bash

[[ $UID -ne 0 ]] && { echo "Please run as root" >&2; exit 1; }

# for U in user1 user2 user3; do 
#   useradd $U  || { echo "Failed to add user: $U" >&2; continue; }
#   echo 'pass123' | passwd --stdin "$U"
# done

USER_COUNT=5
PREFIX="user"

for (( i=1; i<=USER_COUNT; i++ )); do
  USERNAME="${PREFIX}${i}"
  echo "Creating $USERNAME..."
  useradd "$USERNAME" ||  { echo "Failed to add user: $USERNAME" >&2; continue; }
  echo 'pass123' | passwd --stdin "$USERNAME"
done