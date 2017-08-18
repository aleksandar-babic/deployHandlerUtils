#!/usr/bin/env bash

if [ "$#" -ne 2 ]; then
    echo "Usage: ./addUser.sh username password"
    exit
fi

#CONFIG
user=$1
password=$2

#Create user if does not exist
if ! id "$user" >/dev/null 2>&1; then
    useradd -m -s /usr/sbin/nologin -G sftponly $user
    echo -e "$password\n$password\n" | sudo passwd $user
    if [ "$?" -eq "0" ]
    then
    	echo User $user created with password $password
    	exit 0
    else 
	   exit $? 	
    fi
else
	echo "User already exists."
	exit 2    
fi
