#!/usr/bin/env bash

#CONFIG
user=$1
password=$2
appName=$3
url=$3.deployhandler.com
port=$4

Create user
useradd -m $user
echo -e "$password\n$password\n" | sudo passwd $user
if [ "$?" -eq "0" ]
then
	echo User $1 created with password $2
else 
	exit $? 	
fi

#Setup NGINX
awk -v url="$url" '{sub(/changeme/, url)}1' /etc/nginx/sites-available/template > /etc/nginx/sites-available/$url.tmp
awk -v port="$port" '{sub(/8080/, port)}1'  /etc/nginx/sites-available/$url.tmp > /etc/nginx/sites-available/$url
rm /etc/nginx/sites-available/$url.tmp
ln -s /etc/nginx/sites-available/$url /etc/nginx/sites-enabled/$url
nginx -t
if [ "$?" -eq "0" ]
then
	systemctl restart nginx
else 
	exit $?
fi			


#Cloudflare API add DNS domain
curl -X POST "https://api.cloudflare.com/client/v4/zones/YOUR_ZONE_ID/dns_records" \
     -H "X-Auth-Email: YOUR_EMAIL" \
     -H "X-Auth-Key: YOUR_API_KEY" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'$url'","content":"127.0.0.1","ttl":120,"proxied":false}'
if [ "$?" -eq "0" ]
then
	exit $?
fi

exit 0
