SCALEOUTPUT=$(echo -e "Normal 1 
Lower 0.9
Lower 0.8
Lower 0.7
Lower 0.6
Lower 0.5
Higher 1.5
Higher 2
Higher 2.5
Higher 3
" | rofi -dmenu -p Scale -i 7 -a X -theme-str '#listview {columns:2; }')

Scale= echo $SCALEOUTPUT |sed -e 's/[a-zA-Z]/ /g'  | tr -d " \t\n\r" 

notify-send "output set to $SCALEOUTPUT" "$Scale"

 

xrandr --output  $(xrandr |grep connected\ primary  | awk '{ print $1 }') \
--scale $( echo $SCALEOUTPUT |sed -e 's/[a-zA-Z]/ /g'  | tr -d " \t\n\r") 

nitrogen --restore
