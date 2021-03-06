#!/bin/sh
set -e

# prerequisite:
# 1. /etc/ssl/certs/dhparam.pem must be generated
# 2. nginx must be running and serving the well known directory

cd /opt/dehydrated

while true; do
    # certificates are updated when docker container is run
    # so we don't need to check it for a while
    sleep 1d

    date
    echo "Checking if certificates needs updating"

    ./generate-domains.sh
    ./dehydrated --cron --accept-terms
    /backward-compat.sh
    echo "Reloading nginx"
    kill -HUP $(cat /var/run/nginx.pid)
done
