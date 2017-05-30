#!/usr/bin/env bash

#This script will try to launch app with PM2 process manager.
#If entry point is provided it will try to launch app with it
#If there is no entry point provided, it will try to do npm start
#If npm start fails, it will try to launch server.js file


if [[ "$#" -ne 2 ]] && [[ "$#" -ne 3 ]] && [[ "$#" -ne 4 ]]; then
    echo "Usage: ./startApp.sh username appName [entryPoint] [npm command]"
    exit
fi

#CONFIG
user=$1
appName=$2
entryPoint=$3
npm=$4

res=$(ps aux | grep -e "$appName" | grep -v grep | awk '{print $2}' | wc -w )
if [ $res -eq 2 ]; then
	#Try to start with entry point provided
	if [ "$#" -eq 3 ]; then
		pm2 start --name "$appName" /home/$user/$appName/$entryPoint
		if [ "$?" -eq "0" ]; then
			echo "Started by entry point"
			exit $?
		fi
	fi

	#Try to start using npm command
	if [ "$#" -eq 4 ]; then
		cd /home/$user/$appName
		pm2 start --name "$appName" "/usr/bin/npm" -- $npm
		if [ "$?" -eq "0" ]; then
			echo "Started by npm"
			exit $?
		fi
	fi

	#Try to start with server.js
	pm2 start --name "$appName" /home/$user/$appName/server.js
	if [ "$?" -eq "0" ]; then
		echo "Started by server.js"
		exit $?
	fi

	#If everything above failed
	echo "START FAILED"
	exit 1
else
	echo "App $appName already started."
	exit 0	
fi





