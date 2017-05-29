#!/usr/bin/env bash

if [ "$#" -ne 2 ]; then
    echo "Usage: ./removeApp.sh username appName"
    exit
fi

#CONFIG
user=$1
appName=$2
url=$2.example.com

#Delete app files
rm -rf /home/$1/$2

#Remove NGINX vhost
rm /etc/nginx/sites-available/$url /etc/nginx/sites-enabled/$url
nginx -t
if [ "$?" -eq "0" ]
then
	systemctl restart nginx
else 
	exit $?
fi			

#Cloudflare DNS Delete , NodeJS? (machinepack-cloudflare)

exit 0
