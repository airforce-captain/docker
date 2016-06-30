FROM php:5-fpm-alpine

MAINTAINER YougnMan <bushengquan@eastspider.com>

LABEL description="walle 全集成版本，包含lnmp.测试"

RUN mkdir -p /opt/walle-web && apk add --update \
            git \
            nginx \
            mysql \
            gettext \
            libmcrypt-dev \
            icu-libs \
            zlib-dev \
            unzip \
            subversion \
            ansible \
            openssh

RUN docker-php-ext-install bcmath intl mbstring mcrypt mysqli opcache pdo_mysql

ADD ./walle.ini /usr/local/etc/php/conf.d/walle.ini
ADD ./entrypoint.sh /entrypoint.sh
ADD ./nginx.conf /etc/nginx/nginx.conf

WORKDIR /opt/walle-web

RUN   curl -sS https://getcomposer.org/installer | php \
      && mv composer.phar /usr/local/bin/composer \
      && chmod +x /usr/local/bin/composer 
RUN   composer install --prefer-dist --no-dev --optimize-autoloader -vvvv \
      && chmod +x /entrypoint.sh \
      && chown -R www-data:www-data /opt/walle-web


EXPOSE 22 80 9000
ENTRYPOINT ["/entrypoint.sh"]
CMD ["mysqld_safe&","nginx", "php-fpm"]
