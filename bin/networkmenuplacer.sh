#!/bin/sh
#Used to edit config file of nmcli_dmenu to spawn 
#menu where the pointer is located.
eval $(xdotool getmouselocation --shell)
menu_widht=500
monitor_widht=$(wattr w $(lsw -r))
maxx=$(( $monitor_widht - $menu_widht ))
XP=$(( $X - 15 ))
[ $XP -gt $maxx ] && XP=$maxx

oldx=$(awk '/x =/{print $3}' $HOME/.config/networkmanager-dmenu/config.ini)
sed -i '/x =/s/'$oldx'/'$XP'/g' $HOME/.config/networkmanager-dmenu/config.ini
oldy=$(awk '/y =/{print $3}' $HOME/.config/networkmanager-dmenu/config.ini)
sed -i '/y =/s/'$oldy'/'$PANEL_HEIGHT'/g' $HOME/.config/networkmanager-dmenu/config.ini
