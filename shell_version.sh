#!/bin/bash

# ISSUE 1
    # This script needs a massive overhaul
printf "Your default shell is: %s\n\n" "$(basename $SHELL)"

printf "Your current shell is: "
#current_shell=$( ps -ef | grep $$ | grep -v grep | grep -Po '/bin\K[^ ]+' )

# This only works if the program is sourced
current_shell=$(ps -p $$ | awk '{print $4}' | tail -n 1)
echo $current_shell

# printf "Checking %s version...\n\n" "$SHELL"
# $SHELL --version
