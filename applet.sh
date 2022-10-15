#!/bin/bash 
# this list in public domain any one can modefy,distribute and improve it

# TO-DOs
# fix audio mute notify
# clean and refactor
# system info popup
# Topbar
# gamaCorrection
# media info 
# rotate desktop + rotate trackpad
# toggle trackpad 
# toggle blur 
# mode for projection (xrander)

#------------------------------------

# wake_greet.sh
# Topbar_toggle.sh
# audio_controll.sh
# color_correction.sh
# conkybar.sh
# fix_trigger_airplanemode.sh

# notify_brightness.sh
# old-scripts
# power_menu.sh
# resolution.sh
# rofi-wifi-menu.sh
# rotate_desktop.sh
# screen-mirror.sh
# sysinfo_conky.sh
# sysinfo_popup.sh
# sysinfo_popup_notify.sh
# upTopStatus.sh

#---------ToDO--------#


# media_info.sh
# loop.sh
# info.sh
# toggle
# touchpad.sh
# blur_toggle.sh


#---------------------INITIALISE---------------#
BATTERYCAPPSITY=$(cat /sys/class/power_supply/BAT1/capacity)
BATTERYSTATUS=$(cat /sys/class/power_supply/BAT1/status)
BRIGHTNESS=$(brillo)
VOLUMEMASTER=$(amixer get Master | awk '/Left:/{gsub(/[[:punct:]]/,"",$5);left=$5}
     /Right:/{gsub(/[[:punct:]]/,"",$5);right=$5}
     END {print left }'
#     END {print left ORS right}'

)

ACTIVEWINDOWBLUR=$(picom-trans -c -g)
#------------------------------------
# sys_info popup

HOST=$(uname -n)
KERNEL=$(uname -r)
UPTIME=$( uptime | sed 's/.* up //' | sed 's/[0-9]* us.*//' | sed 's/ day, /d /'\
         | sed 's/ days, /d /' | sed 's/:/h /' | sed 's/ min//'\
           |  sed 's/,/m/' | sed 's/  / /')
TIME=$(date +"%I:%M:%S%p")
DATE=$(date +" %^b,%d")
PACKAGES=$(pacman -Q | wc -l)
UPDATED=$(awk '/upgraded/ {line=$0;} END { $0=line; gsub(/[\[\]]/,"",$0); \
         printf "%s %s",$1,$2;}' /var/log/pacman.log)
BATTERYCAPPSITY=$(cat /sys/class/power_supply/BAT1/capacity)
BATTERYSTATUS=$(cat /sys/class/power_supply/BAT1/status)
VolumeMaster=$(pamixer --get-volume-human)
BRIGHTNESS=$(brillo)
NETWORK=$(nmcli |grep wlo1:)

#------------------------------------
MEMORY=$(free -m | awk 'NR==2{printf "%.2f%%\t\t", $3*100/$2 }')
DISK=$(df -h | awk '$NF=="/"{printf "%s\t\t", $5}')
CPU=$(top -bn1 | grep load | awk '{printf "%.2f%%\t\t\n", $(NF-2)}')
#------------------------------------

loop (){
for ((i=1;i<=10000;i++)); 
do 
   # your-unix-command-here
   echo $i
   sleep 1
done
}

#------------------------------------
# check parrameters
if [ -z "$1" ]; then
  echo "Missing parrameter"
  echo "Usage: $0 [volumeHigh|volumeLow|volumeMute|brightnessHigh|brightnessLow] "
  echo
  exit 1
fi

#------------------------------------

case "$1" in
  volumeHigh)
          echo "volumeHigh" &
          pactl -- set-sink-volume 0 +2% & 
	  notify-send --icon=/usr/share/themes/themes/icons/rose-pine-moon-icons/64x64/apps/distributor-logo-archlinux.svg \
		  -h int:value:$VOLUMEMASTER \
		  -r 445 --app-name=system-ui \
		  "Volume" "    master-Volume: $VOLUMEMASTER " ;;


  volumeLow)
          echo "volumeLow" &
          pactl -- set-sink-volume 0 -2% & 
	  notify-send --icon=/usr/share/themes/themes/icons/rose-pine-moon-icons/64x64/apps/distributor-logo-archlinux.svg \
		  -h int:value:$VOLUMEMASTER \
		  -r 445 --app-name=system-ui \
		  "Volume" "    master-Volume: $VOLUMEMASTER " ;;


  volumeMute)
          echo "volumeMute" &
	  amixer set Master toggle && 
	  notify-send --icon=/usr/share/themes/themes/icons/rose-pine-moon-icons/64x64/apps/distributor-logo-archlinux.svg \
		  --urgency=critical \
		  -h int:value:$VOLUMEMASTER \
		  -r 445 --app-name=system-ui \
		  "Volume" "    master-Volume:  $(pamixer --get-volume-human)" ;;

  brightnessHigh)
          echo "brightnessHigh" &
          brillo -A 4  high & 
	  notify-send --icon=/usr/share/themes/themes/icons/rose-pine-moon-icons/64x64/apps/distributor-logo-archlinux.svg \
		  -h int:value:$BRIGHTNESS \
		  -r 445 --app-name=system-ui \
		  "Brightness" "    master-Brightness: $BRIGHTNESS% " ;;


  brightnessLow)
          echo "brightnessLow" &
          brillo -U 4  low & 
	  notify-send --icon=/usr/share/themes/themes/icons/rose-pine-moon-icons/64x64/apps/distributor-logo-archlinux.svg  \
		  -h int:value:$BRIGHTNESS \
		  -r 445 --app-name=system-ui \
		  "Brightness" "    master-Brightness: $BRIGHTNESS% " ;;


  systemInformation)
          echo "systemInformation  $TIME $DATE" &
	  notify-send --icon=/usr/share/themes/themes/icons/rose-pine-moon-icons/64x64/apps/distributor-logo-archlinux.svg  \
          -r 445 --app-name=system-ui \
          "System Information " "           $TIME $DATE\n      Host: $HOST\n      Kernel: $KERNEL\n      Uptime: $UPTIME\n      Memory: $MEMORY\n      CPU: $CPU\n      Disk: $DISK\n     直 $NETWORK\n      Battery: $BATTERYCAPPSITY% $BATTERYSTATUS\n      Volume: $VolumeMaster\n      Brightness: $BRIGHTNESS%\n      Pacman: $PACKAGES packages\n      Last updated: $UPDATED" ;;


  blurHigh)
          echo "blurHigh" &
          picom-trans -c +4 &
	  notify-send --icon=/usr/share/themes/themes/icons/rose-pine-moon-icons/64x64/apps/distributor-logo-archlinux.svg \
		  -h int:value:$ACTIVEWINDOWBLUR \
		  -r 445 --app-name=system-ui \
		  "Blur" "    master-Volume: $ACTIVEWINDOWBLUR " ;;


  blurLow)
          echo "blurLow" &
          picom-trans -c -4 &
	  notify-send --icon=/usr/share/themes/themes/icons/rose-pine-moon-icons/64x64/apps/distributor-logo-archlinux.svg \
		  -h int:value:$ACTIVEWINDOWBLUR \
		  -r 445 --app-name=system-ui \
		  "Blur" "    master-Volume: $ACTIVEWINDOWBLUR " ;;
    

  blurCurrent)
          echo "blur Toggleed for active window" & 
          picom-trans -c -t &
    notify-send --icon=/usr/share/themes/themes/icons/rose-pine-moon-icons/64x64/apps/distributor-logo-archlinux.svg  \
	       -r 445 --app-name=system-ui \
	       "Blur" "blur Toggleed for active window  "  ;;

  loop)
          echo "runing loop " & 
	  loop &
	  notify-send --icon=/usr/share/themes/themes/icons/rose-pine-moon-icons/64x64/apps/distributor-logo-archlinux.svg  \
          -r 445 --app-name=system-ui \
          "Running loop" "" ;;

  toggleblur)
          echo "blur Toggleed " & 
	  TOGGLEBLUR=/home/common/user-bash/toggle/.Blur
          if [ ! -e $TOGGLEBLUR ]; then
              touch $TOGGLEBLUR &
              picom --experimental-backend &
              notify-send --icon=/usr/share/themes/themes/icons/rose-pine-moon-icons/64x64/apps/distributor-logo-archlinux.svg  \
	      -r 445 --app-name=system-ui \
	      "Blur On Globally" "picom --experimental-backend" &
          else
              notify-send --icon=/usr/share/themes/themes/icons/rose-pine-moon-icons/64x64/apps/distributor-logo-archlinux.svg  \
	      -r 445 --app-name=system-ui \
	      "Blur Off Globally" "killall picom" &
              rm -fr $TOGGLEBLUR &
              killall picom &
          fi ;;

  toggletrackpad)
          echo "Trackpad Toggleed " & 
	  TOGGLETRACKPAD=/home/common/user-bash/toggle/.Trackpad
          if [ ! -e $TOGGLETRACKPAD ]; then
              touch $TOGGLETRACKPAD &
              xinput enable 10 &
              notify-send --icon=/usr/share/themes/themes/icons/rose-pine-moon-icons/64x64/apps/distributor-logo-archlinux.svg  \
	      -r 445 --app-name=system-ui \
	      "Trackpad" "Enable from xinput" &
          else
              notify-send --icon=/usr/share/themes/themes/icons/rose-pine-moon-icons/64x64/apps/distributor-logo-archlinux.svg  \
	      -r 445 --app-name=system-ui \
	      "Trackpad" "Disable from xinput" &
              rm -fr $TOGGLETRACKPAD &
              xinput disable 10 &
          fi ;;

esac







