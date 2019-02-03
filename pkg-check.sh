#!/bin/bash

# If you want to make a predefined list to install, uncomment the INST line
# Single Package Ex. INST="git"
# Multi Package  Ex. INST="git git git"
# ^ uncomment one line above to use second for loop without cmd args
INST=""

# This loop used if cmd args are used
for pkg in "${@}"; do
    if dpkg --get-selections | grep -q "^$pkg[[:space:]]*install$" > /dev/null; then
        printf "%s is already installed\n\n" "$pkg"
    else
        read -rp "Package $pkg is not installed...would you like to install it? [y/n] " verify
        if [[ $verify == 'y' ]]; then
            #apt-get -qq install $pkg
            printf "Successfully installed %s\n" "$pkg"
            printf "Script is not configured to install anything...please modify script!\n\n"
        else
            printf "package %s will not be installed...\n\n" "$pkg"
        fi
    fi
done

# This loop is used if no cmd args are used
for pkg in $INST; do
    if dpkg --get-selections | grep -q "^$pkg[[:space:]]*install$" > /dev/null; then
        printf "%s is already installed\n\n" "$pkg"
    else
        #apt-get -qq install $pkg
        printf "Successfully installed %s\n" "$pkg"
        printf "Script is not configured to install anything...please modify script!\n\n"
    fi
done
