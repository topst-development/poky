#!/bin/bash

FTP_addr="192.168.9.48"
FTP_user="tostuser"
FTP_pass="tostuser!"
DL_SSTATE_MIRROR_DIR="sstate-mirror"
ALS_VERSIONS="als_v3.0.4"

echo "Choose ALS version"
num=1
for ver in $ALS_VERSIONS; do
	echo "  $num. $ver"
	versions[$num]=$ver
	num=$(($num + 1))
done
total=$num
num=$(($num - 1))
echo -n "select number(1-$num) => "
read sel

if [ -z $sel ]; then
	echo "ALS version not selected. Cancel downloading"
	exit 0
else
	if [ $sel != "0" -a $sel -lt "$total" ];then
		ver=${versions[$sel]}
	else
		echo "You must to select from '1' to '$num'. Cancel downloading"
		exit 0
	fi
fi

if [ ! -d $DL_SSTATE_MIRROR_DIR ]; then
	echo "Create $DL_SSTATE_MIRROR_DIR directory"
	mkdir -p $DL_SSTATE_MIRROR_DIR
fi

echo -n "Start sstate mirror downloading..."
cd $DL_SSTATE_MIRROR_DIR
ncftp -u $FTP_user -p $FTP_pass $FTP_addr &> /dev/null << End-Of-Session
bin
cd /share/sstate_mirror/$ver
get -R -T *
bye
End-Of-Session
cd - &> /dev/null
echo "done"
