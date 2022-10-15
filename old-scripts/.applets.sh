  #!/bin/bash


# brightness [ ]
# blur [ ]
# sount [ ]
# sound,mic,camera disable [ ]
# sount play,pause, next [ ]
# flight mode [ ]
# network [ ]
# print screen [ ] 
# Tochpad lock [ ]
# keyboard lock [ ]
# key lock [ ]
# screen lock(jahy) [ ]
# screen mode vivid,black,inverted,cinema,dim [ ]
# rotate Touchscreen,Touchpad [ ]
# piwall control,wallpaper [ ]
# bitcoin [ ]
# wether [ ]
# system info concy [ ]
# battery and warning [ ]
# opening app message [ ]
# clipboad message [ ]
# layout switch [ ]
# zoom scale [ ]
# badaass greeting quotes [ ]






function send_notification() {
	brightness=$(brillo)
	dunstify -a "changebrightness" -u normal -r "9993" -h int:value:"$brightness" -i "brightness-$1" "tochpadEnable: ${brightness}%" -t 2000 -h string:hlcolor:#E0727A 
}

case $1 in
tochpadEnable)
  xinput set-prop 11 "Device Enabled" 1
	dunstify -a "tochpadStatus" -u normal -r "9993" -h int:value:"$brightness" -i "brightness-$1" "Tochpad => Enable" -t 2000 -h string:hlcolor:#E0727A 
	# send_notification $1
	;;
tochpadDisable)
  xinput set-prop 11 "Device Enabled" 0
	dunstify -a "tochpadStatus" -u normal -r "9993" -h int:value:"$brightness" -i "brightness-$1" "Tochpad => Disabled" -t 2000 -h string:hlcolor:#E0727A 
 	# send_notification $1
	;;
esac

#----------------------rotate_desktop----------------------#

#!/bin/bash
#
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
