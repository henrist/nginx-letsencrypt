#!/bin/bash

grep -rh "ssl_certificate\s*/opt/letsencrypt.sh/certs/" /etc/nginx | \
  sed 's/.*certs\/\(.*\)\/full.*/\1/' >/opt/letsencrypt.sh/domains.txt
