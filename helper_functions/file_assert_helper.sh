#!/bin/bash

function file_assert () {
   if [[ ! -f $1 ]]; then
        touch $1
        echo "Created file $1"
    else
        echo "$1 exists."
    fi 
} 

PTH=$HOME/file1

file_assert "$PTH"