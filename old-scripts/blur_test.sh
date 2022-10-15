#!/bin/bash


# get window class name
GETCLASSSTRING=$(xprop WM_CLASS | sed -e 's/WM_CLASS(STRING)//g' | sed -e "s/=//g" | sed -e 's/"//g' | sed -e 's/,//g' )

#rofi prompt for class choose
CLASSNAME=$((echo $GETCLASSSTRING | tr ' ' '\n' | sort  )  | rofi -dmenu -p Blur -i 7 -a X -theme-str '#listview {columns:2; }') 


# various BLUROPTION 
BLUROPTION=$(echo 'Default Ignore 25%_transparent 35%_transparent 50%_transparent 80%_transparent')


# rofi  prompt for BLUROPTION 
BLURCHOOICE=$((echo $BLUROPTION) | tr ' ' '\n' | sed -e 's/_/ /g'  | rofi -dmenu -p Blur -i 7 -a X -theme-str '#listview {columns:2; }') 

BLURCHOOICE=$(echo $BLURCHOOICE | sed -e 's/transparent//g ' | sed -e 's/%//g' | sed -e 's/ //g' )

# action based on BLURCHOOICE input
case $BLURCHOOICE in
  Default)
    notify-send "picom" "$CLASSNAME blur altered"
    NEWCLASS = $(echo $CLASSNAME | sed -e 's/...$//g') 
    ;;
  Ignore)
    notify-send "picom" "$CLASSNAME blur altered"
    NEWCLASS = $(echo $CLASSNAME | sed -e 's/$CLASSNAME/$CLASSNAME-no/g') 
    ;;
  25) 
    notify-send "picom" "$CLASSNAME set to $BLURCHOOICE% transperancy"
    NEWCLASS = $(echo $CLASSNAME | sed -e 's/$CLASSNAME/$CLASSNAME-25') 
    ;;
  35) 
    notify-send "picom" "$CLASSNAME set to $BLURCHOOICE% transperancy" 
    NEWCLASS = $(echo $CLASSNAME | sed -e 's/$CLASSNAME/$CLASSNAME-35') 
    ;;
  50) 
    notify-send "picom" "$CLASSNAME set to $BLURCHOOICE% transperancy" 
    NEWCLASS = $(echo $CLASSNAME | sed -e 's/$CLASSNAME/$CLASSNAME-50') 
    ;; 
  80) 
    notify-send "picom"  "$CLASSNAME set to $BLURCHOOICE% transperancy" 
    NEWCLASS = $(echo $CLASSNAME | sed -e 's/$CLASSNAME/$CLASSNAME-80') 
    ;; 
esac

killall picom
picom 

