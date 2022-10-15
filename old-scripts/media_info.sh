#! /bin/bash

# media info 
# (( while true; do
#     MEDIA_INFO=$(pacmd list-sink-inputs |grep media.name |sed  's/media.name//gm' |sed 's/=//gm')
#     sleep 1 ;
# done ) &

# | dzen2 -u -p -bg "#e8beff" -fg "#1A0A33" -w '100' -h '35' -x '1744')

VOLUME=$(
amixer get Master | \
awk '/Left:/{gsub(/[[:punct:]]/,"",$5);left=$5}
     /Right:/{gsub(/[[:punct:]]/,"",$5);right=$5}
     END {print left ORS right}'
) 

MEDIA_INFO=$(pacmd list-sink-inputs |grep media.name |sed  's/media.name//gm' |sed 's/=//gm') 
# (echo "$MEDIA_INFO " | dzen2 -l "8" -sa 'l' -u -p -bg "#e8beff" -fg "#1A0A33" -w '360' -h '35' -x '655' )  


dunstify -a "mpv" -r 9993 -h int:value:$VOLUME "Volume => $VOLUME" "$MEDIA_INFO"
