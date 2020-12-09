#!/bin/sh
COMMAND=${0}
ACTION=${1} 
PORTNAME=${2}
STATUS=${3}
die ()
{
	echo "COMMAND(\$1) ACTION(\$2) not be Null"
	echo "Action   [list|up|down|mirror|read|LED|blink]"
	echo -e "\tet up [WAN|LAN1-4]: up port"
	echo -e "\tet down [WAN|LAN1-4]: down port "
	echo -e "\tet mirror [Enable|disable]: mirror port wan to lan1"
	echo -e "\tet read []: list wan Lan1-4  port STATUS"
	echo -e "\tet LED [OFF|Disable|enable]: port blink control (TBD...) no obvious action"
	echo -e "\tet blink [WAN|LAN1-4][open|close] : control the port mapping LED blinking"
	exit 
}


portup_func ()
{
	STATUS=$2
	if [ "${STATUS}" == "UP" ]; then 
		STATUS=0x1140
	elif [ "$STATUS" == "DOWN" ]; then
		STATUS=0x1940
	else 
		die
	fi
	

	PORT=0x10
	OFFESET=0x0
	case "$1" in
		WAN)
			OFFESET=0x0
			PORT=$(printf "0x%x"  $(( $PORT + $OFFESET)) )
			;;
		LAN1)
			OFFESET=0x01
			PORT=$(printf "0x%x"  $(( $PORT + $OFFESET)) )
		;;
		LAN2)
			OFFESET=0x02
			PORT=$(printf "0x%x"  $(( $PORT + $OFFESET)) )

		;;
		LAN3)
			OFFESET=0x03
			PORT=$(printf "0x%x"  $(( $PORT + $OFFESET)) )
		;;
		LAN4)
			OFFESET=0x04
			PORT=$(printf "0x%x"  $(( $PORT + $OFFESET)) )
			
		;;
		*) echo Must WAN LAN1~4 || die
	esac 
	echo "et robowr $PORT 0x0 ${STATUS}"
	et robowr $PORT 0x0 ${STATUS}
}

mirror_func() 
{
	STATUS=$1
	if [ "$STATUS" == "ENABLE" ]; then
		et robowr 0x02 0x10 0x8001
		et robowr 0x02 0x12 0x101
		et robowr 0x02 0x1C 0x101
	elif  [ "$STATUS" == "DISABLE" ]; then  
		et robowr 0x02 0x10 0x0
		et robowr 0x02 0x12 0x0
		et robowr 0x02 0x1C 0x0
	else 
		die
	fi
	
	echo WAN to LAN1 MIRROR $STATUS
}


read_func ()
{
	PORTSTAT=`et robord 1 0`
	WAN_STAT=$( printf "%x" $(( $PORTSTAT & 1 )) )
	LAN1_STAT=`printf "%x" $(( $PORTSTAT & 2 ))`
	LAN2_STAT=$( printf "%x" $(( $PORTSTAT & 4 )) )
	LAN3_STAT=$( printf "%x" $(( $PORTSTAT & 8 )) )
	LAN4_STAT=$( printf "%x" $(( $PORTSTAT & 16 )) )
	

	test "$WAN_STAT" -eq "0" && echo "WAN is Down" || echo "WAN is UP"
	test "$LAN1_STAT" -eq "0" && echo "LAN1 is Down" || echo "LAN1 is UP"
	test "$LAN2_STAT" -eq "0" && echo "LAN2 is Down" || echo "LAN2 is UP"
	test "$LAN3_STAT" -eq "0" && echo "LAN3 is Down" || echo "LAN3 is UP"
	test "$LAN4_STAT" -eq "0" && echo "LAN4 is Down" || echo "LAN4 is UP"
}

LED_func ()
{
	#PORT_NUM=$1
	COMMAND=$1

	if [ "$COMMAND" == "OFF" ];then 
		et robowr 0x0 0x18 0x0;
		et robowr 0x0 0x1a 0x0
		echo LED off OK!!
		return 
	elif [ "$COMMAND" == "DISABLE" ];then 
		et robowr 0x0 0x18 0x1ff
		et robowr 0x0 0x1a 0x1ff
		et robowr 0x0 0x10 0x0301
		et robowr 0x0 0x12 0x022
		echo LED Disable OK!!
		return 
	elif [ "$COMMAND" == "ENABLE" ];then 
		et robowr 0x0 0x18 0x1ff
		et robowr 0x0 0x1a 0x1ff
		et robowr 0x0 0x10 0x0300
		et robowr 0x0 0x12 0x078
		echo LED Enable OK!!
	else 
		die
	fi

}



blink_func ()
{
	PORT_NUM=$1
	COMMAND=$2
	PORT=`et robord 0  0x1a`

	if [ "$COMMAND" == "OPEN" ]; then 
		case "$PORT_NUM" in 
		WAN)
			OFFESET=1
			PORT=$(printf "0x%x"  $(( $PORT & ~$OFFESET)) )
			;;
		LAN1)
			OFFESET=2
			PORT=$(printf "0x%x"  $(( $PORT &  ~$OFFESET)) )
		;;
		LAN2)
			OFFESET=4
			PORT=$(printf "0x%x"  $(( $PORT & ~$OFFESET)) )
		;;
		LAN3)
			OFFESET=8
			PORT=$(printf "0x%x"  $(( $PORT & ~$OFFESET)) )
		;;
		LAN4)
			OFFESET=16
			PORT=$(printf "0x%x"  $(( $PORT & ~$OFFESET)) )
			;;
		*)
		echo inteface error && die 
		esac
		
	elif [ "$COMMAND" == "CLOSE" ]; then
		case "$PORT_NUM" in 
		WAN)
			OFFESET=1
			PORT=$(printf "0x%x"  $(( $PORT | $OFFESET)) )
			;;
		LAN1)
			OFFESET=2
			PORT=$(printf "0x%x"  $(( $PORT | $OFFESET)) )
		;;
		LAN2)
			OFFESET=4
			PORT=$(printf "0x%x"  $(( $PORT | $OFFESET)) )

		;;
		LAN3)
			OFFESET=8
			PORT=$(printf "0x%x"  $(( $PORT | $OFFESET)) )
		;;
		LAN4)
			OFFESET=16
			PORT=$(printf "0x%x"  $(( $PORT | $OFFESET)) )
			;;
		*) 
		echo inteface error && die 
		esac
		
		
	fi
	et robowr 0  0x1a $PORT
	echo "et robowr 0  0x1a $PORT"
	echo $COMMAND $PORT_NUM LED Blink!!
}



test  -z "${COMMAND}" -o -z "${ACTION}"  && die  

ACTION=$(echo -n ${ACTION} | tr a-z A-Z)
PORTNAME=$(echo -n ${PORTNAME} | tr a-z A-Z)
STATUS=$(echo -n $STATUS | tr a-z A-Z)

echo $ACTION $PORTNAME
if [ "$ACTION" == "UP" -o "$ACTION" == "DOWN" ];
then
	portup_func  $PORTNAME $ACTION
	echo "$PORTNAME $ACTION"
elif [ "$ACTION" == "MIRROR" ]; then
	STATUS=$PORTNAME
	PORTNAME=LAN1
	mirror_func  $STATUS
elif [ "$ACTION" == "READ" ]; then 
	read_func
elif [ "$ACTION" == "LED" ];then 
	LED_func   $STATUS
elif [ "$ACTION" == "BLINK" ]; then
	blink_func $PORTNAME    $STATUS
elif [ "$ACTION" == "LIST" ]; then
	die
else 
	die 
fi