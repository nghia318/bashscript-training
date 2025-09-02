#!/bin/bash

SERVER_FILE='/vagrant/servers'

[[ -e "$SERVER_FILE" ]] || { echo "Error: File not exists" >&2; exit 1; }

for SERVER in $(cat ${SERVER_FILE} ); do
  echo "Pinging ${SERVER}"
  ping -c 1 ${SERVER} &> /dev/null
  [[ "${?}" -ne 0 ]] && { echo "${SERVER} down."; } || { echo "${SERVER} up."; }
done
