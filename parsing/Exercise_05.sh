#!/bin/bash

# Usage message
usage() {
  echo "Usage: $0 [-c compression] [-d directory] [file1 file2 ...]"
  echo " -c: Co,pression type (zip, tar)"
  echo " -d: Destination dir"
  exit 1
}

# Default values
COMPRESSION="none"
DEST_DIR="/tmp"

# Parse options
while getopts "c:d:" OPTION
do 
  case $OPTION in
    c)
      COMPRESSION="$OPTARG"
      echo "Compression set to: $COMPRESSION"
      ;;
    d)
      DEST_DIR="$OPTARG"
      echo "Destination dir set to: $DEST_DIR"
      ;;
    ?)
      usage
      ;;
  esac
done

# Remove options
shift "$(( OPTIND - 1 ))"

# Check file
if [ $# -eq 0 ]
then
  FILES=("default.txt")
  echo "No files specified, using default: ${FILES[*]}"
else
  FILES=("$@")
fi

# Process file
echo "Backing up files to $DEST_DIR with $COMPRESSION compression:"
for FILE in "${FILES[@]}"
do 
  echo " - $FILE"
done