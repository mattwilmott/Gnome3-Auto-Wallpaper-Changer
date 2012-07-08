#!/bin/bash

#Initialize the DBUS ENV
#export DBUS_SESSION=$(grep -v "^#" /home/matt/.dbus/session-bus/`cat /var/lib/dbus/machine-id`-0)

sessionfile=`find "${HOME}/.dbus/session-bus/" -type f`
export `grep "DBUS_SESSION_BUS_ADDRESS" "${sessionfile}" | sed '/^#/d'`


i=0

DIR="/home/matt/Pictures/bing-wallpapers"
TMP="tmp_$RANDOM.txt"

ls $DIR | grep -i jpg > $TMP

while read LINE 
do
	IMAGE[$i]=$LINE
	#echo "Current image ${IMAGE[$i]}"
	i=`expr $i + 1`
done < $TMP
#echo "Num of Pictures: $i"

NUMBER=0   #initialize
if [ $i -ne 0 ]
then
	# Generate random number
	NUMBER=$RANDOM
	let "NUMBER %= $i"  # Scales $number down within 0-$i.
fi


PIC=${IMAGE[$NUMBER]}
#/usr/bin/gsettings set org.gnome.desktop.background picture-uri "file://$DIR/$PIC"
#echo "Setting PIC to $PIC"
dconf write /org/gnome/desktop/background/picture-uri "'file://$DIR/$PIC'"
#echo "Image is $DIR/$PIC"
rm -f $TMP
