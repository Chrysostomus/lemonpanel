#!/bin/bash
#Used to edit config file of nmcli_dmenu to spawn 
#menu where the pointer is located.
eval $(xdotool getmouselocation --shell)
monitor_widht=$(xdpyinfo | awk -F'[ x]+' '/dimensions:/{print $3}')
maxx=$(echo "$monitor_widht - $menu_widht" | bc)
XP=$(echo "$X - 15" | bc)
[[ $XP -gt $maxx ]] && XP=$maxx

oldx=$(awk '/x/{print $3}' .config/networkmanager-dmenu/config.ini)
sed -i 's/'$oldx'/'$XP'/g' .config/networkmanager-dmenu/config.ini
oldy=$(awk '/y/{print $3}' .config/networkmanager-dmenu/config.ini)
sed -i 's/'$oldy'/'$PANEL_HEIGHT'/g' .config/networkmanager-dmenu/config.ini
