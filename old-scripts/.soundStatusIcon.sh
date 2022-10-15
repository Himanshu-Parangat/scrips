#show current volume 

amixer sget Master | grep -e 'Front Left:' |     sed 's/[^\[]*\[\([0-9]\{1,3\}%\).*\(on\|off\).*/\2 \1/' | sed 's/off/婢 /' | sed 's/on / /'
