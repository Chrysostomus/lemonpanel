#!/bin/bash
#Used to edit config file of nmcli_dmenu to spawn 
#menu where the pointer is located.
eval $(xdotool getmouselocation --shell)
menu_widht=500
monitor_widht=$(xdpyinfo | awk -F'[ x]+' '/dimensions:/{print $3}')
monitor_height=$(xdpyinfo | awk -F'[ x]+' '/dimensions:/{print $4}')
lines=14
menu_height=$(echo "$lines * 23" | bc)
maxx=$(echo "$monitor_widht - $menu_widht" | bc)
miny=$PANEL_HEIGHT
maxy=$(echo "$monitor_height - $menu_height" | bc)
XP=$(echo "$X - 15" | bc)
[[ $XP -gt $maxx ]] && XP=$maxx
YP=$Y
[[ $YP -lt $miny ]] && YP=$miny
[[ $YP -gt $maxy ]] && YP=$maxy

oldx=$(awk '/x/{print $3}' .config/networkmanager-dmenu/config.ini)
sed -i 's/'$oldx'/'$XP'/g' .config/networkmanager-dmenu/config.ini
