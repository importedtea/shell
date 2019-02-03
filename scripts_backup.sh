#!/bin/bash

# GOALS
    # Automatically backup the scripts folder located at $HOME/scripts
    # Automatically create a filename starting with date in format 060618
    # Append a _backup to that files date
    # Ex directory name 060618_backup
        # Inside this file will contain all scripts

function dir_assert () {
   if [[ ! -d $1 ]]; then
        mkdir -p $1
        echo "Created dir $1"
    else
        echo "$1 exists"
    fi 
} 

# Define the source and backup directories
src_loc=$HOME/scripts
backup_loc=$HOME/scripts_backup

# Run assertion checks on directories
dir_assert "$src_loc"
dir_assert "$backup_loc"

# Grab the current date in correct format and append _backup to the name
current_date=$(date "+%m%d%y")
current_date+=_backup

# Create the destination directory to dump the files
des_loc=$backup_loc/$current_date

# Use rsync to transfer the data from src_loc to des_loc
# --delete is used because we want these directories to be an exact replica
    # Meaning, if a file exists in dest_loc that is not in src_loc, it will delete it
rsync -av --delete $src_loc $des_loc

