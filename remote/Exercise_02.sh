#!/bin/bash

SERVER_FILE='servers'
SSH_OPTIONS='-o ConnectTimeout=2'

usage() {
  echo "Usage: $0 [-nsv] [-f FILE] COMMAND" >&2
  echo "  -f FILE require a file for list of servers. Default ${SERVER_FILE}" >&2
  echo "  -n display the command that would have been executed and exit" >&2
  echo "  -s execute command using sudo on the remote server" >&2
  echo "  -v verbosemode, display the server name before executing command" >&2
  exit 1;
}

[[ $UID -eq 0 ]] && { echo "Do not run this script as root. Use the -s option instead." >&2; usage; }

while getopts "f:nsv" OPTION; do
  case $OPTION in
    f) SERVER_FILE="${OPTARG}" ;;
    n) DRY_RUN='true' ;;
    s) SUDO='sudo' ;;
    v) VERBOSE='true' ;;
    *) usage ;;
  esac
done

shift "$(( OPTIND - 1 ))"

# Make sure at least 1 arg
[[ "${#}" -lt 1 ]] && { usage; }
# Everything remain behind is a single command.
COMMAND="${@}"

# Promt for sudo password
if [[ "${SUDO}" = "sudo" ]]; then
  read -sp "Enter sudo password: " SUDO_PASSWORD
  echo
fi

# Make sure the SERVER_FILE exists.
[[ -e "${SERVER_FILE}" ]] || { echo "Error: Cannot open server list file ${SERVER_FILE}" >&2; exit 1; }

EXIT_STATUS='0'

for SERVER in $(cat "${SERVER_FILE}"); do
  [[ "${VERBOSE}" = 'true' ]] && { echo "${SERVER}"; }
  
  SSH_COMMAND="echo '${SUDO_PASSWORD}' | ssh ${SSH_OPTIONS} ${SERVER} ${SUDO} -S ${COMMAND}"

  if [[ "${DRY_RUN}" = 'true' ]]; then 
    echo "DRY RUN: ${SSH_COMMAND}"
  else 
    eval "${SSH_COMMAND}"
    SSH_EXIT_STATUS=$?
    if [[ "${SSH_EXIT_STATUS}" -ne 0 ]]; then
      EXIT_STATUS="${SSH_EXIT_STATUS}" 
      echo "Execution on ${SERVER} failed." | tee -a logfile.txt >&2
    fi
  fi
done

exit ${EXIT_STATUS}