#!/bin/bash

HAPROXY_SSL="/etc/ssl/haproxy/"
LETSENCRYPT_BASE="/etc/letsencrypt/live"

if [[ "${1}" == "" ]]; then
	echo "Missing domain argument"
	exit
fi

if [[ "${2}" == "" ]]; then
	echo "Missing webroot argument"
	exit
fi

DOMAIN=$1
WEBROOT=$2

echo "Creating certificate for: ${DOMAIN}"
echo "/usr/bin/certbot-3 certonly --webroot -w $WEBROOT -d $DOMAIN --webroot $WEBROOT"
/usr/bin/certbot-3 certonly --webroot -w $WEBROOT -d $DOMAIN
cd $LETSENCRYPT_BASE/$DOMAIN
cat privkey.pem > haproxy_fullchain.pem
cat fullchain.pem >> haproxy_fullchain.pem
cd $HAPROXY_SSL
ln -sf $LETSENCRYPT_BASE/$DOMAIN/haproxy_fullchain.pem $DOMAIN
systemctl restart haproxy
