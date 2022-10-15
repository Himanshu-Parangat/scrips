#!/bin/bash
## vim:ft=zsh ts=4

myvol() {

    percentage=`amixer |grep -A 6 \'Front\' |awk {'print $5'} |grep -m 1 % |sed -e 's/[][%]//g'`
    ismute=`amixer |grep -A 6 \'Front\'|awk {'print $7'} |grep -m 1 "[on|off]" | sed -e 's/[][]//g'`

    if [[ $ismute == "off" ]]; then
        echo -n "$(echo "0" | gdbar -fg '#aecf96' -bg gray40 -h 7 -w 60)"
    else
        echo -n "$(echo $percentage |gdbar -fg '#aecf96' -bg gray40 -h 7 -w 60)"
    fi
}

while true; do
    #echo "^i(/home/buttons/.bitmaps/volume.xbm)$(myvol)"
    echo "DONE $percentage, $ismute"
	sleep 1
done
