#!/bin/bash

# get all users
getent passwd | while IFS=: read -r name password uid gid gecos home shell; do
    # only users that own their home directory
    if [ -d "$home" ] && [ "$(stat -c %u "$home")" = "$uid" ]; then
        # only users that have a shell, and a shell is not equal to /bin/false or /usr/sbin/nologin
        if [ ! -z "$shell" ] && [ "$shell" != "/bin/false" ] && [ "$shell" != "/usr/sbin/nologin" ]; then
            echo "$name's home directory is $home using shell $shell"
        fi
    fi
done