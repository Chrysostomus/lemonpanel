#!/bin/bash
#Used to edit config file of nmcli_dmenu to spawn 
#menu where the pointer is located.
eval $(xdotool getmouselocation --shell)
menu_widht=500
monitor_widht=$(wattr w $(lsw -r))
maxx=$(echo "$monitor_widht - $menu_widht" | bc)
XP=$(echo "$X - 15" | bc)
[[ $XP -gt $maxx ]] && XP=$maxx

oldx=$(awk '/x =/{print $3}' $HOME/.config/networkmanager-dmenu/config.ini)
sed -i '/x =/s/'$oldx'/'$XP'/g' $HOME/.config/networkmanager-dmenu/config.ini
echo $XP
oldy=$(awk '/y =/{print $3}' $HOME/.config/networkmanager-dmenu/config.ini)
sed -i '/y =/s/'$oldy'/'$PANEL_HEIGHT'/g' $HOME/.config/networkmanager-dmenu/config.ini
