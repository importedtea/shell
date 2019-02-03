#!/bin/bash

function dir_check_helper () {
   if [[ ! -d $1 ]]; then
        mkdir -p $1
        echo "Created dir $1"
    else
        echo "$1 exists"
    fi 
}

# Create this variable in your script and assign it the path of what you want to use
PTH=$HOME/directory1

# Call the function to check if it exists or not
dir_check_helper "$PTH"

# Finally, continue to use $PTH in any call to a path that you would like to use

# If assigning a variable to the $PTH, such as the following:
    # building=building1
    # $username=test
    # and you want the dir to be called building/username
    # then assign the PTH as follows before checking with the helper function:
        # PTH=${building}/${username}
        # then
        # dir_check_helper "$PTH"