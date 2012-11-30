#!/bin/bash
/home/frame/screen_off.sh
/usr/bin/tvservice -p
sleep 5
/home/frame/start.sh &
