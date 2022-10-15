#! /bin/bash

# sleep 8
# xsetroot -name "                                    " 
# | date +"%I:%M%p" 
# |dzen2 -p -u -bg "#e8beff" -fg "#1A0A33" -w '100' -h '35' -x '1754' 
# | date +" %^b,%d" 
# | dzen2 -p -u -bg "#e8beff" -fg "#1A0A33" -w '60' -h '35' -x '1856'

# date
#(( while true; do
#     DATE=$(date +" %^b,%d")
#     echo "$DATE "; 
#     sleep 1 ;
#done ) | dzen2 -u -p -bg "#e8beff" -fg "#1A0A33" -w '60' -h '35' -x '1855' ) & 


# time
#(( while true; do
#     TIME=$(date +"%I:%M%p:%S") 
#     echo "$TIME "; 
#     sleep 1 ;
# done ) | dzen2 -u -p -bg "#e8beff" -fg "#1A0A33" -w '100' -h '35' -x '1744')


# CURRENT ACTIVE RESOLUTION
HORIZONTAL_RES=$(1980)
VERTICA_RES=$(1080)

# WIDTH
DATEWITH=$(60)
TIMEWITH=$(100)

#position
TOPLEFT=$(  )
TOPRIGHT
TOPCENTURE
BOTTOMLEFT
BOTTOMRIGHT
BOTTOMCENTURE
