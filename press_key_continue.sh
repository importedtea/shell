#!/bin/bash

# Press any key
printf "Method 1:\n"
read -rsp "Press any key to continue..." -n1
echo 
printf "Congratulations, you pressed any key to continue.\n\n"

# ISSUE 1
    # When pressing a key, such as 3, it will output 3Key pressed
# Input timer
printf "Method 2:\n"
read -t20 -n1 -r -p "Press any key in the next 20 seconds..." key

### Check exit code directly with ex. if mycmd;, not indirectly with $?
if [ "$?" -eq "0" ]; then
  printf "Key pressed.\n\n"
else
  printf "No key pressed.\n\n"
fi

# Escape to continue
printf "Method 3:\n"
read -rsp $"Press escape to continue..." -d $'\e'
printf "\nCongratulations, you pressed escape to continue.\n\n"

# Preselected choice
printf "Method 4:\n"
printf "Preselected choice\n"
read -rp $"Do you want to continue [Y / N] : " -ei $'Y' key;
printf "You chose %s \n" "$key"