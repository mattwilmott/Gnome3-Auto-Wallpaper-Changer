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

urls=$(curl -s "http://themeserver.microsoft.com/default.aspx?p=Bing&c=Desktop&m=en-US" | grep -o 'url="[^"]*"' | sed -e 's/url="\([^"]*\)"/\1/' | sed -e "s/ /%20/g")

#read file line
for line in $urls
do
    fileName=$(echo $line | sed -e "s;.*/\([^\/]*\)$;\1;" | sed -e "s/%/_/g")
    if [[ -f $fileName ]]; then
        if [ "$DEBUG" ]; then echo "$fileName already exists"; fi
    else
        curl -s $line -o $fileName;
    fi
done
