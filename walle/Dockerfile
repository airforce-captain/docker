FROM php:5-fpm-alpine

MAINTAINER YougnMan <bushengquan@eastspider.com>

LABEL description="walle 包含LNMP集成版测试"

RUN mkdir -p /opt/walle-web && apk add --no-cache --virtual .persistent-deps \
            git \
            nginx \
            mysql \
            unzip \
            subversion \
            ansible \
            openssh-client

RUN apk add --no-cache --virtual .build-deps \
            libmcrypt-dev \
            gettext \
            icu-libs \
            zlib-dev 
	    
RUN docker-php-ext-install bcmath intl mbstring mcrypt mysqli opcache pdo_mysql

ADD ./walle.ini /usr/local/etc/php/conf.d/walle.ini
ADD ./entrypoint.sh /entrypoint.sh
ADD ./nginx.conf /etc/nginx/nginx.conf

WORKDIR /opt/walle-web

RUN   curl -sS https://getcomposer.org/installer | php \
      && mv composer.phar /usr/local/bin/composer \
      && chmod +x /usr/local/bin/composer 
RUN   git clone https://github.com/meolu/walle-web /opt/walle-web \
      &&composer install --prefer-dist --no-dev --optimize-autoloader -vvvv \
      && chmod +x /entrypoint.sh \
      && chown -R www-data:nginx /opt/walle-web \
      && mkdir -p /opt/mysql/walle \
      && chown -R mysql:mysql /opt/mysql/walle \
      && apk del .build-deps \
      && rm -rf /usr/src/php*

ENV SERVER_NAME="walle.company.com"  DATADIR="/opt/mysql"

EXPOSE 80 3306

VOLUME ["/opt/walle-web", "/opt/mysql"]

ENTRYPOINT ["/entrypoint.sh"]

CMD ["php-fpm"]
