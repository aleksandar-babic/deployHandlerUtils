#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
    echo "Usage: ./stopApp.sh appName"
    exit
fi

#CONFIG
appName=$1

res=$(ps aux | grep -e "$appName" | grep -v grep | awk '{print $2}' | wc -w )
if [ $res -eq 3 ]; then
	pm2 stop $appName
	if [ $? -eq 0 ]; then
		echo "App '$appName' stopped."
		exit 0
	fi	
fi

echo "App $appName already stopped."
exit 1	
