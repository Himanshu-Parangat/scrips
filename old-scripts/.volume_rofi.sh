#!/bin/bash

function send_notification() {
	volume=$(pamixer --get-volume)
	dunstify -a "changevolume" -u normal -r "9993" -h int:value:"$volume" -i "volume-$1" "Volume: ${volume}%" -t 2000 -h string:hlcolor:#E0727A 
 
}

case $1 in
up)
	# Set the volume on (if it was muted)
	pamixer -u
	pamixer -i 5 
	send_notification $1
	;;
upForce)
	# Set the volume on (if it was muted)
	pamixer -u
	pamixer -i 1 --allow-boost
	send_notification $1
	;;
down)
	pamixer -u
	pamixer -d 5 --allow-boost
	send_notification $1
	;;
mute)
	pamixer -t
	if $(pamixer --get-mute); then
		volume=$(pamixer --get-volume)
        	dunstify -a "changevolume" -u normal -r "9993" -h int:value:"$volume" -i "volume-$1" "Volume=> Mute: ${volume}%" -t 2000 -h string:frcolor:#787878  -h string:hlcolor:#787878 

	else
		send_notification up
	fi
	;;
esac

send_notification()
