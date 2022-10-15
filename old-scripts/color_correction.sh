colour_correction=$(echo -e "Normal       1:1:1              
light grass  0.85:1:1
cleanGrean   0.5:0.6:0.5
rose pink    1:0.85:1
rosePink     0.9:0.7:0.7
lukeYellow   0.7:0.6:0.5        
Straw        1:1:0.9
blues        0.7:0.7:1
warmBlue     0.7:0.6:0.8        
White        255:255:255        
Black        0.001:0.001:0.001  
Cyan         0.1:1:1            
Yellow       1:1:0.01           
Megenta      1:0.01:1           
red          1:0.1:0.1          
green        0.1:1:0.1          
purple       1:0.6:0.8          

" | rofi -dmenu -p Correction -i 7 -a X -theme-str '#listview {columns:2; }') 

colour_set= echo $colour_correction |sed -e 's/[a-zA-Z]/ /g'  | tr -d " \t\n\r" 

notify-send "color profile set to $colour_correction"

DISPLAY= $(xrandr |grep connected\ primary  | awk '{ print $1 }')

xrandr --output $(xrandr |grep connected\ primary  | awk '{ print $1 }')  \
--gamma $( echo $colour_correction |sed -e 's/[a-zA-Z]/ /g'  | tr -d " \t\n\r") 

