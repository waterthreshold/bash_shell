#!/bin/sh
SERVER_IP=192.168.1.100:8088/
if [ "${1}" == "install" ]; then
	if [ ! -f /tmp/${2} ];then
		wget ${SERVER_IP}${2} -O /tmp/${2}
		WGET_ISOK=$?
		if [ "${WGET_ISOK}" -eq  "0" ];then
			echo ${2} Download OK
			chmod u+x  /tmp/${2}

		fi
	fi 
fi
