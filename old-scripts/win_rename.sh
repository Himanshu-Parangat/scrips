#!/bin/bash 
# this list in public domain any one can modefy,distribute and improve it


GETID=$(xdotool selectwindow)
echo $GETID

OLDNAME=$(xdotool getwindowname $GETID)

notify-send "SYSEM-INFO" "$OLDNAME"

OPTION=$(echo "Name Class Icon Exit" | tr " " "\n" | sed -e 's/ //' |rofi -dmenu)

echo "$OPTION"

case $OPTION in
  Name)
    notify-send "name"
    echo name changed
  ;;
  Class) 
    notify-send "class"
    echo class changed
  ;;
  Icon) 
    notify-send "icon"
    echo icon changed
  ;;
  Exit) 
    notify-send "exit"
    echo halt 
  ;; 
esac

OPTIONICON=$(ls -aR /usr/share/icons ) | rofi -dmenu
#-------------------------

