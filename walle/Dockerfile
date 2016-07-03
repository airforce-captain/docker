FROM php:5-fpm-alpine

MAINTAINER YougnMan <bushengquan@eastspider.com>

LABEL description="walle 包含LNMP集成版测试"

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
            ansible 

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
      && mysql_install_db --user=mysql --datadir=/opt/mysql 

      
RUN  apk del \
	autoconf \
	m4 \
	perl \
	file \
	g++ \
	gcc \
	binutils \
	isl \
	libatomic \
	pkgconfig \
	libc-dev \
	musl-dev \
	make \
	pkgconf \
	re2c \
	libmagic \
	binutils-libs \
	mpc1 \
	mpfr3 \
	gpm \
	libgomp

EXPOSE 80

VOLUME ["/opt/walle-web", "/opt/mysql"]

ENTRYPOINT ["/entrypoint.sh"]

CMD ["php-fpm"]
