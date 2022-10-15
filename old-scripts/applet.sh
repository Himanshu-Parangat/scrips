#!/bin/bash

# show number of user logged in and tty 













#------------------blur------------------------#

#switch blur off picom
super + F4
▏ ▏ killall picom && dunstify -a "compositor" -u normal -r "9993" -h int:value:100 -i "compositor" "Blur => Disable" -t 2000 -h string:frcolor:#787878 -h string:hlcolor:#787878

#switch blur on picom
super + F5
▏ ▏ picom --experimental-backends & dunstify -a "compositor" -u normal -r "9993" -h int:value:100 -i "compositor" "Blur => Enable" -t 2000 -h string:frcolor:#E0727A -h string:hlcolor:#E0727A                                                                                                














#----------------brightness---------------------#

#increase brightness by 10%
#XF86MonBrightnessUP
super + alt + F3
▏ ▏ brillo -q -A 1
 
#decrease brightness by 10%
#XF86MonBrightnessDown
super + alt + F2
▏ ▏ brillo -q -U 1
 
#increase brightness by 10%
#XF86MonBrightnessUP
super + F3
▏ ▏ /home/violet/sysconf/user-bashsc/.brightness_rofi.sh up
 
#decrease brightness by 10%
#XF86MonBrightnessDown
super + F2
▏ ▏ /home/violet/sysconf/user-bashsc/.brightness_rofi.sh down
 










#----------------manipulate xdisplay------------#
 
super + alt + i
▏  xcalib -invert -alter
 



#----------------volume-------------------------#
 
#force switch up volume by 1%
super + alt + F8
▏ ▏ pactl -- set-sink-volume 0 +1%
 
#switch up volume by 1%
# super + alt + F8














#    /home/violet/sysconf/user-bashsc/.soundupsafe.sh
 
 
#switch down volume by 1%
super + alt + F7
▏ ▏ pactl -- set-sink-volume 0 -1%
 
 
#toggle volume mute/unmute
super + alt + F6
▏ ▏ pactl set-sink-mute 0 toggle
 















#----------------volumeRofiWiget-------------------------#
 
#switch up volume by 1%
XF86AudioRaiseVolume
▏ ▏ /home/violet/sysconf/user-bashsc/.volume_rofi.sh up
 
#force switch up volume beyond 100 by 1%
super + F8
▏ ▏ /home/violet/sysconf/user-bashsc/.volume_rofi.sh upForce
                                                                                                                                                                                                                                                                                              
#switch down volume by 1%
XF86AudioLowerVolume
▏ ▏ /home/violet/sysconf/user-bashsc/.volume_rofi.sh down

#switch up volume by 1%
XF86AudioMute
▏ ▏ /home/violet/sysconf/user-bashsc/.volume_rofi.sh mute
▏ 









#---------------power------------------------------#

#shutdown wokstation
super + Escape
▏ ▏ rofi -show power-menu -modi power-menu:rofi-power-menu
▏ 
#suspend workstation
super + F1
▏ systemctl suspend

#lock screen
super + l
▏  xsecurelock














#------------------menus---------------------------#

#run rofi
super + p
▏  rofi -show drun

#run rofi application
super + shift + p
▏  rofi -show

#run rofi clipboard
super + shift + v
▏  rofi -modi "clipboard:greenclip print" -show clipboard

#run wifi menu
super + F12
▏  /home/violet/git-package/rofi-wifi-menu/rofi-wifi-menu.sh











#-----------------screenshort------------------------#

# gnome gui
Print
▏ ▏ gnome-screenshot -i

#flameshot gui                                                                                                                                                                                                                                                                                
super + Print                                                                                                                                                                                                                                                                                 
▏ ▏ flameshot gui                                                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                                                                              










#---------------------rotate screen & touchpad---------#                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                                              
# normal oriantation                                                                                                                                                                                                                                                                          
super + alt + w                                                                                                                                                                                                                                                                               
▏ ▏ /home/violet/sysconf/user-bashsc/rotate_desktop.sh normal                                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                                                              
# normal oriantation                                                                                                                                                                                                                                                                          
super + alt + d                                                                                                                                                                                                                                                                               
▏ ▏ /home/violet/sysconf/user-bashsc/rotate_desktop.sh right                                                                                                                                                                                                                                  
                                                                                                                                                                                                                                                                                              
# normal oriantation                                                                                                                                                                                                                                                                          










#---------------------------------------rotate_desktop-------------------------#
# rotate_desktop.sh
#
# Rotates modern Linux desktop screen and input devices to match. Handy for
# convertible notebooks. Call this script from panel launchers, keyboard
# shortcuts, or touch gesture bindings (xSwipe, touchegg, etc.).
#
# Using transformation matrix bits taken from:
#   https://wiki.ubuntu.com/X/InputCoordinateTransformation
#

# Configure these to match your hardware (names taken from `xinput` output).
# or run (cat /proc/bus/input/devices |grep -i name) to get the name.

# Example
# TOUCHPAD='SynPS/2 Synaptics TouchPad'
# TOUCHSCREEN='Atmel Atmel maXTouch Digitizer'


TOUCHPAD='ELAN0709:00 04F3:30A0 Touchpad'
TOUCHSCREEN='ELAN0709:00 04F3:30A0 Mouse'

if [ -z "$1" ]; then
  echo "Missing orientation."
  echo "Usage: $0 [normal|inverted|left|right] [revert_seconds]"
  echo
  exit 1
fi

function do_rotate
{
  xrandr --output $1 --rotate $2

  TRANSFORM='Coordinate Transformation Matrix'

  case "$2" in
    normal)
      [ ! -z "$TOUCHPAD" ]    && xinput set-prop "$TOUCHPAD"    "$TRANSFORM" 1 0 0 0 1 0 0 0 1
      [ ! -z "$TOUCHSCREEN" ] && xinput set-prop "$TOUCHSCREEN" "$TRANSFORM" 1 0 0 0 1 0 0 0 1
      ;;
    inverted)
      [ ! -z "$TOUCHPAD" ]    && xinput set-prop "$TOUCHPAD"    "$TRANSFORM" -1 0 1 0 -1 1 0 0 1
      [ ! -z "$TOUCHSCREEN" ] && xinput set-prop "$TOUCHSCREEN" "$TRANSFORM" -1 0 1 0 -1 1 0 0 1
      ;;
    left)
      [ ! -z "$TOUCHPAD" ]    && xinput set-prop "$TOUCHPAD"    "$TRANSFORM" 0 -1 1 1 0 0 0 0 1
      [ ! -z "$TOUCHSCREEN" ] && xinput set-prop "$TOUCHSCREEN" "$TRANSFORM" 0 -1 1 1 0 0 0 0 1
      ;;
    right)
      [ ! -z "$TOUCHPAD" ]    && xinput set-prop "$TOUCHPAD"    "$TRANSFORM" 0 1 0 -1 0 1 0 0 1
      [ ! -z "$TOUCHSCREEN" ] && xinput set-prop "$TOUCHSCREEN" "$TRANSFORM" 0 1 0 -1 0 1 0 0 1
      ;;
  esac
}

XDISPLAY=`xrandr --current | grep primary | sed -e 's/ .*//g'`
XROT=`xrandr --current --verbose | grep primary | egrep -o ' (normal|left|inverted|right) '`

do_rotate $XDISPLAY $1

if [ ! -z "$2" ]; then
  sleep $2
  do_rotate $XDISPLAY $XROT 
  exit 0
fi

nitrogen --restore
