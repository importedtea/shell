#!/bin/bash

read -rp "What number would you like to check? " number

mod=$(expr $number % 2)
if [ $mod -eq 0 ]; then
	printf "%s is even\n" "$number"
else
	printf "%s is odd\n" "$number"
fi
