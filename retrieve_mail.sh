#!/bin/sh
TIMECRON1=${TIMECRON:-300}

while :
do
	getmail --getmaildir=/etc/mail2print --rcfile=getmail.conf
	sh /bin/printmail.sh
	sleep $TIMECRON1
done
