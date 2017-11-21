#!/bin/bash

. ~/.profile

if systemctl status systemd-networkd.service | grep -q " active"; then
	if which wpa_gui >/dev/null 2>&1 ; then 
		wpa_gui
	else
		[[ $TERMINAL == /usr/bin/roxterm ]] && bspc rule -a Roxterm state=pseudo_tiled -o
		smartsplit ; default-terminal --geometry=400x200 -e wpa_tui	
	fi
	 
elif  systemctl status NetworkManager.service | grep -q " active"; then
		if which nmcli_dmenu >/dev/null 2>&1 ; then
			networkmenuplacer.sh ; nmcli_dmenu
		elif which networkmanager_dmenu >/dev/null 2>&1 ; then
			networkmenuplacer.sh ; networkmanager_dmenu
		else 
			smartsplit ; default-terminal -e nmtui
		fi
else
	[[ $TERMINAL == /usr/bin/roxterm ]] && bspc rule -a Roxterm state=pseudo_tiled -o
	smartsplit ; default-terminal --geometry=400x200 -e wpa_tui
fi
