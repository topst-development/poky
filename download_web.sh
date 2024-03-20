#!/bin/bash

AP_addr="wget --no-check-certificate https://tost-dl.huconn.com/share/AP"
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
	$AP_addr/$tools
	
	tar xzf $tools &> /dev/null
	rm $tools
	echo "done"
fi

if [ "$secure" = "Y" ]; then
	echo  -e "\033[5mStart others downloading...\033[0m"
	$AP_addr/security_tools.tar.gz
	
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
	
	$AP_addr/tcc805x
	echo "done"
fi

if [ "$CMD" = "sstateCache" ]; then
	if [ ! -d $SSTATE_CACHE_REL ]; then
		echo  -e "\033[5mStart sstate cache downloading... Please wait !\033[0m"

		$AP_addr/sstate_mirror/tcc8050_evb/sstate-cache-rel.tar.gz
		
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
		
		$AP_addr/tools/x86_64-buildtools-nativesdk-standalone-3.1.sh
		$AP_addr/tools/x86_64-buildtools-extended-nativesdk-standalone-3.0+snapshot-20200315.sh
		$AP_addr/tools/gcc-linaro-7.2.1-2017.11-x86_64_arm-eabi.tar.xz
		#$AP_addr/tools/osm_bbox_126.8,37.5,127.1,37.6.bin
		#mv osm_bbox_126.8,37.5,127.1,37.6.bin ../poky/meta-telechips/meta-ivi/recipes-applications/telechips-automotive-linux/navit/
		
		chmod 755 *
		popd
		echo "done"
	fi
fi

if [ "$CMD" = "ubuntu" ]; then
       if [ -d "ubuntu-filesystem" ]; then
               echo  -e "\033[5mStart prebuilted ubuntu filesystem downloading... Please wait !\033[0m"
               $AP_addr/ubuntu_rootfs/rootfs.tar.gz -P ubuntu-filesystem
       fi
fi

