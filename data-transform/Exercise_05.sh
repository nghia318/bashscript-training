#!/bin/bash

[[ $UID -ne 0 ]] &&  { echo "Warning: Please run as root" >&2; exit 1;}

INPUT_FILE=""
OUTPUT_FILE=""
ANONYMIZE_IP=0
REMOVE_FAILED=0
ADD_HEADER=0
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

usage() {
  echo "Usage: $0 -i INPUT_FILE [-o OUTPUT_FILE] [-a] [-f] [-h]" >&2
  echo "Process a log file with sed operations." >&2
  echo " -i for Input file" >&2
  echo " -0 for Output file" >&2
  echo " -a to anonymize IPs" >&2
  echo " -f to remove failed login retries" >&2
  echo " -h add header with timestamp" >&2
  exit 1
}

while getopts "i:o:afh" OPTION; do
  case $OPTION in
    i) INPUT_FILE="$OPTARG" ;;
    o) OUTPUT_FILE="$OPTARG" ;;
    a) ANONYMIZE_IP=1 ;;
    f) REMOVE_FAILED=1 ;;
    h) ADD_HEADER=1 ;;
    ?) usage ;;
  esac
done

# Validate input file
[[ -z "$INPUT_FILE" ]] && { echo "Error: Input file required (-i)" >&2; usage; }
[[ -f "$INPUT_FILE" ]] || { echo "Error: Input file '$INPUT_FILE' does not exist" >&2; exit 1; }
[[ -r "$INPUT_FILE" ]] || { echo "Error: Input file '$INPUT_FILE' is not readable" >&2; exit 1; }

SED_CMD=""
[[ $ADD_HEADER -eq 1 ]] && SED_CMD="1iLog processed on $TIMESTAMP\n"
[[ $ANONYMIZE_IP -eq 1 ]] && SED_CMD="${SED_CMD}s/([0-9]{1,3}\.){3}[0-9]{1,3}/xxx.xxx.xxx.xxx/g;"
[[ $REMOVE_FAILED -eq 1 ]] && SED_CMD="${SED_CMD}/login failed/d;"

# If no operations => copy the file
[[ -z "$SED_CMD" ]] && SED_CMD="p"

# Process the file
echo "Processing '$INPUT_FILE'..."
if [[ -n "$OUTPUT_FILE" ]]; then
  sed -E "$SED_CMD" "$INPUT_FILE" > "$OUTPUT_FILE" || {
    echo "Error: Failed to process '$INPUT_FILE'" >&2
    exit 1
  }
  echo "Output written to '$OUTPUT_FILE'"
else
  sed -E "$SED_CMD" "$INPUT_FILE" || {
    echo "Error: Failed to process '$INPUT_FILE'" >&2
    exit 1
  }
fi

echo "Complete!"
exit 0
