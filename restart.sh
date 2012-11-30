#!/bin/bash
killall -9 frame.sh 
killall -9 X
killall feh

rm /home/frame/nohup.out
rm /home/frame/text.msg
nohup /home/frame/frame.sh &
exit 0
