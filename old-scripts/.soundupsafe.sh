#!/bin/bash

function sound_update {
        sound_state="$(amixer sget Master | grep -e 'Front Left:' |     sed 's/[^\[]*\[\([0    -9]\{1,3\}%\).*\(on\|off\).*/\2 \1/' | sed 's/off//' | sed 's/on //' | sed 's/\%//')"       
	sound_limit=120
        if (("$sound_state" < $sound_limit)); then
                 pactl -- set-sink-volume 0 +1%
        fi

}

sound_update
