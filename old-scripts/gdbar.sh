#!/bin/sh

(
amixer get Master | \
awk '/Left:/{gsub(/[[:punct:]]/,"",$5);left=$5}
     /Right:/{gsub(/[[:punct:]]/,"",$5);right=$5}
     END{print left ORS right}'
) | gdbar -max 100 -min 0 -l 'Vol ' -bg '#777777' -fg '#00ff00' -ss '2' | dzen2 -p -u -l '1' -w '150' -y '100' -x '100' -ta c -sa c -e 'onstartup=uncollapse;button3=exit'

