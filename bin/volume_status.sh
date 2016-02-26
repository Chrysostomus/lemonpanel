#!/bin/dash
panel_volicon()
{
        volStatus=$(pulseaudio-ctl full-status | awk '{print $2}')
        volLevel=$(pulseaudio-ctl C)

        if [ "$volStatus" = "yes" ]
                then echo " ${volLevel}"
        elif [ "$volStatus" = "no" ]
                then echo " ${volLevel}"
		else echo " ?"
        fi
}

panel_avolicon()
{
        avolStatus=$(avol state)
        avolLevel=$(avol level)

        if [ "$avolStatus" = "off" ]
                then echo " ${avolLevel}"
        elif [ "$avolStatus" = "on" ]
                then echo " ${avolLevel}"
		else echo " ?"
        fi
}

if [ $(pgrep pulseaudio >/dev/null) ]; then
		echo "V"%{A:dvol:}%{A2:volume mute:}%{A5:volume down 1:}%{A4:volume up 1:}$(panel_volicon)%{A}%{A}%{A}%{A}> "/tmp/panel-fifo1" 
	else
		echo "V"%{A:dvol:}%{A2:volume mute:}%{A5:volume down 1:}%{A4:volume up 1:}$(panel_avolicon)%{A}%{A}%{A}%{A}> "/tmp/panel-fifo1"
fi
