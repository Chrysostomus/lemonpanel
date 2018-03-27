#!/bin/bash
#
# rofimenu
#
# Script that runs rofi in several custom rofi modi, emulating menu with submenus.
# Only one option should be used.
# No options or option "-show" starts rofi showing the first modi.
# Option "-show <modi>" starts rofi showing this <modi>. The rest of command line is passed to rofi.
# Option "-menu <menu>" calls menu function <menu> and prints menu labels from each line.
# It is used to define custom modi.
# Option "-menu <menu> <label>" calls menu function <menu> and executes command from line with <label>.

# Top level menu consists of modi names from modilist.
# Modilist is a comma separated list of default modi (drun,run...) and/or custom modi.
# Names of default modi can be set as rofi options (e.g. -display-drun Applications).
# Custom modi format: "modi_name:modi_script".
# Menu functions from this script can be used as modi like this "<menu_name>:$thisscript -menu <menu_function>"

thisscript="$0"

# define modi labels for menu

FAV=" Favourites"
DRUN=" Applications"
CAT=" Categories"
RUN=" Run"
EXIT=" Exit"

modilist="\
$FAV:$thisscript -menu ${FAV#* },\
drun,\
$CAT:$thisscript -menu ${CAT#* },\
run,\
$EXIT:$thisscript -menu ${EXIT#* }"

# Menu functions print lines in format "label:command".

Favourites() {
	echo " Edit this menu:$GUI_EDITOR $thisscript"
	echo " Terminal:default-terminal"
	echo " File Manager:default-terminal -e ranger"
	echo " Browser:default-browser"
	echo " Settings:default-terminal -e bmenu"
	echo " Search:rofi-finder.sh"
	echo " Exit:$thisscript -show \'$EXIT\'"		# This refers to modi from the same script
}

Categories() {
	IFS='
'
	# Newline separated list, each line has format "[symbol ][alias:]category"
	# Category with alias will be shown in menu under that alias
	desired="\
	 Favorites
	 Accessories:Utility
	 Development
	 Documentation
	 Education
	 Graphics
	 Internet:Network
	 Multimedia:AudioVideo
	 Office
	 Settings
	 System"

	present="$(grep Categories /usr/share/applications/*.desktop \
		| cut -d'=' -f2 \
		| sed 's/;/\n/g' \
		| LC_COLLATE=POSIX sort --ignore-case --unique)"

	for line in $desired ; do
		category="${line##*[ :]}"
		label="${line%:*}"
		if [ $(echo "$present"|grep -w -c "$category") -gt 0 ] ; then
			echo "$label:activate_category $category"
		fi
	done
}

activate_category() {	# shows drun modi filtered with category. If no command selected, returns to categories modi
	category=$1
	command=$($thisscript \
		-show drun \
		-drun-match-fields categories,name \
		-filter "$category " \
		-run-command "echo {cmd}")
	if [ -n "$command" ] ; then
		eval "$command" &
		exit
	fi
	$thisscript\
		-show "$CAT"
	#TODO set selection to that category (if possible with rofi not in dmenu mode)
}

Exit() {
	echo " lock:screenlock"
	echo " suspend:systemctl suspend"
	echo " hibernate:systemctl hibernate"
	echo " logout:xdotool key --clearmodifiers super+shift+q"
	echo " reboot:systemctl reboot"
	echo " poweroff:systemctl poweroff"
}

###############################
##  MAIN SCRIPT STARTS HERE  ##
###############################

if [ $# -gt 0 ] ; then
	option="$1"
	shift
else
	option="-show"
fi

case "$option" in

	##############################
	# no options or option "-show"
	"-show")
		# pause needed when calling the script from itself
		# so that rofi has time to close and reopen
		sleep 0.01; 
		if [ $# -gt 0 ] ; then
			showmodi="$1"
			shift
		else
			showmodi="${modilist%%,*}"	# first modi from list
			showmodi="${showmodi%%:*}"	# modi name if modi is custom
		fi

		#TODO determine element length and modi lenght
		
		rofi	-modi "$modilist" \
				-show "$showmodi" \
				-config "~/.config/rofi/rofimenu.rasi" \
				-display-drun "$DRUN" \
				-display-run "$RUN" \
				"$@"			# the rest of command line is passed to rofi
				;;

	###################################
	# option "-menu" 
	"-menu")
		case $# in
			0)	exit 1	# must have menu function name
				;;
			1)	# "-menu <menu>" and no more parameters calls <menu> function and prints labels from each line
				$1 \
				| while read line; do
					echo "${line%%:*}"
				  done
				;;
			*)	# "-menu <menu> <label>" calls <menu> function and executes command from line with <label>
				$1 \
				| while read line; do
					if [ "$2" = "${line%%:*}" ] ; then
						command="${line#*:}"
						eval "$command" >/dev/null 2>&1 &
						exit
					fi
				  done
		esac
		;;

	################
	# unknown option
	*)	exit 1
esac
