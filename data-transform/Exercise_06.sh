#!/bin/bash

[[ $UID -ne 0 ]] && { echo "Warning: Please run as root" >&2; exit 1; }

INPUT_FILE=""

usage() {
  echo "Usage: $0 -f <INPUT_FILE>" >&2
  echo " -f: Specify the log file" >&2
  exit 1
}

while getopts "f:" OPTION; do
  case $OPTION in
    f)  
      INPUT_FILE="$OPTARG" 
      ;;
    \?) 
      echo "Invalid option: -$OPTARG" >&2
      usage ;;
  esac
done

if [[ $# -eq 0 ]]; then
  usage
fi

# Check input file
[[ -z "$INPUT_FILE" ]] && { echo "Error: Filename cannot be empty" >&2; usage; }
[[ -f "$INPUT_FILE" ]] || { echo "Error: File does not exist" >&2; exit 1; }
[[ -r "$INPUT_FILE" ]] || { echo "Error: File is unreadable" >&2; exit 1; } 

# Create output file
if [[ "$INPUT_FILE" == *.log ]]; then
  OUTPUT_FILE="${INPUT_FILE%.log}_output.log"
else
  OUTPUT_FILE="${INPUT_FILE}_output"
fi

[[ -f "$OUT_FILE" ]] && { echo "Error: Output file name '$OUTPUT_FILE' already exists." >&2; exit 1;}

cp "$INPUT_FILE" "$OUTPUT_FILE"

# --- SED COMMANDS ---

# 1. Censor IPv4 addresses
# Matches four sets of 1-3 digits separated by dots and replaces them with "***".
sed -i -E 's/([0-9]{1,3}\.){3}[0-9]{1,3}/\*\*\*/g' "$OUTPUT_FILE"

# 2. Censor email addresses
# Matches common email formats (e.g., user@domain.com) and replaces them.
# Note: This is a basic regex and may not cover all complex email formats.
sed -i -E 's/\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b/\*\*\*/g' "$OUTPUT_FILE"

# 3. Censor passwords (for example, in a mock log entry)
# This example looks for a 'password=' string and censors the following text.
sed -i -E 's/(password=[^[:space:]]+)/(password=***)/g' "$OUTPUT_FILE"


echo "Completed!"
echo "Original file: $INPUT_FILE"
echo "Censored file: $OUTPUT_FILE"
echo "A new file has been created with sensitive data replaced by '***'."
