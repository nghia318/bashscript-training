#!/bin/bash
 
# Count the number of failed logins by IP with LIMIT param.
FILE=$1
LIMIT=3

[[ -e $FILE ]] || { echo "Error: The file not exist" >&2; exit 1; }

# Display CSV header:
echo 'Count, IP. Location'

grep Failed syslog | awk '{print $(NF - 3)}' | sort | uniq -c | sort -nr | while read COUNT IP
do
  if [[ "${COUNT}" -gt "${LIMIT}" ]]
  then
    LOCATION=$(geoiplookup ${IP} | awk -F ', ' '{print $2}')
    echo "${COUNT},${IP},${LOCATION}"
  fi
done
exit 0


