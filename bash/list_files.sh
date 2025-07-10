#!/bin/bash

# Check if directory is passed as argument
if [ -z "$1" ]; then
  echo "Usage: $0 directory_path"
  exit 1
fi

DIR="$1"

# Check if directory exists
if [ ! -d "$DIR" ]; then
  echo "Error: Directory '$DIR' does not exist."
  exit 1
fi

echo "Files in directory '$DIR':"
echo "---------------------------"

# List files with sizes
ls -lh "$DIR" | awk 'NR>1 {print $9, $5}'
