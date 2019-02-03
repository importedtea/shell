#!/bin/bash

# If the group doesn't exist, create it
set -eu

# Exit if there is not at least 2 arguments
# Minimum amount of arguments: <group> <user1> ... <userN>
if [ $# -lt 2 ]; then
  echo
  echo "            IMPROPER USAGE: SEE BELOW "
  echo "-----------------------------------------------"
  echo "Usage: ./useradd.sh [group] [user...userN]"
  echo
  printf "Default group is users\n\n"
  echo "Ex. Single User:"
  echo "./useradd.sh users testUser"
  echo
  echo "Ex. Multiple Users:"
  echo "./useradd.sh users testUser1 testUser2"
  echo "-----------------------------------------------"
  echo

  exit 1; 
fi

# Extract group from cli arguments
group="${1}"; shift

# If the group doesn't exist, add it to /etc/group
if ! egrep --quiet "^${group}:" /etc/group; then
  sudo groupadd "${group}"
fi

# Loop through the users and place them into the gpasswd command
for user in "${@}"; do
  useradd -m ${user} -s /bin/bash
  sudo gpasswd -a "${user}" "${group}"
done

for user in "${@}"; do
  echo "You have successfully added "${user}""
done
