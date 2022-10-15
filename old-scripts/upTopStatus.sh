#! /bin/bash

sleep 8
( while true; do
	TIME=$(date +"%I:%M%p:%S") 
	DATE=$(date +" %^b,%d")
	echo "$DATE |$TIME "; 
	sleep 1 ;
done ) | dzen2 -u -p -bg "#e8beff" -fg "#1A0A33" -w '170' -h '35' -x '1754'
