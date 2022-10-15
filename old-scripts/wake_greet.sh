#!/bin/bash
#
UPTIME=$( uptime | sed 's/.* up //' | sed 's/[0-9]* us.*//' | sed 's/ day, /d /'\
           | sed 's/ days, /d /' | sed 's/:/h /' | sed 's/ min//'\
             |  sed 's/,/m/' | sed 's/  / /')

BATTERYCAPPSITY=$(cat /sys/class/power_supply/BAT1/capacity)
BATTERYSTATUS=$(cat /sys/class/power_supply/BAT1/status)


notify-send --app-name=system-ui --icon=/usr/share/themes/themes/icons/rose-pine-moon-icons/64x64/apps/distributor-logo-archlinux.svg "System Awake" "    uptime: $UPTIME \n    Battery: $BATTERYCAPPSITY% $BATTERYSTATUS"
 
