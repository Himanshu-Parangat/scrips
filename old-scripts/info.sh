#!/bin/sh

# Dzen2 toolbar/statusbar execution file.
# Options:
# -xs = which Xinerama screen
# -l  = number of lines in slave (dropdown) window
# -u update continually
# -p <n> timed termination; w/o n seconds, persist forever.
# retval: 0 = EOF; 1 = error; or exit:n where n=user-defined retval.
# -e event... -e 'event1=action1:option1:...option<n>,...,action<m>;...;event<l>'
#    event... -e 'button1=exec:xterm:firefox;entertitle=uncollapse,unhide;button3=exit'
# Supported events: (see latest README or online docs)
#    onstart             Perform actions right after startup
#    onexit              Perform actions just before exiting
#    onnewinput          Perform actions if there is new input for the slave window
#    button1             Mouse button1 released
#    button2             Mouse button2 released
#    button3             Mouse button3 released
#    button4             Mouse button4 released (usually scrollwheel)
#    button5             Mouse button5 released (usually scrollwheel)
#    entertitle          Mouse enters the title window
#    leavetitle          Mouse leaves the title window
#    enterslave          Mouse enters the slave window
#    leaveslave          Mouse leaves the slave window
#    sigusr1             SIGUSR1 received
#    sigusr2             SIGUSR2 received
#    key_KEYNAME         Keyboard events (*)


# Before doing anything, kill any running dzen2:
kill_counter=$((0))
while [ "$(ps -C dzen2 | grep dzen2 | awk '{print $1}')" ]; do
  kill -9 $(ps -C dzen2 | grep dzen2 | awk '{print $1}') 2>/dev/null
  kill_counter=$((kill_counter+1)); sleep 1
  if [ $kill_counter -ge 5 ]; then
     echo "dzen2 error: unkillable zombies; cannot start new dzen2." 1>&2 && exit 1
  fi
done

# Pre execution: see if 'stop' was passed as $1 and if so
# don't restart dzen2; just exit instead:
[ "$1" = 'stop' ] && exit 0

# Not exiting; proceed then:

# FUNCTIONS:

get_date () {
# Observe/fix if `date` pads single digits as formatted.
  echo "^fg($TX2)$(date +'%H:%M:%S %a %x')"
}

get_mem () {
  TOTALMEM=$(awk '/^MemTotal: /{print $2}' /proc/meminfo)
   FREEMEM=$(awk '/^MemFree: /{print $2}' /proc/meminfo)
   USEDMEM=$(($TOTALMEM - $FREEMEM))

  UBARS=$(( $(echo "scale = 0; $USEDMEM * 100 / $TOTALMEM" | bc -l) ))
  FBARS=$(( $(echo "scale = 0; $FREEMEM * 100 / $TOTALMEM" | bc -l) ))
  [ $UBARS -ge 95 ] && FG="^fg($RED)" || FG="^fg($GRN)"

echo "^fg($WHT)MEM^p(2;4)${FG}^r(${UBARS}x16)^fg($BAR)^r(${FBARS}x16)"
}

disk_space () {
unset DISKS ALLDISKS
df | {
      while read line; do
       LABEL="$(echo $line | awk '{print $1}'):"
       if [ "$(echo "$LABEL" | grep 'root')" ]; then
          DEVTOTAL=$(echo $line | awk '{print $2}')
          DEVFREE=$(echo $line | awk '{print $4}')
          DEVUSED=$(($DEVTOTAL - $DEVFREE))

          UBARS=$(( $(echo "scale = 0; $DEVUSED * 100 / $DEVTOTAL" | bc -l) ))
          FBARS=$(( $(echo "scale = 0; $DEVFREE * 100 / $DEVTOTAL" | bc -l) ))
          [ $UBARS -ge 95 ] && FG="^fg($RED)" || FG="^fg($GRN)"

          DISKS="^pa(;0)${DISKS}^fg($WHT)${LABEL}^p(2;4)${FG}^r(${UBARS}x16)^fg($BAR)^r(${FBARS}x16)"
          ALLDISKS="${ALLDISKS}${DISKS} "; unset DISKS
       fi
      done
      echo "$ALLDISKS"
     }
}

interfaces () {
unset OUTPUT
for NIC in $NICS; do
   eval RXBN_${NIC}=$(cat /sys/class/net/${NIC}/statistics/rx_bytes); eval TXBN_${NIC}=$(cat /sys/class/net/${NIC}/statistics/tx_bytes)
   eval RXR_${NIC}=$(printf "%4d\n"  $((($(eval echo \$RXBN_${NIC}) - $(eval echo \$RXB_${NIC})) / 1024/$SLEEP)) | bc )
   eval TXR_${NIC}=$(printf "%4d\n"  $((($(eval echo \$TXBN_${NIC}) - $(eval echo \$TXB_${NIC})) / 1024/$SLEEP)) | bc )

   OUTPUT="${OUTPUT}^fg($WHT)${NIC}^fg(${BAR}) "
   OUTPUT="${OUTPUT}$(eval echo \$TXR_${NIC})^fg($GRY)^p(2)UkB/s ^fg($BAR)$(eval echo \$RXR_${NIC})^fg($GRY)^p(2)DkB/s"
   OUTPUT="${OUTPUT} ^fg($BAR)$(/sbin/ip addr show label ${NIC} | awk '/inet /{gsub("/.*","",$0); print $2}') "
done

echo $OUTPUT

for NIC in $NICS; do
   eval RXB_${NIC}=$(eval echo \$RXBN_${NIC})
   eval TXB_${NIC}=$(eval echo \$TXBN_${NIC})
done
}

# END OF FUNCTIONS
# script execution begins here:

# Define colors and spacers etc..:
TX1='#DBDADA'     # medium grey text
TX2='#F9F9F9'     # light grey text
GRY='#909090'     # dark grey text
BAR='#A6F09D'     # green background of bar-graphs
GRN='#65A765'     # light green (normal)
YEL='#FFFFBF'     # light yellow (caution)
RED='#FF0000'     # light red/pink (warning)
WHT='#FFFFFF'     # white
BLK='#000000'     # black
SEP="^p(4)^fg(#555555)^r(4x24)^p(4)"      # item separator block/line
SLEEP=1           # update interval (whole seconds, no decimals!)
CHAR=$((20))      # pixel width of characters of font used
# zero some vars for the CPU load reader:
LASTTOTALCPU0=0; LASTIDLECPU0=0
LASTTOTALCPU1=0; LASTIDLECPU1=0



# endless loop: DZEN on output xinerama-0
while true; do

 sleep $SLEEP

 READCPU0=$(awk '/^cpu0 /{print}' /proc/stat | sed 's/cpu0 //')
 READCPU1=$(awk '/^cpu1 /{print}' /proc/stat | sed 's/cpu1 //')
 IDLECPU0=$(echo $READCPU0 | awk '{print $4}')
 IDLECPU1=$(echo $READCPU1 | awk '{print $4}')
 TOTALCPU0=0; TOTALCPU1=0
 for x in $READCPU0; do TOTALCPU0=$((TOTALCPU0+x)); done
 for x in $READCPU1; do TOTALCPU1=$((TOTALCPU1+x)); done

 NICS="$(/sbin/ip addr show scope global | awk '/^[ ]*inet /{print $(NF)}')" # Interfaces
 for NIC in $NICS; do
   # this just grabs reference points of the NIC traffic prior to the sleep
   # so the traffic/time calculation can be made in the $(interfaces) function above:
   eval RXB_${NIC}=$(cat /sys/class/net/${NIC}/statistics/rx_bytes)
   eval TXB_${NIC}=$(cat /sys/class/net/${NIC}/statistics/tx_bytes)
 done


# echo the string that gets printed on the Dzen2 bar:
# orig line used for non-dock dzen2:
 echo "^ib(1)^pa(0;0)^fg($BAR)^ro(1920x24)^pa(2;0)$(get_date)^pa(;0) $(get_mem)^pa(;0) $(disk_space) $(interfaces)^pa(0;)"

# Remember the total and idle CPU times for the next check.
 LASTTOTALCPU0=$TOTALCPU0; LASTIDLECPU0=$IDLECPU0
 LASTTOTALCPU1=$TOTALCPU1; LASTIDLECPU1=$IDLECPU1

done | dzen2 -fn -bitstream-terminal-bold-r-normal--15-140-100-100-c-110-iso8859-1 -bg black -ta l -h 24 -u -p  &

#---------------------------------------------



get_date () {
# Observe/fix if `date` pads single digits as formatted.
  echo "^fg($TX2)$(date +'%H:%M:%S %a %x')"
}

get_mem () {
  TOTALMEM=$(awk '/^MemTotal: /{print $2}' /proc/meminfo)
   FREEMEM=$(awk '/^MemFree: /{print $2}' /proc/meminfo)
   USEDMEM=$(($TOTALMEM - $FREEMEM))

  UBARS=$(( $(echo "scale = 0; $USEDMEM * 100 / $TOTALMEM" | bc -l) ))
  FBARS=$(( $(echo "scale = 0; $FREEMEM * 100 / $TOTALMEM" | bc -l) ))
  [ $UBARS -ge 95 ] && FG="^fg($RED)" || FG="^fg($GRN)"

echo "^fg($WHT)MEM^p(2;4)${FG}^r(${UBARS}x16)^fg($BAR)^r(${FBARS}x16)"
}

disk_space () {
unset DISKS ALLDISKS
df | {
      while read line; do
       LABEL="$(echo $line | awk '{print $1}'):"
       if [ "$(echo "$LABEL" | grep 'root')" ]; then
          DEVTOTAL=$(echo $line | awk '{print $2}')
          DEVFREE=$(echo $line | awk '{print $4}')
          DEVUSED=$(($DEVTOTAL - $DEVFREE))

          UBARS=$(( $(echo "scale = 0; $DEVUSED * 100 / $DEVTOTAL" | bc -l) ))
          FBARS=$(( $(echo "scale = 0; $DEVFREE * 100 / $DEVTOTAL" | bc -l) ))
          [ $UBARS -ge 95 ] && FG="^fg($RED)" || FG="^fg($GRN)"

          DISKS="^pa(;0)${DISKS}^fg($WHT)${LABEL}^p(2;4)${FG}^r(${UBARS}x16)^fg($BAR)^r(${FBARS}x16)"
          ALLDISKS="${ALLDISKS}${DISKS} "; unset DISKS
       fi
      done
      echo "$ALLDISKS"
     }
}

interfaces () {
unset OUTPUT
for NIC in $NICS; do
   eval RXBN_${NIC}=$(cat /sys/class/net/${NIC}/statistics/rx_bytes); eval TXBN_${NIC}=$(cat /sys/class/net/${NIC}/statistics/tx_bytes)
   eval RXR_${NIC}=$(printf "%4d\n"  $((($(eval echo \$RXBN_${NIC}) - $(eval echo \$RXB_${NIC})) / 1024/$SLEEP)) | bc )
   eval TXR_${NIC}=$(printf "%4d\n"  $((($(eval echo \$TXBN_${NIC}) - $(eval echo \$TXB_${NIC})) / 1024/$SLEEP)) | bc )

   OUTPUT="${OUTPUT}^fg($WHT)${NIC}^fg(${BAR}) "
   OUTPUT="${OUTPUT}$(eval echo \$TXR_${NIC})^fg($GRY)^p(2)UkB/s ^fg($BAR)$(eval echo \$RXR_${NIC})^fg($GRY)^p(2)DkB/s"
   OUTPUT="${OUTPUT} ^fg($BAR)$(/sbin/ip addr show label ${NIC} | awk '/inet /{gsub("/.*","",$0); print $2}') "
done

# echo $OUTPUT

get_date & 
interfaces &  
disk_space &
get_mem &
