#/bin/bash


 #A simple popup showing system information

 HOST=$(uname -n)
 KERNEL=$(uname -r)
 UPTIME=$( uptime | sed 's/.* up //' | sed 's/[0-9]* us.*//' | sed 's/ day, /d /'\
          | sed 's/ days, /d /' | sed 's/:/h /' | sed 's/ min//'\
            |  sed 's/,/m/' | sed 's/  / /')
 PACKAGES=$(pacman -Q | wc -l)
 UPDATED=$(awk '/upgraded/ {line=$0;} END { $0=line; gsub(/[\[\]]/,"",$0); \
          printf "%s %s",$1,$2;}' /var/log/pacman.log)
 BATTERYCAPPSITY=$(cat /sys/class/power_supply/BAT1/capacity)
 BATTERYSTATUS=$(cat /sys/class/power_supply/BAT1/status)
 VolumeMaster=$(pamixer --get-volume-human)
 BRIGHTNESS=$(brillo)
 NETWORK=$(nmcli |grep wlo1:)
 (         
 echo "System Information" # Fist line goes to title
 # The following lines go to slave window
 echo "Host: $HOST "
 echo "Kernel: $KERNEL"
 echo "Uptime: $UPTIME "
 echo "$NETWORK"
 echo "Battery: $BATTERYCAPPSITY% $BATTERYSTATUS"
 echo "Volume: $VolumeMaster "
 echo "Brightness: $BRIGHTNESS%"
 echo "Pacman: $PACKAGES packages"
 echo "Last updated: $UPDATED"
 ) | dzen2 -p  -fg "#b499a0" -bg "#3B393F" -x "1634" -y "60" -w "240" -l "9" -sa 'l' -ta 'c'\
    -title-name 'popup_sysinfo' -e 'onstart=uncollapse;button1=exit;button3=exit' -fn 'nerd-fonts-jetbrains-mon' &
 # "onstart=uncollapse" ensures that slave window is visible from start.

 (export SYSTEM_POPUP="$!")

