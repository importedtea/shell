#!/bin/bash

read -rp "What numbers would you like to divide? " num1 num2

calc=$(expr $num1 / $num2)

printf "%s / %s = %s\n" "$num1" "$num2" "$calc"