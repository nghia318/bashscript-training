#!/bin/bash

# This script will disable, delete and archive user

ARCHIVE_DIR='/archive'

usage() {
    # Display the usage and exit
    echo "Usage: ${0} [-dra] USER [USERNAME]..." >&2
    echo 'Disable a local Linux account.' >&2
    echo ' -d Deletes account.' >&2
    echo ' -r Removes the home dir associated with the account.' >&2
    echo ' -a Create an archive of the home dir associated with the account.' >&2
    exit 1
}

# Make sure the script is executed with superuser
if [[ "${UID}" -ne 0 ]]
then
  echo 'Please run with sudo or as root.' >&2
  exit 1
fi

# Parse the options
while getops dra OPTION
do 
  case ${OPTION} in
    d) DELETE_USER='true' ;;
    r) REMOVE_OPTION='-r' ;;
    a) ARCHIVE='true' ;;
    ?) usage ;;
  esac
done

# REmove the options while leaving the remaining arguments.
shift "$(( OPTIND - 1))"

# If the user doesn't supply at least one argument, give them help.
if [[ "${#}" -lt 1 ]]
then 
  usage
fi

# Loop through all the usernames supplied as arguments.
for USERNAME in "${@}"
do 
  echo "Processing user: ${USERNAME}"

  # Make sure the UID of the account is at least 1000.
  USERID=$(id -u ${USERNAME})
  if [[ "${USERID}" -lt 1000 ]]
  then
    echo "Refusing to remove the ${USERNAME} account with UID ${USERID}." >&2
    exit 1
  fi
  
  # Create an archive if request to do so.
  if [[ "${ARCHIVE}" = 'true' ]]
  then
    # Make sure the archive dir exist
    if [[ ! -d "${ARCHIVE_DIR}" ]]
    then
      echo "Creating ${ARCHIVE_DIR} directory."
      mkdir -p ${ARCHIVE_DIR}
      if [[ "${?}" -ne 0 ]]
      then 
        echo "The archive dir ${ARCHIVE_DIR} could not be created." >&2
        exit 1
      fi
    fi

    # Archvie the user's home dir and move it into the ARCHVIE_DIR
    HOME_DIR="/home/${USERNAME}"
    ARCHIVE_FILE="${ARCHIVE_DIR}/${USERNAME}.tgz"
    if [[ -d "${HOME_DIR}" ]]
    then 
      echo "Archiving ${HOME_DIR} to ${ARCHIVE_FILE}"
      tar -zcf ${ARCHIVE_FILE} ${HOME_DIR} &> /dev/null
      if [[ "${?}" -ne 0 ]]
      then 
        echo "Could not create ${ARCHIVE_FILE}." >&2
        exit 1
      fi
    else 
      echo "${HOME_DIR} does not exist or is not a directory." >&2
      exit 1
    fi
  fi

  if [[ "${DELETE_USER}" = 'true']] 
  then
    # Delete the user
    userdel ${REMOVE_OPTION} ${USERNAME}

    # Check if the userdel command succeeded.
    if [[ "${?}" -ne 0 ]]
    then 
      echo "The account ${USERNAME} was NOT deleted." >&2
      exit 1
    else 
      echo "The account ${USERNAME} was deleted." 
    fi
  else
    chage -E 0 ${USERNAME}
    if [[ "${?}" -ne 0 ]]
    then
      echo "The account ${USERNAME} was NOT disabled." >&2
      exit 1
    fi
    echo "The account ${USERNAME} was disabled."
  fi
done

exit 0

