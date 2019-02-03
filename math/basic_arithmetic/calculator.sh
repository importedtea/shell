#!/bin/bash

PS3="what's the operation? "
declare -A op=([add]='+' [subtract]='-' [multiply]='*' [divide]='/')

while true; do
    read -p "what's the first number? " n1
    read -p "what's the second number? " n2
    select ans in "${!op[@]}"; do
        for key in "${!op[@]}"; do
            [[ $REPLY == $key ]] && ans=$REPLY
            [[ $ans == $key ]] && break 2
        done
        echo "invalid response"
    done
    formula="$n1 ${op[$ans]} $n2"
    printf "%s = %s\n\n" "$formula" "$(bc -l <<< "$formula")"
done
