#!/bin/bash

read -rp "How many numbers are in the series? " totnum

x=0; y=1; i=2;

printf "Fibonacci Series up to %s terms :: " "$totnum" 
  echo "$x" 
  echo "$y" 
  while [ $i -lt $totnum ] 
  do 
      i=`expr $i + 1 ` 
      z=`expr $x + $y ` 
      echo "$z" 
      x=$y 
      y=$z 
  done
