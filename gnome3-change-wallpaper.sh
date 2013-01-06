#!/bin/bash

#Initialize the DBUS ENV
#export DBUS_SESSION=$(grep -v "^#" /home/matt/.dbus/session-bus/`cat /var/lib/dbus/machine-id`-0)

sessionfile=`find "${HOME}/.dbus/session-bus/" -type f`
export `grep "DBUS_SESSION_BUS_ADDRESS" "${sessionfile}" | sed '/^#/d'`

i=0
DIR="/home/matt/Pictures/bing-wallpapers"

filelist=()
while read -d $'\0' -r ; do filelist+=("$REPLY"); done < <(find $DIR -type f -iname "*.jpg" -print0)
NUMBER=0   #initialize
i=${#filelist[@]}
if [ $i -ne 0 ]
then
	# Generate random number
	NUMBER=$RANDOM
	let "NUMBER %= $i"  # Scales $number down within 0-$i.
fi


PIC=${filelist[$NUMBER]}
#/usr/bin/gsettings set org.gnome.desktop.background picture-uri "file://$DIR/$PIC"
#echo "Setting PIC to $PIC"
dconf write /org/gnome/desktop/background/picture-uri "'file://$PIC'"
#echo "Image is $DIR/$PIC"
