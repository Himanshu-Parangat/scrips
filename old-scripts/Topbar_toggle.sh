#!/bin/sh
# This shell script is PUBLIC DOMAIN. You may do whatever you want with it.
# touch /home/common/user-bash/toggle/.touchpad

TOGGLE=/home/common/user-bash/toggle/.topbar
TOPSTATUSSCRIPT=/home/common/user-bash/TopStatus.sh

topbar(){

    xsetroot -name "                                                " &
    # border bg #4a4b55
    (dzen2 -u -p -bg "#7e82a0" -fg "#1A0A33" -w '2' -h '35' -x '1704') & 
    # border
    (dzen2 -u -p -bg "#7e82a0" -fg "#1A0A33" -w '2' -h '35' -x '1741') & 
    # border
    (dzen2 -u -p -bg "#7e82a0" -fg "#1A0A33" -w '2' -h '35' -x '1843') & 
    # time
    (( while true; do
         TIME=$(date +"%I:%M:%S%p") 
         echo "$TIME "; 
         sleep 1 ;
    done ) | dzen2 -u -p -bg "#e8beff" -fg "#1A0A33" -w '100' -h '35' -x '1743') &

    # date
    (( while true; do
         DATE=$(date +" %^b,%d")
         echo "$DATE "; 
         sleep 1 ;
    done ) | dzen2 -u -p -bg "#e8beff" -fg "#1A0A33" -w '72' -h '35' -x '1845' ) & 


    # drop-down-menu 
    (( while true; do
            echo "*"; 
	    sleep 1 ;
    done ) | dzen2 -u -p -bg "#e8beff" -fg "#1A0A33" -w '35' -h '35' -x '1706' \
     -e 'entertitle=exec:bash /home/common/user-bash/sysinfo_popup.sh;button3=exit' ) & exit 
    
}

killScript(){
    killall dzen2 & 
    xsetroot -name " " & exit
}


if [ ! -e $TOGGLE ]; then
    touch $TOGGLE &
    topbar    
else
    rm -fr $TOGGLE &
    killScript
    set -e
fi


