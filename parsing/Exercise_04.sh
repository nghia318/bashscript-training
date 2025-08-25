#!/bin/bash

# Usage message
usage() {
    echo "Usage: $0 [-v] [-u unit] file1 'file2...]"
    echo " -v: Verbose output"
    echo " -u: Unit for file size (KB, MB, GB)"
    exit 1
}

# Default values
VERBOSE=false
UNIT="bytes"

# Parse options
while getopts "vu:" OPT
do
  case $OPT in
    v) 
      VERBOSE=true 
      echo "Verbose mode enabled"
      ;;
    u) 
      UNIT="$OPTARG"
      echo "Unit set to: $UNIT"
      ;;
    ?)
      usage
      ;;
  esac
done

# Remove the options while leaving the remain arg
shift "$(( OPTIND - 1 ))"

# Check for remaining arg
if [ $# -eq 0 ]
then 
  echo "Error: At least one file is required"
  usage
fi

# Process remaining arg
for FILE in "$@"
do 
  if [ ! -f "$FILE" ] 
  then
    echo "Error: '$FILE' is not a valid file"
    continue
  fi

  # Get file size based on unit
  case $UNIT in
    KB)
      SIZE=$(stat -c %s "$file" 2>/dev/null)
      SIZE=$(( SIZE / 1024 ))
      unit_lable="KB"
      ;;
    MB)
      SIZE=$(stat -c %s "$file" 2>/dev/null)
      SIZE=$(stat -c %s "$file" 2>/dev/null)
      unit_lable="MB"
      ;;
    GB)
      SIZE=$(stat -f %s "$file" 2>/dev/null)
      SIZE=$(( SIZE / 1024 / 1024 / 1024 ))
      unit_lable="GB"
      ;;
    *) 
      SIZE=$(stat -c %s "$file" 2>/dev/null)
      unit_lable="bytes"
      ;;
  esac

  # Output based on verbose setting
  if [ "$VERBOSE" = true ]
  then
    echo "File: $FILE, Size: $SIZE $UNIT_LABEL"
  else
    echo "$FILE: $SIZE $UNIT_LABEL"
  fi
done 
