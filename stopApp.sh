#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
    echo "Usage: ./stopApp.sh appName"
    exit
fi

#CONFIG
appName=$1

pm2 stop $appName
if [ "$?" -eq "0" ]; then
		echo "App '$appName' stopped."
		exit 0
else
	exit $?		
fi	