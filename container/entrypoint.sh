#!/bin/sh
set -e

# If /opt/letsencrypt.sh/certs or /opt/letsencrypt.sh/accounts is present
# the old setup is being used. Warn the user and maintain backward compatibility

if [ -d /opt/letsencrypt.sh/accounts ]; then
  echo "WARNING: You are using an old setup on the nginx-letsencrypt image"
  echo "which should be migrated to use new setup"
  echo
  echo "To migrate:"
  echo "  Change volume mount destinations:"
  echo "  /opt/letsencrypt.sh/accounts -> /opt/dehydrated/accounts"
  echo "  /opt/letsencrypt.sh/certs -> /opt/dehydrated/certs"
  echo
  echo "  Also change acme aliases in existing nginx configurations"
  echo

  # Provide backward compatibility by changing which folders we are targetting
  # Variables are used in our custom dehydrated config
  export LE_ACCOUNTDIR="/opt/letsencrypt.sh/accounts"
  export LE_CERTDIR="/opt/letsencrypt.sh/certs"
  export LE_BACKWARD_COMPAT=1

  /backward-compat.sh
fi

exec "$@"
