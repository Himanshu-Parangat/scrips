#/bin/bash

#A simple popup showing system information

#   HOST=$(uname -n)
#   KERNEL=$(uname -r)
#   UPTIME=$( uptime | sed 's/.* up //' | sed 's/[0-9]* us.*//' | sed 's/ day, /d /'\
#            | sed 's/ days, /d /' | sed 's/:/h /' | sed 's/ min//'\
#              |  sed 's/,/m/' | sed 's/  / /')
#   PACKAGES=$(pacman -Q | wc -l)
#   UPDATED=$(awk '/upgraded/ {line=$0;} END { $0=line; gsub(/[\[\]]/,"",$0); \
#            printf "%s %s",$1,$2;}' /var/log/pacman.log)
#   BATTERYCAPPSITY=$(cat /sys/class/power_supply/BAT1/capacity)
#   VolumeMaster=$(pamixer --get-volume-human)
#  
#   (
#   echo "System Information" # Fist line goes to title
#   # The following lines go to slave window
#   echo "Host: $HOST "
#   echo "Kernel: $KERNEL"
#   echo "Uptime: $UPTIME "
#   echo "Battery: $BATTERYCAPPSITY% left"
#   echo "Volume: $VolumeMaster "
#   echo "Pacman: $PACKAGES packages"
#   echo "Last updated on: $UPDATED"
# ) | 

conky |dzen2 -p  -fg "#B499F5" -bg "#3B393F" -x "1254" -y "60" -w "680" -l "35" -sa 'l' -ta 'c'\
    -title-name 'popup_sysinfo' -e 'onstart=uncollapse;button1=exit;button3=exit'

 # "onstart=uncollapse" ensures that slave window is visible from start.

