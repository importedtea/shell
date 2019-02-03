#!/bin/bash

read -rp "Enter a number: " number

# The only reason behind fnumber is so that we can output the number used in printf
fnumber=$number

factorial=$( echo "define f(x) {if (x>1){return x*f(x-1)};return 1} f($fnumber)" | bc )

printf "The factorial of %s! is %s\n" "$number" "$factorial"
