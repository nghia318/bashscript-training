#!/bin/bash

# This script deletes a user

if [[ "${UID}" -ne 0 ]]
then
  echo 'Please run with sudo or root.' >&2
  exit 1
fi

USER="${1}"

# Delete user
userdel ${USER}

# Make sure the user got deleted
if [[ "${?}" -ne 0 ]]
then
  echo "The account ${USER} was NOT deleted." >&2
  exit 1
fi

# Tell the user the account was deleted.
echo "The account ${USER} was deleted."

exit 0