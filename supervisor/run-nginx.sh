#!/bin/bash
set -e

if ! [ -f "/etc/ssl/certs/dhparam.pem" ]; then
    echo "dhparam not existing - generating ..."
    openssl dhparam -dsaparam -out /etc/ssl/certs/dhparam.pem 2048
fi

cd /opt/letsencrypt.sh
./generate-domains.sh

if [ -z "$(cat /opt/letsencrypt.sh/domains.txt)" ]; then
    echo "No domains is configured to use ssl"
else
    echo "Domain list:"
    cat /opt/letsencrypt.sh/domains.txt
    echo

    #if ! ls /opt/letsencrypt.sh/certs/*/fullchain.pem 1>/dev/null 2>&1; then
    #    echo "missing certificates, will try to generate them"
    #fi

    # spawn a temporary nginx session that only serves http for certs authorization
    nginx -c /etc/nginx/nginx-certs-generation.conf

    ./letsencrypt.sh -c -f config || true

    kill $(cat /var/run/nginx.pid)
    sleep 2
fi

echo "Starting nginx in non-daemon mode"
nginx -g "daemon off;"
