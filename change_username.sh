#!/bin/bash

read -p "What username would you like to change?: " user

if [[ $user = "root" ]]; then
	printf "Hey everyone, I just tried to do something very silly!"
	exit 1
fi

pkill -KILL -u $user

read -p "What would you like their new username to be?: " new

usermod -l $new -m -d /home/$new $user
