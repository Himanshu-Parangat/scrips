#!/bin/bash
# Tested using bash version 4.1.5
for ((i=1;i<=10000;i++)); 
do 
   # your-unix-command-here
   echo $i
   notify-send -r 556 "loop" "$i"
   sleep 1
done
