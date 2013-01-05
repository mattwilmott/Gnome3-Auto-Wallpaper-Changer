#!/usr/bin/env bash
while :
do
	#Process args
	case "$1" in 
	-d | --debug)
		DEBUG=debug #on
		shift
		;;
	--dir)
		DIR=$2
		echo "Directory set to $DIR"
		shift 2
		;;
	--) # End of all options
		shift
		break
		;;
	-*)
		echo "Error: unknown option: $1" >&2
		exit 1
		;;
	*) #No more options
		break
		;;
	esac		
done

if [[ -z $DIR ]]
then
	if [ "$DEBUG" ]; then echo "Setting default directory..."; fi
	DIR="$HOME/Pictures/bing-wallpapers"
fi

mkdir -p $DIR
cd $DIR


# Search through the following URLs for images
bingUrls=(
 'http://www.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=8&mkt=en-au'
 'http://www.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=8&mkt=en-gb'
 'http://www.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=8&mkt=en-jp' )

 #http://themeserver.microsoft.com/default.aspx?p=Bing&c=Desktop&m=en-US #appears broken

for url in ${bingUrls[@]}
do
	echo "Fetching Bing Url $url"
	echo
	temp=$(curl -s "$url" | xmlstarlet sel -t -m 'images/image/url' -v . -n)
	for i in $temp; do echo "Current image url: $i"; urls+=($i); done
	echo "urls now contains ${#urls[@]} elements"
	echo "Finished fetching $url"
done
if [[ "$DEBUG" ]]; then echo "Fetched XML docs, retrieving images"; fi
#read file line
for line in ${urls[@]}
do
	if [[ "$DEBUG" ]]; then echo "Current url:$line"; fi
	# Convert hprichbg?p=rb%2fArafuneCoast_JA-JP1084689430.jpg to ArafuneCoast.jpg for instance
	fileName="$(echo $line | cut -f2 -d'%' | cut -f1 -d'_' | sed 's/2f//').jpg"
	if [[ "$DEBUG" ]]; then echo "filename determined as $fileName"; fi
	if [[ -f $fileName ]]; then
	    if [ "$DEBUG" ]; then echo "$fileName already exists"; fi
	else
	    if [[ "$DEBUG" ]]; then echo "Fetching image, $line"; fi
	    curl -s http://www.bing.com/$line -o "$fileName";
	fi
done
echo "Finished"
