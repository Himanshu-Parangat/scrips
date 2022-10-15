#!/bin/bash
#
rfkill unblock all &
nmcli radio wifi on &

sleep 2 &
notify-send --app-name=system-ui --icon=/usr/share/themes/themes/icons/rose-pine-moon-icons/64x64/apps/distributor-logo-archlinux.svg "Reject trigger" "    Airplane-mode aulterd \n    rfkill: unblock all"
