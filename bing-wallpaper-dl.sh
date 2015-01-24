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
 'http://www.bing.com/HPImageArchive.aspx?format=xml&idx=16&n=8&mkt=en-US'
 'http://www.bing.com/HPImageArchive.aspx?format=xml&idx=8&n=8&mkt=en-US'
 'http://www.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=8&mkt=en-US')


for url in ${bingUrls[@]}
do
	if [[ "$DEBUG" ]]; then echo "Fetching Bing Url $url"; echo; fi
	temp=$(curl -s "$url" | xmlstarlet sel -t -m 'images/image/urlBase' -v '.' -n 2> /dev/null)
  if [[ "$?" -ne 0 ]]
  then
      continue
  fi
	for i in $temp; do 
		if [[ "$DEBUG" ]]; then echo "Current image url: $i"; fi
		urls+=($i); 
	done
	if [[ "$DEBUG" ]]; then echo "urls now contains ${#urls[@]} elements"; fi
	if [[ "$DEBUG" ]]; then echo "Finished fetching $url"; fi
done
if [[ "$DEBUG" ]]; then echo "Fetched XML docs, retrieving images"; fi
#read file line
for line in ${urls[@]}
do
	if [[ "$DEBUG" ]]; then echo "Current url:$line"; fi
	# Convert hprichbg?p=rb%2fArafuneCoast_JA-JP1084689430 to ArafuneCoast.jpg for instance
	fileName="$(echo $line | cut -f2 -d'%' | cut -f1 -d'_' | sed 's/2f//' | cut -f5 -d'/' )_1920x1200.jpg"
	if [[ "$DEBUG" ]]; then echo "filename determined as $fileName"; fi
	if [[ -f $fileName ]]; then
	    if [ "$DEBUG" ]; then echo "$fileName already exists"; fi
	else
	    if [[ "$DEBUG" ]]; then echo "Fetching image, "$line"_1920x1200.jpg"; fi
		curl -s "http://www.bing.com/"$line"_1920x1200.jpg" -o "$fileName";
		grep -q -i 'html' $fileName && rm -f $fileName 
	fi
done
if [[ "$DEBUG" ]]; then echo "Finished"; fi
