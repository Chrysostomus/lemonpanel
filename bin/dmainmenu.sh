#!/bin/bash

#       Custom dmenu-bind.sh
#
#       Copyright 2009, Gatti Paolo (lordkrandel at gmail dot com)
#       Distributed as public domain. 
#       Modified for lemonbar.

if ! [ -f "$HOME/.dmenurc" ]; then
        cp /usr/share/dmenu/dmenurc $HOME/.dmenurc
fi
. $HOME/.dmenurc

if [ "$1" == "" ]; then
    title="Main"
    menu=( \
#               labels            commands
#           Main =========================================
		Run		  "dmouse"
		Terminal          "terminal"
		Files		  "spacefm"
		Browser           "$BROWSER" \
		Find		  "finder"
                Web               "$0 web"
                System            "$0 system"
                Tools             "$0 tools"
                Settings          "$0 settings"
		Keybindings	  "terminal -name 'floaterm' -geometry 81x65 -e keybindings.sh"
                Manual		  "terminal -e postinstall"
    )
else
    case $1 in
    web)
        title="web"
        menu=( \
#           Web ==========================================
		ReturnToMain       "$0" \
                Browser            "$BROWSER" \
                Wifi-Menu	   "nmcli_dmenu" \
                Networkmanager     "terminal -e nmtui" \
                Firewall           "zensu gufw" \
         )
    ;;
    tools)
        title="tools"
        menu=( \
#           Tools ========================================
		ReturnToMain      "$0" \
                Editor            "$GUI_EDITOR" \
                RootEditor        "zensu $GUI_EDITOR" \
                Gnome-disks	  "gnome-disks" \
         )
    ;;
    system)
        title="system"
        menu=( \
#           System =======================================
		ReturnToMain     "$0" \
                Files            "spacefm" \
                PackageManager   "terminal -e pacli" \
                Mhwd-tui	 "terminal -e mhwd-tui" \
#                SystemUpdates    "terminal -e allservers" \
#                DowngradePackage "terminal -e downgrade $(sudo pacman -Qq | dmenu $DMENU_OPTIONS -p "Select package to downgrade")" \
                Gnome-disks	 "gnome-disks" \
         )
    ;;
    settings)
        title="settings"
        menu=( \
#           Settings =====================================
		ReturnToMain             "$0" \
#                Volume            	 "$0 volume" \
                Brightness		 "dbright" \
                Wallpaper	         "wallpaper" \
                Menusettings             "zensu xdg-open $0" \
                Bspwmrc                  "xdg-open .config/bspwm/bspwmrc" \
                Keybindings	         "xdg-open .config/sxhkd/sxhkdrc" \
                Dmenurc			 "xdg-open .dmenurc" \
                Logind		         "terminal -e sudo nano /etc/systemd/logind.conf" \
                Appearance	         "lxappearance" \
                Postinstall	         "terminal -e postinstall" \
                Autostart	         "xdg-open .config/bspwm/autostart" \
                Xresources	         "xdg-open .Xresources" \
                Zshrc		         "xdg-open .zshrc" \
                Bashrc		         "xdg-open .bashrc" \
                ToggleCompositing	 "xdotool key ctrl+super+space" \
				
         )
    ;;
    volume)
        title="Volume"
        menu=( \
#           Volume controls ==============================
		ReturnToMain      "$0" \
		mute		  "volume mute" \
                0%                "volume set 0" \
                30%               "volume set 30" \
                50%               "volume set 50" \
                70%               "volume set 70" \
                100%              "volume set 100" \
                Pavucontrol       "pavucontrol" \
         )
    ;;
    
    esac
fi

for (( count = 0 ; count < ${#menu[*]}; count++ )); do

#   build two arrays, one for labels, the other for commands
    temp=${menu[$count]}
    if (( $count < ${#menu[*]}-2 )); then
        temp+="\n"
    fi
    if (( "$count" % 2 == "0" )); then
        menu_labels+=$temp
    else
        menu_commands+=$temp
    fi

done

select=`echo -e $menu_labels | dmenu -p $title -fn $DMENU_FN -nb $DMENU_NB -nf $DMENU_NF -sf $DMENU_SF -sb $DMENU_SB -l 20 -y $PANEL_HEIGHT -w 400`

if [ "$select" != "" ]; then

#   fetch and clean the index of the selected label
    index=`echo -e "${menu_labels[*]}" | grep -xnm1 $select | sed 's/:.*//'`
    
#   get the command which has the same index
    part=`echo -e ${menu_commands[*]} | head -$index`
    exe=`echo -e "$part" | tail -1`

#   execute
    $exe &
fi
