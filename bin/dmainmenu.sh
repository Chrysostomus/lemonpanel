#!/bin/bash
#
# rofimenu
#
thisscript="$0"

# Script that runs rofi in several custom rofi modi, emulating menu with submenus.
# Only one option should be used.
# No options starts rofi showing the first modi.
# Option "-show <modi>" starts rofi showing <modi>. The rest of command line is passed to rofi.
# Option "-only <modi>" starts rofi showing only <modi>. The rest of command line is passed to rofi.
# Option "-menu <menu>" calls menu function <menu> and prints menu labels from each line.
# It is used to define custom modi.
# Option "-menu <menu> <label>" calls menu function <menu> and executes command from line with <label>.

ROFIMENU_CONFIG="$HOME/.config/rofimenu/rofimenu.config"	# config file that defines menu structure
ROFIMENU_THEME="$HOME/.config/rofimenu/rofimenu.rasi"		# theme file that defines menu look

# If there is no config file, write default config

if ! [ -f "$ROFIMENU_CONFIG" ] ; then
	mkdir -p "${ROFIMENU_CONFIG%/*}"
	cat > "$ROFIMENU_CONFIG"<<"_EOF_"
#!/bin/bash
# Configuration file for rofimenu script
#
# Top level menu consists of modi names from modilist.
# Modilist is a comma separated list of default modi (drun,run...) and/or custom modi.
# Names of default modi can be set as rofi options (e.g. -display-drun Applications).
# Custom modi format: "modi_name:modi_script".
# Menu functions from this script can be used as modi like this "<menu_name>:$thisscript -menu <menu_function>"

# pause needed for smooth transition when menu command refers to other modi
DELAY=0.07
delay() {
	sleep $DELAY
}

# define modi labels for menu

FAV=" Favourites"
DRUN=" Applications"
CAT=" Categories"
RUN=" Run"
MENU=" Edit Menu"
EXIT=" Exit"

modilist="\
$FAV:$thisscript -menu ${FAV#* },\
drun,\
$CAT:$thisscript -menu ${CAT#* },\
run,\
$MENU:$thisscript -menu Menu_settings,\
$EXIT:$thisscript -menu ${EXIT#* }"

# Menu functions print lines in format "label:command".

Menu_settings() {
	echo " Edit config:$GUI_EDITOR $ROFIMENU_CONFIG && $thisscript -show \'$MENU\'"
	echo " Reset config:rm $ROFIMENU_CONFIG && delay; $thisscript -show \'$MENU\'"
	echo "──────────────:true"
	echo " Edit theme:$GUI_EDITOR $ROFIMENU_THEME && $thisscript -show \'$MENU\'"
	echo " Reset theme:rm $ROFIMENU_THEME && delay; $thisscript -show \'$MENU\'"
}

Favourites() {
	echo " Terminal:default-terminal"
	echo " File Manager:default-terminal -e ranger"
	echo " Browser:default-browser"
	echo " Settings:default-terminal -e bmenu"
	echo " Search:rofi-finder.sh"
	# echo " Exit:delay; $thisscript -show \'$EXIT\'"		# This refers to modi from the same script
}

Exit() {
	echo " lock:screenlock"
	echo " suspend:systemctl suspend"
	echo " hibernate:systemctl hibernate"
	echo " logout:xdotool key --clearmodifiers super+shift+q"
	echo " reboot:systemctl reboot"
	echo " poweroff:systemctl poweroff"
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

	linenumber=0
	for line in $desired ; do
		category="${line##*[ :]}"
		label="${line%:*}"
		if [ $(echo "$present"|grep -w -c "$category") -gt 0 ] ; then
			echo "$label:activate_category \"$label\" $category $linenumber"
			linenumber=$(($linenumber+1))
		fi
	done
}

activate_category() {	# shows drun modi filtered with category. If no command selected, returns to categories modi
	label="$1"
	category="$2"
	linenumber="$3"
	command=$(delay; $thisscript \
				-only drun \
				-drun-match-fields categories,name \
				-display-drun "$label" \
				-filter "$category " \
				-run-command "echo {cmd}")
	if [ -n "$command" ] ; then
		eval "$command" &
		exit
	fi
	# return to categories modi. No delay needed
	$thisscript -show "$CAT" &
	
	if [ $linenumber -eq 0 ] ; then	# if the category is on the top line
		exit
	fi

	# move rofi selection down by linenumber
	keys=""
	while [ $linenumber -gt 0 ] ; do
		keys="$keys Tab"
		linenumber=$(($linenumber-1))
	done	
	##TODO wait until rofi can take input
	delay
	delay
	xdotool search --class rofi key --delay 0 $keys
}

### Under construction
# Desktop menu parameters

DT_MODI="Desktop:$thisscript -menu Desktop"

Desktop() {
	echo "Desktop menu:true"
	echo " Terminal:default-terminal"
	echo " File Manager:default-terminal -e ranger"
	echo " Browser:default-browser"
	echo " Applications:$thisscript -only drun"
	Categories
	echo " Settings:default-terminal -e bmenu"
	echo " Search:rofi-finder.sh"
}

DT_THEME="
#window {
	width: 20ch;
} 
#mainbox {
	children: [ vertibox ];
}"

## rofi theme file can be set here 

# ROFIMENU_THEME="$HOME/.config/rofimenu/rofimenu.rasi"

_EOF_
fi

# read config file
. "$ROFIMENU_CONFIG"

# if there is no theme file, write default theme file

if ! [ -f "$ROFIMENU_THEME" ] ; then
	mkdir -p "${ROFIMENU_THEME%/*}"
	cat > "$ROFIMENU_THEME"<<"_EOF_"
configuration {
	me-select-entry:	"MouseSecondary";
	me-accept-entry:	"MousePrimary";
	scroll-method:      1;
    show-icons:         true;
    sidebar-mode:		true;
    kb-custom-1:        "";
    kb-custom-2:        "";
    kb-custom-3:        "";
    kb-custom-4:        "";
    kb-custom-5:        "";
    kb-custom-6:        "";
    kb-custom-7:        "";
    kb-custom-8:        "";
    kb-custom-9:        "";
    kb-custom-10:       "";
    kb-select-1:        "Alt+1";
    kb-select-2:        "Alt+2";
    kb-select-3:        "Alt+3";
    kb-select-4:        "Alt+4";
    kb-select-5:        "Alt+5";
    kb-select-6:        "Alt+6";
    kb-select-7:        "Alt+7";
    kb-select-8:        "Alt+8";
    kb-select-9:        "Alt+9";
    kb-select-10:       "Alt+0";
}

* {
//	colors match bspwm edition theme

	background:                  #292f34FF;
	background-color:            #292f3400;
	foreground:                  #F6F9FFFF;
	selected:                    #1ABB9BFF;
	selected-foreground:         @foreground;

//	colors match Adapta Nokto theme

//	background:                  #222D32E8;
//	background-color:            #00000000;
//	foreground:                  #CFD8DCFF;
//	selected:                    #00BCD4FF;
//	selected-foreground:         #FFFFFFFF;

    active-background:           #3A464BFF;
    urgent-background:           #800000FF;
    urgent-foreground:           @foreground;
    selected-urgent-background:  @urgent-foreground;
    selected-urgent-foreground:  @urgent-background;

//    font:                        "xos4 Terminus 18px";
    font:                        "Knack Nerd Font 16px";
    text-color:                  @foreground;

	margin:                      0px;
	border:                      0px;
	padding:                     0px;
	spacing:                     0px;
	elementpadding:	2px 0px;
	elementmargin:	0px 2px;
	listmargin:		0px 2px 0px 0px;

////uncomment following to get submenu-like style
//	menustyle:		[ sb-mainbox ];
//	buttonpadding:	2px 1ch;
//	button-bg:		@background;

////uncomment following to get tabs-like style	
	menustyle:		[ tb-mainbox ];
	buttonpadding:	14px 1ch;
}
window {
	location:		northwest;
	anchor:			northwest;
	x-offset:		0px;
	y-offset:		24px;
	width:			45ch;
	children:		@menustyle;
}
sb-mainbox {
	orientation:	horizontal;
	children:		[ sidebar,vertibox ];
}
tb-mainbox {
	orientation:	vertical;
	children:		[ inputbar, horibox ];
	background-color:	@background;
}
horibox {
	orientation:	horizontal;
	children:		[ listview, sidebar ];
}
sidebar {
	orientation:	vertical;
}
button {
	horizontal-align:	0;
	expand:			false;
	padding:		@buttonpadding;
	width:			18ch;
	background-color:	@button-bg;
}
vertibox {
	orientation:	vertical;
	children:		[ inputbar, listview ];
	background-color:	@background;
}
inputbar {
	children:		[ entry, ci ];
}
listview {
	lines:			12;
	fixed-height:	false;
	dynamic:		false;
	scrollbar:		true;
	margin:			@listmargin;
}
element, inputbar {
	padding:		@elementpadding;
	margin:			@elementmargin;
}
element.normal.active,
element.alternate.active {
    background-color: @active-background;
    text-color:       @selected-foreground;
}
element.selected,
button.selected {
    background-color: @selected;
    text-color:       @selected-foreground;
}
element.normal.urgent,
element.alternate.urgent {
    background-color: @urgent-background;
    text-color:       @urgent-foreground;
}
element.selected.urgent {
    background-color: @selected-urgent-background;
    text-color:       @selected-urgent-foreground;
}
scrollbar {
	width:			1ch;
	handle-color:	@selected;
}
_EOF_
fi

###############################
##  MAIN SCRIPT STARTS HERE  ##
###############################

if [ $# -gt 0 ] ; then
	option="$1"
	shift
else
	option="-no"
fi

case "$option" in
	"-no"|"-show"|"-only"|"-desktop")

	case "$option" in
		"-no")
			showmodi="${modilist%%,*}"	# first modi from list
			showmodi="${showmodi%%:*}"	# modi name if modi is custom
			;;
		"-show")
			showmodi="$1"
			shift
			;;
		"-only")			## show only this modi
			modilist=$(echo $modilist|grep -o "${1}[^,]*")
			showmodi="$1"
			shift
			;;
		"-desktop")			## show desktop menu
			modilist="$DT_MODI"
			showmodi="${DT_MODI%%:*}"	# desktop modi name
			eval $(xdotool getmouselocation --shell) 
			rofitheme="$DT_THEME
				#window {
					x-offset: $X;
					y-offset: $Y;
				}"
			;;
	esac

	##TODO determine element length and modi lenght

	## wait until rofi exits
	while pgrep -x rofi >/dev/null 2>&1 ; do
		delay;
	done

			# the rest of command line is passed to rofi
	rofi	"$@" \
			-modi "$modilist" \
			-show "$showmodi" \
			-config "$ROFIMENU_THEME" \
			-display-run "$RUN" \
			-display-drun "$DRUN" \
			-theme-str "$rofitheme" &
	exit
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
				  exit
				;;
			*)	# "-menu <menu> <label>" calls <menu> function and executes command from line with <label>
				$1 \
				| while read line; do
					if [ "$2" = "${line%%:*}" ] ; then
						command="${line#*:}"
						eval "$command" &
						exit
					fi
				  done >/dev/null 2>&1
		esac
		;;

	################
	# unknown option
	*)	exit 1
esac
