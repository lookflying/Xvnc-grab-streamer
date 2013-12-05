#!/bin/sh
#export IPPROOT=/opt/intel/ipp/6.1.6.063/em64t
#export INCLUDE=$IPPROOT/include:$INCLUDE
#export LD_LIBRARY_PATH=$IPPROOT/sharedlib:$LD_LIBRARY_PATH
#export LIB=$IPPROOT/lib:$LIB
#export CPATH=$IPPROOT/include:$CPATH
#export LIBRARY_PATH=$IPPROOT/lib:$LIBRARY_PATH
#export NLSPATH=$IPPROOT/lib/locale/%l_%t/%N:$NLSPATH

XVNC=~/MC/MediaCloud/vnc_unixsrc_grab-ffmpegused/Xvnc/programs/Xserver/Xvnc
RESOLU=1280x720
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/intel/mediasdk/bin/x64:/usr/local/lib
if [ $# != 1 ]
then
	echo "One param input is needed."
else
	echo "Display : " $1 "IP :" $IPADDR
fi

if [ $# = 2 ]
	then
#		Xvnc -depth 24 :$1 -geometry $RESOLU -rtpaddr $2 &
		$XVNC -depth 24 :$1 -geometry $RESOLU -rtpaddr $2 &
	else
#		Xvnc -depth 24 :$1 -geometry $RESOLU &
	 	$XVNC -depth 24 :$1 -geometry $RESOLU &
fi
#google-chrome --display=:$1 --no-first-run --window-size=1280,720 --user-data-dir=/tmp/chrome$1 ~/MC/index/index.html
#google-chrome --display=:$1 --no-first-run --window-size=1280,720 --user-data-dir=/tmp/chrome$1 ~/3D/movie.html
google-chrome --display=:$1 --no-first-run --window-size=1280,720 --user-data-dir=/tmp/chrome$1 /home/lookflying/3D/movie.html &
sleep 3
DISPLAY=:$1 xdotool search --onlyvisible --class google-chrome key ctrl+r 
