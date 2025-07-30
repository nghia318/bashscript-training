#!/bin/bash
# This script creats a new user on the local system.
# You will be prompted to enter the username, person name, a password and then display them

# Make sure the script is being executed with superuser privileges.
if [[ "${UID}" -ne 0 ]]
then 
  echo 'Please run with sudo or as root.'
  exit 1
fi

# Get username
read -p 'Enter the username to create: ' USER_NAME

# Get the real name 
read -p 'Enter the name of the person for this account: ' COMMENT

# Get the password
read -p 'Enter the password to user for the account: ' PASSWORD

# Create the account.
useradd -c "${COMMENT}" -m ${USER_NAME}

# Check if the useradd command succeeded
if [[ "${?}" -ne 0 ]]
then
  echo "The account could not be created."
  exit 1
fi

# Set the password
echo "${USER_NAME}:${PASSWORD}" | chpasswd

if [[ ${?} -ne 0 ]]
then 
  echo "The password for account could not be set."
  exit 1
fi

# Force password change on first login
passwd -e ${USER_NAME}

# Display the username, password, and the host where user created
echo 
echo 'username:'
echo "${USER_NAME}"
echo
echo 'password:'
echo "${PASSWORD}"
echo
echo 'host:'
echo "${HOSTNAME}"
exit 0

