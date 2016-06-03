#!/bin/dash

if systemctl status systemd-networkd.service | grep -q " active"; then
	if which wpa_gui >/dev/null 2>&1 ; then 
		wpa_gui
	else
		smartsplit ; default-terminal -e wpa_tui	
	fi
	 
else 
	if systemctl status Networkmanager.service | grep -q " active"; then
		if which nmcli_dmenu >/dev/null 2>&1 ; then
			networkmenuplacer.sh ; nmcli_dmenu
		else 
			smartsplit ; default-terminal -e nmtui
		fi
	fi
fi
