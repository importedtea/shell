#!/bin/bash

read -rp "Enter the value for x: " x
read -rp "Enter the value for y: " y

if [[ "$x" < "$y" ]]; then
    gcd=$x
    echo $gcd
else
    gcd=$y
    echo $gcd
fi

# IF denom = 0
# if [[ $x -eq 0 || $y -eq 0 ]]; then
#     printf "Simplified fraction is %s\n" "$x"

while [ "$gcd" > "1" ]; do
    if [[ $(($x % $gcd)) == 0 && $(($y % $gcd)) == 0 ]]; then
        $gcd--;
    fi
done


# simplify the fraction and print the output
printf("Simplified fraction %d/%d\n" "$(($x/$gcd)), $(($y/$gcd))"