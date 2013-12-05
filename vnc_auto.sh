#!/bin/bash
function vnc_daemon(){
	if [ $# -ne 3 ]
	then 
		echo "usage $0 address id interval"
		exit 1
	else
		while [ 1 ]
		do
			gvncviewer $1:$2 
			sleep $3
		done
	fi
	
}
if [ $# -ne 3 ]
then
	echo "usage: $0 address first_id last_id"
	exit 1
else
	for (( i=$2; i<=$3; i++))
	do
		vnc_daemon $1 $i 10 &
	done
fi
