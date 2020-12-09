#!/bin/sh

START_TIME=`date +"%s"`
END_TIME=`date +"%s"`
INTERVAL=`expr $END_TIME - $START_TIME`
while [ "$INTERVAL" -lt "5"  ];
do
gpio 5 0
END_TIME=`date +"%s"`
INTERVAL=`expr $END_TIME - $START_TIME`
done
