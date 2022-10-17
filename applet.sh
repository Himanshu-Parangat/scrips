#!/bin/bash 
# this list in public domain any one can modefy,distribute and improve it

# TO-DOs
# clean and refactor
# rotate desktop + rotate trackpad
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


SCALE(){
SCALEOUTPUT=$(echo -e "Normal 1 
Lower 0.9
Lower 0.8
Lower 0.7
Lower 0.6
Lower 0.5
Higher 1.5
Higher 2
Higher 2.5
Higher 3
" | rofi -dmenu -p Scale -i 7 -a X -theme-str '#listview {columns:2; }')

Scale= echo $SCALEOUTPUT |sed -e 's/[a-zA-Z]/ /g'  | tr -d " \t\n\r" 

notify-send "output set to $SCALEOUTPUT" "$Scale"

 

xrandr --output  $(xrandr |grep connected\ primary  | awk '{ print $1 }') \
--scale $( echo $SCALEOUTPUT |sed -e 's/[a-zA-Z]/ /g'  | tr -d " \t\n\r") 

nitrogen --restore
}


GDBAR ()
{
  
(
amixer get Master | \
awk '/Left:/{gsub(/[[:punct:]]/,"",$5);left=$5}
     /Right:/{gsub(/[[:punct:]]/,"",$5);right=$5}
     END{print left ORS right}'
) | gdbar -max 100 -min 0 -l 'Vol ' -bg '#777777' -fg '#00ff00' -ss '2' | dzen2 -p -u -l '1' -w '150' -y '100' -x '100' -ta c -sa c -e 'onstartup=uncollapse;button3=exit'
}

wifi-menu()
{

notify-send --icon=/usr/share/themes/themes/icons/rose-pine-moon-icons/64x64/apps/distributor-logo-archlinux.svg \
  -r 445 --app-name=system-ui \
  "Getting list of available Wi-Fi networks..."
# Get a list of available wifi connections and morph it into a nice-looking list
wifi_list=$(nmcli --fields "SECURITY,SSID" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*.?\S/ /g" | sed "s/^--/ /g" | sed "s/  //g" | sed "/--/d")

connected=$(nmcli -fields WIFI g)
if [[ "$connected" =~ "enabled" ]]; then
	toggle="睊  Disable Wi-Fi"
elif [[ "$connected" =~ "disabled" ]]; then
	toggle="直  Enable Wi-Fi"
fi

# Use rofi to select wifi network
chosen_network=$(echo -e "$toggle\n$wifi_list" | uniq -u | rofi -dmenu -i -selected-row 1 -p "Wi-Fi SSID: " )
# Get name of connection
chosen_id=$(echo "${chosen_network:3}" | xargs)

if [ "$chosen_network" = "" ]; then
	exit
elif [ "$chosen_network" = "直  Enable Wi-Fi" ]; then
	nmcli radio wifi on
elif [ "$chosen_network" = "睊  Disable Wi-Fi" ]; then
	nmcli radio wifi off
else
	# Message to show when connection is activated successfully
	success_message="You are now connected to the Wi-Fi network \"$chosen_id\"."
	# Get saved connections
	saved_connections=$(nmcli -g NAME connection)
	if [[ $(echo "$saved_connections" | grep -w "$chosen_id") = "$chosen_id" ]]; then
		nmcli connection up id "$chosen_id" | grep "successfully" && notify-send "Connection Established" "$success_message"
	else
		if [[ "$chosen_network" =~ "" ]]; then
			wifi_password=$(rofi -dmenu -p "Password: " )
		fi
		nmcli device wifi connect "$chosen_id" password "$wifi_password" | grep "successfully" && notify-send "Connection Established" "$success_message"
	fi
fi

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

  colour_correction)
          echo "colour_correction" & 
    notify-send --icon=/usr/share/themes/themes/icons/rose-pine-moon-icons/64x64/apps/distributor-logo-archlinux.svg  \
	       -r 445 --app-name=system-ui \
	       "xrander" "select colour"  

          colour_correction=$(echo -e "Normal       1:1:1\n  light grass  0.85:1:1\n cleanGrean   0.5:0.6:0.5\n rose pink    1:0.85:1\n  rosePink     0.9:0.7:0.7\n          lukeYellow   0.7:0.6:0.5\n          Straw        1:1:0.9\n          blues        0.7:0.7:1\n          warmBlue     0.7:0.6:0.8\n          White        255:255:255\n          Black        0.001:0.001:0.001\n          Cyan         0.1:1:1\n          Yellow       1:1:0.01\n          Megenta      1:0.01:1\n          red          1:0.1:0.1\n          green        0.1:1:0.1\n          purple       1:0.6:0.8\n " | rofi -dmenu -p Correction -i 7 -a X -theme-str '#listview {columns:2; }') 
          
          colour_set= echo $colour_correction |sed -e 's/[a-zA-Z]/ /g'  | tr -d " \t\n\r" 
          
          notify-send "color profile set to $colour_correction"
          
          DISPLAY= $(xrandr |grep connected\ primary  | awk '{ print $1 }')
          
          xrandr --output $(xrandr |grep connected\ primary  | awk '{ print $1 }')  \
          --gamma $( echo $colour_correction |sed -e 's/[a-zA-Z]/ /g'  | tr -d " \t\n\r") 
            
             ;;


  scale)
          echo "scale" &
	  notify-send --icon=/usr/share/themes/themes/icons/rose-pine-moon-icons/64x64/apps/distributor-logo-archlinux.svg \
		  -h int:value:$BRIGHTNESS \
		  -r 445 --app-name=system-ui \
		  "xrander" "select scale" 
      SCALE		;;

  gdbar)
          echo "gdbar" &
	  notify-send --icon=/usr/share/themes/themes/icons/rose-pine-moon-icons/64x64/apps/distributor-logo-archlinux.svg \
		  -h int:value:$BRIGHTNESS \
		  -r 445 --app-name=system-ui \
		  "dzen2" "deployed bar" 
      GDBAR		;;

  wifi)
          echo "wifi-menu" &
	  notify-send --icon=/usr/share/themes/themes/icons/rose-pine-moon-icons/64x64/apps/distributor-logo-archlinux.svg \
		  -h int:value:$BRIGHTNESS \
		  -r 445 --app-name=system-ui \
		  "wifi" "NetworkManager" 
      wifi-menu		;;
esac






