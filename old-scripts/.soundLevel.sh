#show current volume in dmenu

pactl -- get-sink-volume 0 | dmenu
