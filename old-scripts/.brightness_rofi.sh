#!/bin/bash

function send_notification() {
	brightness=$(brillo)
	dunstify -a "changebrightness" -u normal -r "9993" -h int:value:"$brightness" -i "brightness-$1" "Brightness: ${brightness}%" -t 2000 -h string:hlcolor:#E0727A 
}

case $1 in
up)
        brillo -q -A 1
	send_notification $1
	;;
down)
	brillo -q -U 1
	send_notification $1
	;;
show)
	brillo
	send_notification $1
	;;
esac

