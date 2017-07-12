#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
    echo "Usage: ./removeUser.sh username"
    exit
fi

#CONFIG
user=$1

#Create user if does not exist
if id "$user" >/dev/null 2>&1; then

	#Loop through all user apps
	cd /home/$user
	for f in *; do
	    if [ -d ${f} ]; then
	    	#Remove app from PM2
	        su - appsrunner -c "pm2 delete $f"
	        #Remove NGINX vhost
			rm -rf /etc/nginx/sites-available/$f.deployhandler.com /etc/nginx/sites-enabled/$f.deployhandler.com
			nginx -t
			if [ "$?" -eq "0" ]
			then
				systemctl restart nginx
			else 
				exit $?
			fi			
	    fi
	done

	#Kill all user processes(probably just SFTP)
	killall -9 -u $user
	#Delete user from /cat/passwd and delete users home
	deluser --remove-home $user
	exit $?

else
	echo "User does not exist." >&2
	exit 2    
fi