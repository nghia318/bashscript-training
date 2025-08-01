#!/bin/bash
# The script add a local user and you must supply a username as an argument to the script. 
# Also this version adding redirection.

# Make sure the script is being executed with root
if [[ "${UID}" -ne 0 ]]
then 
  echo 'Please run with sudo or as root.' >&2
  exit 1
fi

# If they don't supply at least one argument, then give them usage.
if [[ "${#}" -lt 1 ]]
then 
  echo "Usage: ${0} USER_NAME [COMMENT]..." >&2
  echo 'Create an account on the local system with the name of USER_NAME and a comments field of COMMENT.' >&2
  exit 1
fi

# First param is the user name
USER_NAME="${1}"

# The rest param are for the account comments
shift
COMMENT="${@}"

# Generate a password
PASSWORD=$(date +%s%N)

# Create the user with password
useradd -c "${COMMENT}" -m ${USER_NAME} &> /dev/null

# Check to see if the useradd command succeeded.
if [[ "${?}" -ne 0 ]]
then 
  echo 'The account could not be created.' >&2
  exit 1
fi 

# Set the password.
echo ${PASSWORD} | passwd --stdin ${USER_NAME} &> /dev/null

# Check to see if the passwd command succeeded.
if [[ "${?}" -ne 0 ]]
then 
  echo 'The password for the account could not be set.' >&2
  exit 1
fi

# Force password change on first login.
passwd -e ${USER_NAME} &> /dev/null

# Display the username, password, and the host where the user was created.
echo echo 'username:'
echo "${USER_NAME}"
echo 
echo 'password:'
echo "${PASSWORD}"
echo 
echo 'host:'
echo "${HOSTNAME}"
exit 0