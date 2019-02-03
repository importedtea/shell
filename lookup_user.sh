#!/bin/bash

orange=$(tput setaf 3)
normal=$(tput sgr0)

# The location of where to search for usernames
loc=/etc/passwd

printf "Searching for specified users...\n"
echo "-----------"

# If cmd args == >=1; run for loop
# else show all users
for user in "${@}"; do
    # grep the first user in the loop to the loc
    grep -q "^$user" $loc

    # Set the return value of grep to retval
    retval=$?

    # If grep produced exit status 0/1; echo correct status
    [ $retval -eq 0 ] && echo "${orange}$user${normal}"
done

echo "-----------"
