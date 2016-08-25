FROM nginx
MAINTAINER Henrik Steen <henrist@henrist.net>

RUN mkdir -p /var/www/letsencrypt \
    && mkdir -p /opt/letsencrypt.sh \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y \
                                                        curl \
                                                        supervisor \
                                                        wget \
    && wget -qO- "https://github.com/lukas2511/letsencrypt.sh/archive/6192b33ac21b185085aea620223aef3028a1b66e.tar.gz" \
       | tar zx -C /opt/letsencrypt.sh --strip 1 \
    && rm -rf /var/lib/apt/lists/*

COPY nginx/* /etc/nginx/
COPY letsencrypt/* /opt/letsencrypt.sh/
COPY supervisor/* /

VOLUME ["/opt/letsencrypt.sh/certs", "/opt/letsencrypt.sh/accounts"]
CMD /usr/bin/supervisord -c /supervisord.conf
