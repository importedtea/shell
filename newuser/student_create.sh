#!/bin/bash

function dir_check_helper () {
   if [[ ! -d $1 ]]; then
        mkdir -p $1
        echo "Created dir $1"
    else
        echo "$1 exists"
    fi 
}

read -rp "Enter the users name: " name

IFS=" " read first last <<< $name

fInit=$( echo $first | cut -c1-1 | awk '{print tolower($0)}' )
last=$( echo $last | awk '{print tolower($0)}' )

# Create the beginning of the pw
fpw=$( echo $first | cut -c1-2 | awk '{print toupper($0)}' )
lpw=$( echo $last  | cut -c1-2 )

# Storage of new username
username=$last$fInit

# Create four random numbers between 1000 and 9999
random=$( echo $((1000 + RANDOM % 8999 )))

# Create the password and append $random
# ex. for Test Student
# TEst$random
pw=${fpw}${lpw}${random}

PTH=Students/$username

dir_check_helper "$PTH"

cat << EOF > $PTH/${username}_newuser.txt

Network Logon for $name
Logon Name: $username
Password:   $pw

EOF

echo "Converting file to .docx"

# Convert .txt to .docx
$( pandoc -s $PTH/${username}_newuser.txt -o $PTH/${username}_newuser.docx )

# Cleanup
#rm ${building}_${username}_newuser.txt