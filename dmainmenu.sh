#!/bin/bash

#       Custom dmenu-bind.sh
#
#       Copyright 2009, Gatti Paolo (lordkrandel at gmail dot com)
#       Distributed as public domain. 
#       Modified for lemonbar.

if [ "$1" == "" ]; then
    title="Main"
    menu=( \
#               labels            commands
#           Main =========================================
		Run		  "dmouse"
		Terminal          "terminal"
		Files		  "pcmanfm"
		Find		  "finder"
                Web               "$0 web"
                System            "$0 system"
                Tools             "$0 tools"
                Settings          "$0 settings"
    )
else
    case $1 in
    web)
        title="web"
        menu=( \
#           Web ==========================================
                Chromium           "chromium" \
                Wifi-Men	   "nmcli_dmenu" \
                Networkmanager     "terminal -e nmtui" \
         )
    ;;
    tools)
        title="tools"
        menu=( \
#           Tools ========================================
                Geany             "geany" \
                Geanysudo         "gksudo geany" \
         )
    ;;
    system)
        title="system"
        menu=( \
#           System =======================================
                Files            "pcmanfm" \
                PackageManager   "terminal -e yaourt-gui" \
         )
    ;;
    settings)
        title="settings"
        menu=( \
#           Settings =====================================
                Volume            	 "$0 volume" \
                Brightness		 "dbright" \
                Wallpaper	         "nitrogen" \
                Menusettings             "geany $0" \
                Bspwmrc                  "geany .config/bspwm/bspwmrc" \
                Keybindings	         "geany .config/sxhkd/sxhkdrc" \
                Logind		         "terminal -e sudo nano /etc/systemd/logind.conf"
                Appearance	         "lxappearance" \
                Postinstall	         "terminal -e postinstall" \
                Autostart	         "geany .config/bspwm/autostart" \
                Xresources	         "geany .Xresources"
                Zshrc		         "geany .zshrc"
                Bashrc		         "geany .bashrc"
                ToggleCompositing	 "xdotool key ctrl+super+space"
                Autologin		 "terminal -e sudo systemctl enable xlogin@$(whoami)"
				
         )
    ;;
    volume)
        title="Volume"
        menu=( \
#           Volume controls ==============================
		mute		  "volume mute"
                0%                "volume set 0" \
                30%               "volume set 30"
                50%               "volume set 50" \
                70%               "volume set 70" \
                100%              "volume set 100" \
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

select=`echo -e $menu_labels | dmenu -p $title -fn $DMENU_FN -nb $DMENU_NB -nf $DMENU_NF -sf $DMENU_SF -sb $DMENU_SB -l 10 -y $PANEL_HEIGHT -w 400`

if [ "$select" != "" ]; then

#   fetch and clean the index of the selected label
    index=`echo -e "${menu_labels[*]}" | grep -xnm1 $select | sed 's/:.*//'`
    
#   get the command which has the same index
    part=`echo -e ${menu_commands[*]} | head -$index`
    exe=`echo -e "$part" | tail -1`

#   execute
    $exe &
fi
