#!/bin/bash

# $BASH_SOURCE
# An array variable whose members are the source filenames where the corresponding
# shell function names in the FUNCNAME array variable are defined.
# The shell function ${FUNCNAME[$i]} is defined in the file ${BASH_SOURCE[$i]}
# and called from ${BASH_SOURCE[$i+1]}

# The if statement is checking to see if the script was executed or sourced.
# If it is executed, this if statement utilizes printf
# If it is sourced, this if statement will exit
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    # $1 = 1; $2 = $SOURCE
    printf "ERROR: You must source your function.\n"
    
    # Note: This if condition is not actually an error. We can check this with the following line
    # If you want it to be an error, you have to customize your own user-generated error values
    echo $?

    exit
fi
