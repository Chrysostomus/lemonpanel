#! /bin/bash

# Make sure the following file exists.
FILE='/tmp/conkytoggle'

if ! [ -f "/tmp/conkytoggle" ]; then
	echo 1 > /tmp/conkytoggle
fi

[[ $(< $FILE) -eq 0 ]] && echo -n 1 > $FILE || echo -n 0 > $FILE
