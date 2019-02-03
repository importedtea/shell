#!/bin/bash

# This must be added to the global .bashrc in order to grab real time bash history
# global .bashrc location : /etc/bash.bashrc
# PROMPT_COMMAND="$PROMPT_COMMAND;history -a; history -n"

# Copy all users .bash_history files to current users home dir
for x in /home/*/.bash_history; do
  u=${x%/*}; u=${u##*/}
  mkdir -p ~/user_bashhistory && cp "$x" ~/user_bashhistory/"$u-history.txt"
done
