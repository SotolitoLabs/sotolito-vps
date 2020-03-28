#!/bin/bash

HAPROXY_SSL="/etc/ssl/haproxy/"
LETSENCRYPT_BASE="/etc/letsencrypt/live"


echo "Renewing certificates"
for DOMAIN in $(/usr/bin/certbot-3 renew 2>&1 | grep '(success)' | cut -d '/' -f 5); do
    echo "Updating ${DOMAIN}"
    cd $LETSENCRYPT_BASE/$DOMAIN
    cat privkey.pem > haproxy_fullchain.pem
    cat fullchain.pem >> haproxy_fullchain.pem
    cd $HAPROXY_SSL
    ln -sf $LETSENCRYPT_BASE/$DOMAIN/haproxy_fullchain.pem $DOMAIN   
done

echo "Restarting HAProxy"
systemctl restart haproxy

