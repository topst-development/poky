#!/bin/bash

FTP_addr="rf.telechips.com"
FTP_user="customer"
FTP_pass="telecustomer12!"
DL_SOURCE_MIRROR_DIR="source-mirror"

tools=""

echo "This may take a long time depending on your network environment."
echo -n "Continue? (Y/n) => "
read sel
if [ "$sel" = "Y" ]; then
	tools="tools-kirkstone.tar.gz"
fi

if [ -n "$tools" ]; then
	echo -n "Start tools downloading..."
	ncftp -u $FTP_user -p $FTP_pass $FTP_addr &> /dev/null << End-Of-Session
	bin
	get /share/$tools
	bye
End-Of-Session
	tar xzf $tools &> /dev/null
	rm $tools
	echo "done"
fi
if [ "$sel" = "Y" ]; then
	if [ ! -d $DL_SOURCE_MIRROR_DIR ]; then
		echo "Create $DL_SOURCE_MIRROR_DIR directory"
		mkdir -p $DL_SOURCE_MIRROR_DIR
	fi

	echo -n "Start source mirror downloading..."
	cd $DL_SOURCE_MIRROR_DIR
	ncftp -u $FTP_user -p $FTP_pass $FTP_addr &> /dev/null << End-Of-Session
	bin
	cd /share/kirkstone
	get -R -T *
	bye
End-Of-Session
	echo "done"
fi
