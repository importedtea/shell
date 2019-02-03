#!/bin/bash

printf "You should be ashamed of yourself for having to use this script..."
printf "Just kidding, use this script when you have created a script on windows"

cat << "EOF"
                   
                 _.-;;-._
          '-..-'|   ||   |
          '-..-'|_.-;;-._|
          '-..-'|   ||   |
          '-..-'|_.-''-._|
EOF

# GOALS
    # Take in filename as command line argument and pass to the command below
    # Option to convert all files in a given directory or current directory
        # Maybe if it is ran without any arguments, it will just do it on all files in the
        # directory of the script
# sed -i 's/\r//' filename

# ISSUE 1
    # Need to find a way to implement this in a new for loop to process
    #+ all files in the working dir

# If cmd args are equal to 0 set dirs to working directory
# Else, set the dirs to whatever was passed by cmd args.
[ $# -eq 0 ] && dirs=$(pwd) || dirs=$@

for filename in "${@}"; do
   sed -i 's/\r//' $filename
done

# Implement a for loop that implements the beginning line
# for filename in "$1/*"; do
#    sed -i 's/\r//' $filename
# done
