#!/usr/bin/env bash

if [ "$#" -ne 3 ]; then
    echo "Usage: ./renameApp.sh oldName newName username"
    exit
fi

#CONFIG
oldName=$1
newName=$2
username=$3
oldUrl=$oldName.deployhandler.com
newUrl=$newName.deployhandler.com

echo $oldUrl
echo $newUrl

mv /home/$username/$oldName /home/$username/$newName

mv /etc/nginx/sites-available/$oldUrl /etc/nginx/sites-available/$newUrl
rm -rf /etc/nginx/sites-enabled/$oldUrl
ln -s /etc/nginx/sites-available/$newUrl /etc/nginx/sites-enabled/$newUrl

nginx -t
if [ "$?" -eq "0" ]
then
	systemctl restart nginx
else
    #Do some housekeeping?
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
