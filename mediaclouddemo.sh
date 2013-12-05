
#!/bin/sh
IPADDR=127.0.0.1
#IPADDR=lookflying-desktop
#IPADDR=192.168.1.2
#IPADDR=10.42.0.44
IPADDR=10.239.43.39
PORT=` expr 6900 + $1 `
INPORT=` expr 7900 + $1 `
#FFMPEG=~/MC/MediaCloud/ffmpeg-0.8.12-mpegtsencchanged/ffmpeg
FFMPEG=ffmpeg
if [ $# != 1 ]
then
	echo "One param input is needed."
else
	echo "ffmpeg running for display :  " $1 
fi


echo $PORT 

rm -rf /tmp/vfifo$1.264
mkfifo -m 777 /tmp/vfifo$1.264

$FFMPEG -re -fflags +genpts -f h264 -i /tmp/vfifo$1.264 -vcodec copy -f mpegts udp://$IPADDR:$PORT
#$FFMPEG -i /tmp/vfifo$1.264 -vcodec copy -f rtp rtp://$IPADDR:$PORT
#rm -rf /home/lookflying/out$1.ts
#$FFMPEG -f h264 -fflags +genpts -i /tmp/vfifo$1.264 -vcodec copy -f mpegts /home/lookflying/out$1.ts -y
#gst-launch-1.0 filesrc location=/tmp/vfifo$1.264  ! h264parse ! rtph264pay ! udpsink host=$IPADDR port=$PORT -v

#$FFMPEG -fflags +genpts -i /tmp/vfifo$1.264 -vcodec copy -f mpegts udp://$IPADDR:$PORT
