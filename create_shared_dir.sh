#!/bin/bash

# This script relies on some features of grant_sudo.sh, just as a reference

# Apply sudo privileges
[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

# Add dir helper
function _dir_assert_ () {
   if [[ ! -d $1 ]]; then
        mkdir -p $1
        echo "Created dir $1"
    else
        echo "$1 exists"
    fi 
}

function _dir_check_ () {
    if [[ -d $1 ]]; then
        if [[ $1 == /home* || /root* ]]; then
            echo "you chose a path in the home directory"
            
            # Grab the basename of the path to determine if it is a subdirectory
            bass=$(basename "$1")
            echo basename is $bass

            # Use the list of $allusers and grep to see if it exists.
            l=$( echo "$bass" | tr ' ' '\n' | grep -w "$allusers" )
            t=$( grep $bass <<< "$allusers" )
            echo $l
            if [[ $bass != home && -z $l ]]; then
                echo 'however, you may use this path because it is in a subdirectory'
            else
                echo 'please do not use this path, it is a home directory'
            fi
        else
            echo "that path is OK"
        fi
    fi
}

allusers=$( cut -d: -f1 /etc/passwd )
# base=$(basename /home/fabrm/test)
# l=$( echo $allusers | tr ' ' '\n' | grep -w "$base" )
# echo $l
# sleep 20

srcgroup=/home/user/user

# This is a viable solution to preventing home directory creation
# This would need to be a loop, ex. function like dir_check and then use a for loop; else condition checks return value and then determines if it needs to ask again for a new path
# ISSUE
    # This will not let you put anything in a location starting with /home
# This script is ran as root, meaning $USER is root, therefore, does it matter if we restrict what dir it goes in??? There is no possible way it can be ran as anyone else because of commands like chmod, chgrp, etc. However, this might be useful in other scripts that do not require any root access, but the _dir_check_ is ~87.5% functioning at the moment.
_dir_check_ $srcgroup

# if [[ $srcgroup = /home/* || $srcgroup = /home ]]; then
#   echo 'Please refrain from using a home directory as the source of the directory.'
# else
#   echo 'not /home'
# fi


#test "${PWD##/home/$USER}" != ${PWD}


echo made it to eternal slumber
sleep 200

# ISSUE
    # There needs to be a way to quit the program if the group name entered already exists
    # groupadd will return a message stating group '' already exists, but continues the script

# Ask appropriate questions
read -rp "Are you creating a new group? [y/n] " newgroup
if [[ ${newgroup} == 'y' && "! egrep --quiet "^${newgroup}:" /etc/group" ]]; then
    read -rp "What group would you like to add? " group
    #groupadd "${group}"
fi

# ISSUE
    # There needs to be a way to prevent script runners from changing permissions on inappropriate folders.
    # Ex. say you type in /home/$USER and nothing else, dir_check_helper will say it exists, but then the next part will change the group owner and permissions, essentially removing you from your own home folder if you are not apart of the group
read -rp "What is the source directory for that group? " srcgroup
dir_check_helper $srcgroup

# This will prevent the $srcgroup from being in a home directory of a user
# Maybe this can be made more specific
# There will need to be a try again case if it resides only in /home/$USER and not /home/$USER/dir
#https://unix.stackexchange.com/questions/6435/how-to-check-if-pwd-is-a-subdirectory-of-a-given-path
test "${PWD##/home/$USER}" != ${PWD}

# Add the $group as the new group owner of the $srcgroup
#chgrp -R $group $srcgroup

restrict=3770
nice=3775

read -rp "Do you want non-group members to be able to view files? [y/n] " otherview
if [[ ${otherview} == 'n' ]]; then
    echo restricted
    #chmod -R $restrict $srcgroup
else
    echo nice
    #chmod -R $nice $srcgroup
fi

#read -rp "Which users would you like to add to the group? " userapply

# Add the group if it doesn't exist




# # Set the appropriate permissions for that $group based on $otherview
# # If statement to eval yes/no answer into appropriate permission bits, prepend 2 always
#     # should add in extra security bit, so others cannot delete others files
#     # maybe it is 3 that we want to add instead of 2 --https://askubuntu.com/questions/313089/how-can-i-share-a-directory-with-an-another-user
# chmod -R $otherview $srcgroup
