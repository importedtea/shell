#!/bin/bash

# Add the dependencies you want to install, separated by a space
DEPENDENCIES=(policycoreutils-python git)

# This loop used if cmd args are used
for pkg in "${@}"; do
    if rpm -q $pkg > /dev/null; then
        echo -e "$pkg is already installed"
    else
        #yum install $pkg
        #dnf install $pkg
        echo "Successfully installed $pkg"
    fi
done

# This loop is used if no cmd args are used
for pkg in "${DEPENDENCIES[@]}"; do
    if rpm -q $pkg > /dev/null; then
        echo -e "$pkg is already installed"
    else
        #yum install $pkg
        #dnf install $pkg
        echo "Successfully installed $pkg"
    fi
done