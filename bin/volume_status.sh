#!/bin/sh
panel_volicon()
{
        volStatus=$(pulseaudio-ctl full-status | awk '{print $2}')
        volLevel=$(pulseaudio-ctl C)

        if [ "$volStatus" = "yes" ]
                then echo $GREEN " ${volLevel}"
        elif [ "$volStatus" = "no" ]
                then echo $RED " ${volLevel}"
	else echo " ?"
        fi
}
echo "V"%{A:dvol:}%{A2:volume mute:}%{A5:volume down 1:}%{A4:volume up 1:}$(panel_volicon)%{A}%{A}%{A}%{A}> "/tmp/panel-fifo1"
