#!/bin/sh
GPIO_WHITE_ON="Y"
while [ true ];
do
	if [ "$GPIO_WHITE_ON" == "Y" ];
	then
		gpio 1 0 #POWER WHITE LED enable
		gpio 2 1 #POWER AMBER LED disable
		gpio 6 1 #Wan amber disable
		gpio 7 0 #	Wan WHITE LED Enable
		gpio 8 0 # 5G LED temporaily
		gpio 9 0 # 2g LED tmporaily
		#gpio 8 1 # 5G LED
		#gpio 9 1 # 2g LED
		#gpio 4 0 #power AMBER Enable
		gpio 10 1 # WPS Button enable
		gpio 11 1 # wifi Button enable
		gpio 12 0 # GUEST WHITE LED Enable
		gpio 13 0 # USB WHITE LED Enable
		GPIO_WHITE_ON="N"
	else 
		gpio 1 1
		gpio 2 0
		gpio 6 0 #Wan amber enable 
		gpio 7 1 #	Wan WHITE LED Enable
		gpio 8 1 # 5G LED temporaily
		gpio 9 1 # 2g LED tmporaily
		gpio 10 0 # WPS Button disable
		gpio 11 0 #wifi Button disable
		gpio 12 1 # GUEST WHITE LED disable
		gpio 13 1 # USB WHITE LED disable
		GPIO_WHITE_ON="Y"
	fi
	
	#gpio 5 #reset button n.o. value 0x20  n.c 0x0
	RESET_STAT=$(gpio 5)
	RESET_STAT=$(echo -n ${RESET_STAT##*:} | sed -e 's/ //')
	if [ "${RESET_STAT}" == "0" ];
	then
		echo "RESET Button is pressed"
	fi
	#gpio 3 #WPS button n.o. value 0x08  n.c 0x0
	WPSBTN_STAT=$(gpio 3)
	WPSBTN_STAT=$(echo -n ${WPSBTN_STAT##*:} | sed -e 's/ //')
	#echo ${#WIFIBTN_STAT2}
	if [ "${WPSBTN_STAT}" == "0" ];
	then
		echo "WPS Button is pressed"
	fi
	#gpio 4 #WIFIBUTTON　n.o. value 0x10  n.c 0x0
	WIFIBTN_STAT=$(gpio 4)
	WIFIBTN_STAT2=${WIFIBTN_STAT##*:}
	WIFIBTN_STAT3=$(echo $WIFIBTN_STAT2 | tr -d ' ' | tr -d '\n')
	#echo ${#WIFIBTN_STAT2}
	if [ "${WIFIBTN_STAT3}" == "0" ];
	then
		echo "Wifi Button is pressed"
	fi
	sleep 1
done