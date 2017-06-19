#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
    echo "Usage: ./stopApp.sh appName"
    exit
fi

#CONFIG
appName=$1

res=$(su - appsrunner -c "pm2 list" | grep $appName | awk '{print $8}')
re='^[0-9]+$'
if [[ $res =~ $re ]] && [[ $res -ne 0 ]] ; then
	su - appsrunner -c "pm2 stop $appName"
	if [ $? -eq 0 ]; then
		echo "App '$appName' stopped."
		exit 0
	fi	
fi

echo "App $appName already stopped."
exit 1	
