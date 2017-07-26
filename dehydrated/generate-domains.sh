#!/bin/sh

# This script discovers certificates referenced in the nginx
# configuration which we will try to maintain certificates for.
grep -rh "ssl_certificate\s*/opt/dehydrated/certs/" /etc/nginx | \
  sed 's/.*certs\/\(.*\)\/full.*/\1/' >/opt/dehydrated/domains.txt

# Backward compatibility
grep -rh "ssl_certificate\s*/opt/letsencrypt.sh/certs/" /etc/nginx | \
  sed 's/.*certs\/\(.*\)\/full.*/\1/' >>/opt/dehydrated/domains.txt
