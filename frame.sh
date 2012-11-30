#!/bin/bash
FullList=/tmp/list
ShowList=/tmp/show
Photos=/home/Photos/
Home=/home/frame/
cd $Home


rm -f $FullList ShowList

pkill X 
export DISPLAY=:0
sleep 1

x='X :0'

$x & 			# Starting X server in bg
LPID=0
while true; do


	y=$( /usr/bin/tvservice -s | fgrep -c 'progressive') # Test if screen is off
	echo $y
	if [ "$y" == 1 ]; then 
		find -L "$Photos" -type f | grep -i ".j" > $FullList
		N=$( cat $FullList | wc -l )
		Start=$( echo "(" $RANDOM+$(date +%H*%D+%m+%S)")"%$N | bc ) # Need a better rondom
		echo $( date ) -- $Start >> $Home/number.log

		S=$( cat $ShowList | wc -l )
		cat /tmp/list | tail -n $Start | head -n 500  > $ShowList # Creating a short list of 500 images
		while read jpg; do


			# Creating html list. you might want to install lighttp. very basic list, no tables and stuff
			head -n 150 /var/www/index.html > /tmp/index.tmp
			link=$( echo $jpg | sed -e 's/home//' )
			url="<p> <a href=\".$link\">$( date ) -- $jpg </a> </p>" 
			echo $url > /var/www/index.html
			cat /tmp/index.tmp >> /var/www/index.html

			# creating sym link for the current image display, easy to show from the phone.
			rm /var/www/current.jpg
			ln -s $jpg /var/www/current.jpg

			echo "$( date ) - $jpg " >> /home/frame/frame.log
	
			if Text=$( cat $Home/text.msg ); # Do you need to print some stuff? you can send messages via ssh or crontab
			then
				nice -n 20 convert -size 2400x1600 -pointsize 180 -font /usr/share/fonts/truetype/culmus/DavidCLM-Bold.ttf -fill grey -stroke black -strokewidth 6 -draw "text 0,180 \"$Text" "$jpg" /tmp/message.jpg
			jpg="/tmp/message.jpg"
			fi

		
			Show="feh -Y -F --auto-zoom"
			$Show "$jpg" &
			PID=$!
		
			xset s reset
			sleep 2
			if [ "$LPID" != "0" ]; then
				kill -9 $LPID  
			fi		
			sleep 60	# 60 seconds between images
			LPID=$PID



		echo $PID $jpg
		done < $ShowList
		
		killall -9 feh
		killall -9 X
		rm %Home/text.msg
		$x &
 
	else
		killall -9 feh
		echo "Sleeping"
		sleep 60
	fi

done

exit 0

