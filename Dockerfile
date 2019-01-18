FROM php:apache

RUN apt-get update \
  && apt-get -y install cron rsyslog \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /tmp/* /var/lib/apt/lists/* /var/cache/debconf/*-old

RUN curl -L 'https://github.com/just-containers/s6-overlay/releases/download/v1.21.7.0/s6-overlay-amd64.tar.gz' | tar xz -C /

RUN a2enmod rewrite \
  && docker-php-ext-install mysqli \
  && docker-php-ext-install gettext \
  && mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

COPY rootfs /
RUN chmod +x /usr/local/bin/* /services/*/run /services/.s6-svscan/finish

COPY --chown=www-data:www-data sendy /var/www/html

CMD ["run.sh"]
