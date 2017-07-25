#!/bin/sh
set -e

# See entrypoint.sh for a description of this file

if [ -z "$LE_BACKWARD_COMPAT" ]; then
  exit
fi

echo "INFO: Providing backward compatibility of certification storage location"

# Nginx should point to new directory, but that directory
# is a volume we are not interested in, as data is stored in
# the old location. We work around this by symlinking directories
cd /opt/letsencrypt.sh/certs/
for d in *; do
  echo "Processing $d"
  if [ -d "/opt/letsencrypt.sh/certs/$d" ] && ! [ -f "/opt/dehydrated/certs/$d" ]; then
    ln -s "/opt/letsencrypt.sh/certs/$d" "/opt/dehydrated/certs/$d"
  fi
done
