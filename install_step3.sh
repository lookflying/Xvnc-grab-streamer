#!/bin/bash
component_name=""
function change_component(){
	component_name=$1
}
function check_command(){
#usage $0 command info [good value]
	good_value=0
	command_info=$1
	if [ $# -ge 2 ]
	then
		command_info=$2
	fi
	if [ $# -eq 3 ]
	then
		good_value=$3	
	fi
	$1 >& /dev/null
	result=$?
	if [ $result -ne $good_value ]
	then
		$1 >& /dev/null #retry only once
		result=$?
		if [ $result -ne $good_value ]
		then
			echo "$command_info fail"
			exit $result
		fi 
	fi
	echo "$command_info succeed"
}

function check_last_command(){
	result=$?
	good_value=0
	command_info=`history|tail -2|head -1`
	if [ $# -ge 1 ]
	then
		command_info=$1
	fi
	if [ $# -ge 2 ]
	then
		good_value=$2
	fi
	if [ $result -ne $good_value ]
	then
		echo "line $command_info fail ($component_name)"
		exit $result
	fi
	echo "line $command_info pass ($component_name)"
}

echo "this script will install the media cloud"


change_component "msdk"
if [ -e msdk ]
then
	rm -rf msdk
fi
mkdir msdk
tar xzf intel-linux-media_ubuntu_16.3.14000_64bit.tar.gz -C msdk
check_last_command $LINENO
cd msdk
echo n |./install_media.sh
check_last_command $LINENO
cd ..

tar xzf X11.tar.gz
check_last_command $LINENO
if [ ! -e /usr/X11R6/lib ]
then
	mkdir -p /usr/X11R6/lib
	check_last_command $LINENO
fi
cp -r X11 /usr/X11R6/lib/
check_last_command $LINENO
rm -rf X11
check_last_command $LINENO

rm -rf ~/MC
check_last_command $LINENO
mkdir ~/MC
check_last_command $LINENO
cp index.zip ~/MC/
check_last_command $LINENO
#tar xzf wasu_mediacloud_l*.tar.gz 
#check_last_command $LINENO
#mv wasu_mediacloud_l ~/MC/MediaCloud
#check_last_command $LINENO
sysctl -w net.core.wmem_max=1048576
sysctl -w net.core.rmem_max=1048576
check_last_command $LINENO

if [ -e "~/MC/MediaCloud" ]
then
	rm -rf "~/MC/MediaCloud"
fi
mkdir ~/MC/MediaCloud
check_last_command $LINENO
cp -a rtp msdk_encode ffmpeg-0.8.12-mpegtsencchanged.tar.gz vnc_unixsrc_msdk.tar.gz ~/MC/MediaCloud
check_last_command $LINENO

cp all_in_one_run.sh vnc_auto.sh bash_run_x.sh stop.sh new_bash_run.sh mediaclouddemo.sh rundemo.sh refresh.sh ~/MC/MediaCloud
check_last_command $LINENO

cd ~/MC/
unzip index.zip >& /dev/null
check_last_command $LINENO

cd ~/MC/MediaCloud/

change_component "ffmpeg-0.8.12-mpegtsencchanged"
tar xzf ffmpeg-0.8.12-mpegtsencchanged.tar.gz
check_last_command $LINENO
cd ffmpeg-0.8.12-mpegtsencchanged/
check_command "./configure --enable-debug" "configure of $component_name" 
check_command "make -j9" "make $component_name" 0
check_command "make install" "install $component_name" 0
cd ..

#change_component "lib4mediacloud"
#tar xzf lib4mediacloud.tar.gz 
#check_last_command $LINENO
#cp /usr/lib/libva* /usr/local/lib
#cd libencoder/
#check_command "make clean" "make clean $component_name" 0
#check_command "make -j9" "make $component_name" 0
#cp libvaenc.so /usr/lib/
#check_last_command $LINENO
#cd ..



change_componet "msdk_encode"
cd msdk_encode
make -j9
check_last_command $LINENO
make install
check_last_command $LINENO
cd ..

change_component "rtp/jthread-1.3.1"
cd rtp/jthread-1.3.1/
rm CMakeCache.txt
rm -rf build
mkdir build
check_last_command $LINENO
cd build
check_command "cmake .." "cmake $component_name" 0
check_command "make -j9" "make $component_name" 0
check_command "make install" "install $component_name" 0

change_component "jrtplib-3.9.1"
cd ../..
cd jrtplib-3.9.1/
rm CMakeCache.txt
rm -rf build
mkdir build
check_last_command $LINENO
cd build
check_command "cmake .." "cmake $component_name" 0
check_command "make -j9" "make $component_name" 0
check_command "make install" "install $component_name" 0
cd ../..

change_component "rtpheader"
cp -r ./rtpheader/. .
check_last_command $LINENO
cp -r ./jrtplib-3.9.1/src/*.h .
check_last_command $LINENO
check_command "make -j9" "make $component_name" 0
cp librtpsend.so /usr/lib
check_last_command $LINENO
cd ..

change_component "Xvnc"
tar xzf vnc_unixsrc_msdk.tar.gz
check_last_command $LINENO

cd vnc_unixsrc_grab-ffmpegused/Xvnc/

cp -r /usr/include/x86_64-linux-gnu/. /usr/include/
check_last_command $LINENO
#cp -r /opt/intel/ipp/include/. /usr/include/
cp -r /opt/intel/ipp/6.1.6.063/em64t/include/. /usr/include/
check_last_command $LINENO
cp /usr/lib/gcc/x86_64-linux-gnu/4.?/include/stdarg.h /usr/lib/gcc/x86_64-linux-gnu/4.?/include/stddef.h /usr/include/
check_last_command $LINENO
cp programs/Xserver/Makefile ../..
check_command "./configure" "configure $component_name" 0
cp ../../Makefile programs/Xserver/
check_last_command $LINENO
check_command "make -j9" "make $component_name" 0
check_command "make install" "install $component_name" 0
cd ../..
echo "All Installation finished"








