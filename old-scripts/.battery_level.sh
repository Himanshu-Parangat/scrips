#!/bin/bash

function battery_update {
        battery_level="$(cat /sys/class/power_supply/BAT1/capacity)"
        # 0-10   , 11-30   , 31-50   , 51-75   , 76-100 
        # Discharging     Charging     Full  
        #switch battery icon depending on battery level
        if ((battery_level >= 0 && battery_level <= 10)); then
                battery_string=""
        elif ((battery_level >= 11 && battery_level <= 30)); then
                battery_string=""
        elif ((battery_level >= 31 && battery_level <= 50)); then
                battery_string=""
        elif ((battery_level >= 51 && battery_level <= 75)); then
                battery_string=""
        else
                battery_string=""
        fi

        b_state="$(cat /sys/class/power_supply/BAT1/status)"
        if [ "$b_state" = "Charging" ]; then
                battery_status=""
        elif [ "$b_state" = "Unknown" ]; then
                battery_status=""
        elif [ "$b_state" = "Full" ]; then
                battery_status="ﮤ"
        elif [ "$b_state" = "Discharging" ]; then
                battery_status=""
        fi

        battery_show="${battery_status}${battery_level}%${battery_string}"
        echo -e "$battery_show"
        
}

battery_update
