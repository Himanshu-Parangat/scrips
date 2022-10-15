#! /bin/bash

sleep 2
xrandr --output eDP-1 --auto --same-as HDMI-1 --mode 1920x1080 
xrandr --output HDMI-1 --mode 1920x1080 
echo "display mode is set to mirror"
nitrogen --restore

