#!/bin/bash

function dir_check_helper () {
   if [[ ! -d $1 ]]; then
        mkdir -p $1
        echo "Created dir $1"
    else
        echo "$1 exists"
    fi 
}

# Variables from staff_info
name=$name
building=$building
dept=$dept 
desc=$desc 
fptime=$fptime
expire=$expire
expdate=$expdate
fil=$fil
prevuser=$prevuser

# Create email addr variable
# Check if a contains b; then
if [[ $building == *"STC"* ]]; then
    conv_email='stcenters'
else
    conv_email='iu29'
fi

# ISSUE
# No support for middle names as of now, besides just grabbing the first middle initial
# specify a delimiter of space, store text before IFS delimiter of blank space
#IFS=" " read first middle last <<< $name
IFS=" " read first last <<< $name

fInit=$( echo $first | cut -c1-1 | awk '{print tolower($0)}' )
# mInit=$( echo $middle | cut -c1-1 | awk '{print tolower($0)}' )
lFour=$( echo $last | cut -c1-4 | awk '{print tolower($0)}' )

# Storage of new username
username=$lFour$fInit

# Predefined password to shuffle
char=Temp

# Shuffle the predefined password
if [[ $building == "IU29" ]]; then
    mix=$(echo $char | sed 's/./&\n/g' | shuf | tr -d "\n")
    mix+="IU29"
else
    mix=$(echo $char | sed 's/./&\n/g' | shuf | tr -d "\n")
    mix+="STC"
fi

# Set user information to a building specific path
if [[ $building == *"STC"* ]]; then
    PTH=STC/${username}
else
    PTH=IU29/${username}
fi

# Assert that path
dir_check_helper "$PTH"

# Add additional information from staff_info.sh to the correct path
printf "The user is %s\n" "$name" > $PTH/${building}_${username}_demographics.txt
printf "They are apart of the %s building\n" "$building" >> $PTH/${building}_${username}_demographics.txt
printf "You can find them in the %s department\n" "$dept" >> $PTH/${building}_${username}_demographics.txt
printf "Their job description is %s\n" "$desc" >> $PTH/${building}_${username}_demographics.txt
printf "They are a %s employee\n" "$fptime" >> $PTH/${building}_${username}_demographics.txt

if [[ "$expire" == "does not" ]]; then
    printf "Their account %s expire\n" "$expire" >> $PTH/${building}_${username}_demographics.txt
else
    printf "Their account %s expire on %s\n" "$expire" "$expdate" >> $PTH/${building}_${username}_demographics.txt
fi

if [[ "$fil" == "no" ]]; then
    fil="do not"
    printf "They %s need the files of the previous user\n" "$fil" >> $PTH/${building}_${username}_demographics.txt
else
    fil="will"
    printf "They %s need the files of the previous user %s\n" "$fil" "$prevuser" >> $PTH/${building}_${username}_demographics.txt
fi

# Send login information to PTH file
cat << EOF > $PTH/${building}_${username}_newuser.txt
$building Website, Employee Portal and E-Mail - $name

I.   Network Logon
    a.	Logon to a computer using your username ( $username ) and temporary password ( $mix )
    b.	Press the Ctrl, Alt and Delete keys at the same time
    c.	Select “Change Password”
    d.	Enter the temporary password (above) once
    e.	Enter a new password twice and click OK
    (Note – Please see the password complexity requirements below)
    f.	Click on Cancel after your password is successfully changed

II.  Employee Portal
    a.	Follow instructions for IU29 Website
    b.	Click on “Human Resources”, then “Employee Portal” 
    c.	Read the instructions on this page if this is the first time you are accessing the Employee Portal.
    d.	Click on click on the Schuylkill Intermediate Unit Employee Portal
    e.	Enter your username and password
    f.	Click on the Employee tab (top right)
    g.	Click on the Pay History tab (top left)
    h.	Logout of the Employee Portal window when finished

III. IU29 E-Mail – ($username@${conv_email}.org)
    a.	Option 1 - Go to http://webmail.iu29.org/
    b.	Option 2 – 
    i.	Follow instructions for IU29 Website
    ii.	Click on the “EMAIL” link in the top right
    c.	Enter your username ( $username ) and temporary password ( $mix )
    d.	Click on “Log On”
    e.	Change your password the first time you access your e-mail:
    i.	Click on Options (top right)
    ii.	Click on Change Password (menu on left)
    iii.	Enter $mix as the Old Password and enter your new password twice
    (Note – Please see the password complexity requirements below)
    iv.	Click on Save (top)
    f.	Logout of all e-mail windows when finished

NOTE – E-mail and network passwords must meet the following minimum requirements when they are changed or created:  
    ->	May not be one of the user's last 12 passwords
    ->	May not contain significant portions of the user's account name or full name
    ->	Must be at least 8 characters in length
    ->	Must contain characters from three of the following four categories:
        ->	English uppercase characters (A through Z)
        ->	English lowercase characters (a through z)
        ->	Base 10 digits (0 through 9)
        ->	Non-alphabetic characters (for example, !, $, #, %)
EOF

echo "Converting file to .docx"

# Convert .txt to .docx
$( pandoc -s $PTH/${building}_${username}_newuser.txt -o $PTH/${building}_${username}_newuser.docx )

# Cleanup
#rm ${building}_${username}_newuser.txt
