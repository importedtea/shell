#!/bin/bash

# Method 1
[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

printf "Congratulations, you just gained sudo privileges to run this script\\n"
