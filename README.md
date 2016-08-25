# nginx with Let's Encrypt self-updating certificates

This Docker image lets you run nginx with self-updating Let's Encrypt
certificates.

Let's Encrypt setup is handled with https://github.com/lukas2511/letsencrypt.sh

The domains to be handled is generated from the contents of nginx configuration.

## Configuring vhosts to allow self-updating

All vhosts must alias the `letsencrypt` folder. Make sure all vhosts for domains
listed in `domains.txt` contains:

```
    location /.well-known/acme-challenge {
        alias /var/www/letsencrypt;
    }
```

## Example run

Create the file `default.conf` with correct domain names

```
server {
    listen 443 ssl;
    server_name example.com;

    ssl_certificate /opt/letsencrypt.sh/certs/example.com/fullchain.pem;
    ssl_certificate_key /opt/letsencrypt.sh/certs/example.com/privkey.pem;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers 'EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH';
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;
    ssl_dhparam /etc/ssl/certs/dhparam.pem;

    location /.well-known/acme-challenge {
        alias /var/www/letsencrypt;
    }

    location / {
        root /usr/share/nginx/html;
        index index.html;
    }
}

server {
    listen 80;
    server_name example.com;
    return 302 https://example.com$request_uri;
}
```

```bash
docker run \
  -it --rm \
  -e LE_CONTACT_EMAIL=example@example.com \
  -e LE_STAGING=1 \
  -v letsencrypt-certs:/opt/letsencrypt.sh/certs \
  -v letsencrypt-accounts:/opt/letsencrypt.sh/accounts \
  -v "$(pwd)/default.conf":/etc/nginx/conf.d/default.conf \
  -p 80:80 -p 443:443 \
  henrist/nginx-letsencrypt
```

Open https://example.com/ and you should see nginx default welcome page

Remove LE_STAGING if you don't want it to run against Let's Encrypt staging api.
You will have to remove the certificates if you first run with LE_STAGING and
then want to generate real certificates.
