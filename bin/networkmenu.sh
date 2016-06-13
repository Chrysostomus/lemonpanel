#!/bin/bash

. ~/.profile
[[ $TERMINAL == /usr/bin/roxterm ]] && bspc rule -a Roxterm state=pseudo_tiled -o

if systemctl status systemd-networkd.service | grep -q " active"; then
	if which wpa_gui >/dev/null 2>&1 ; then 
		wpa_gui
	else
		smartsplit ; default-terminal --geometry=450x200 -e wpa_tui	
	fi
	 
elif  systemctl status Networkmanager.service | grep -q " active"; then
		if which nmcli_dmenu >/dev/null 2>&1 ; then
			networkmenuplacer.sh ; nmcli_dmenu
		else 
			smartsplit ; default-terminal -e nmtui
		fi
else
	smartsplit ; default-terminal --geometry=450x200 -e wpa_tui
fi
