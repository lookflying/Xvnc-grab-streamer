#!/bin/bash
displays=`ps aux|grep Xvnc|awk '{print $14}'`
for disp in $displays
do
	DISPLAY=$disp  xdotool search --onlyvisible --class google-chrome key ctrl+r
done
