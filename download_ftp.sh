#!/bin/bash

FTP_addr="192.168.9.48"
FTP_user="tostuser"
FTP_pass="tostuser!"
TOOLS_DIR="tools"
DL_SOURCE_MIRROR_DIR="source-mirror"
SSTATE_CACHE_REL="build/sstate-cache-rel"

response=""
tools=""
CMD=$1

#echo "This may take a long time depending on your network environment."
#echo -n "Continue? (Y/n) => "
#read sel
#echo "sel=$sel"

echo "$0 $CMD"

if [ "$sel" = "Y" ]; then
	tools="tools-v4.x.tar.gz"
	echo -n "Do you want to download external tools(Security), too? (Y/n) => "
	read secure
fi

if [ -n "$tools" ]; then
	echo  -e "\033[5mStart tools downloading...\033[0m"
	ncftp -u $FTP_user -p $FTP_pass $FTP_addr &> /dev/null << End-Of-Session
	bin
	get /share/$tools
	bye
End-Of-Session
	tar xzf $tools &> /dev/null
	rm $tools
	echo "done"
fi

if [ "$secure" = "Y" ]; then
	echo  -e "\033[5mStart others downloading...\033[0m"
	ncftp -u $FTP_user -p $FTP_pass $FTP_addr &> /dev/null << End-Of-Session
	bin
	get /share/security_tools.tar.gz
	bye
End-Of-Session
	tar xzf security_tools.tar.gz
	rm security_tools.tar.gz
	echo "done"
fi

if [ "$CMD" = "sourceMirror" ]; then
	if [ ! -d $DL_SOURCE_MIRROR_DIR ]; then
		mkdir -p $DL_SOURCE_MIRROR_DIR
	fi

	echo  -e "\033[5mStart source mirror downloading... Please wait !\033[0m"
	cd $DL_SOURCE_MIRROR_DIR
	ncftp -u $FTP_user -p $FTP_pass $FTP_addr &> /dev/null << End-Of-Session
	bin
	cd /share/tcc805x
	get -R -T *
	bye
End-Of-Session
	echo "done"
fi

if [ "$CMD" = "sstateCache" ]; then
	if [ ! -d $SSTATE_CACHE_REL ]; then
		echo  -e "\033[5mStart sstate cache downloading... Please wait !\033[0m"

		ncftp -u $FTP_user -p $FTP_pass $FTP_addr &> /dev/null << End-Of-Session
		bin
		get share/sstate_mirror/tcc8050_evb/sstate-cache-rel.tar.gz
		bye
End-Of-Session
		if [ ! -d "./build" ]; then
			mkdir -p build
		fi
			
		tar zxvf sstate-cache-rel.tar.gz -C build/
		rm sstate-cache-rel.tar.gz
		echo "done"
	fi
fi

if [ "$CMD" = "buildTools" ]; then
	if [ ! -d $TOOLS_DIR ]; then
		echo -e "\033[5mStart buildtools downloading... Please wait !\033[0m"
		mkdir -p $TOOLS_DIR
		pushd ./$TOOLS_DIR
		
		echo $PWD  
		echo $TOOLS_DIR
		echo "ncftp -u $FTP_user -p $FTP_pass $FTP_addr"
		ncftp -u $FTP_user -p $FTP_pass $FTP_addr &> /dev/null << End-Of-Session
		bin
		cd share/tools/
		get -R -T x86_64-buildtools-*.sh
		get -R -T gcc-linaro-7.2.1-2017.11-x86_64_arm-eabi.tar.xz
		bye
End-Of-Session
		chmod 755 *
		popd
		echo "done"
	fi
fi