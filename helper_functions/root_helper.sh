#!/bin/bash

sudo_mssg () {
    cat << EOF
    A message from your man page on sudo timeout

    timestamp_timeout
    Number of minutes that can elapse before sudo will ask for a passwd again.
    The default is 15 minutes.

EOF
}

## Root user helper functions
# Checking to see if the user is root before running the script
function she_assert_running_as_root {
  if [[ ${EUID} -ne 0 ]]; then
    she_die "Hey everyone, I just tried to do something very silly!"
  else
    printf "\nHey everyone, I just tried to run a script and it turns out I am root.\n\n"
    sudo_mssg    
  fi
}

# Function to customize the not root warning message
function she_die {
  local red=$(tput setaf 1)
  local reset=$(tput sgr0)
  echo >&2 -e "${red}$@${reset}"
  exit 1
}

# To use helper functions for root assert, call this function in a script
she_assert_running_as_root