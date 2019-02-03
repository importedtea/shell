#!/bin/bash

FILE="/home/$USER/file"

# Change IFS to read from different types of files, such as:
    # , separated
    # | separated, etc

# Read from a \n delimeter text file
while IFS='' read -r line || [[ -n "$line" ]]; do
    # Print the contents of the file
    printf "%s\n" "$line"
done < "$FILE"
