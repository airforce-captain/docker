FROM alpine:3.4

MAINTAINER YoungMan "bushengquan@eastspider.com"

LABEL description="集成nginx,php5.4.45"

ENV NGINX_VERSION 1.10.2

RUN GPG_KEYS=B0F4253373F8F6F510D42178520A9993A1C052F8 \
	&& CONFIG="\
		--prefix=/etc/nginx \
		--sbin-path=/usr/sbin/nginx \
		--modules-path=/usr/lib/nginx/modules \
		--conf-path=/etc/nginx/nginx.conf \
		--error-log-path=/var/log/nginx/error.log \
		--http-log-path=/var/log/nginx/access.log \
		--pid-path=/var/run/nginx.pid \
		--lock-path=/var/run/nginx.lock \
		--http-client-body-temp-path=/var/cache/nginx/client_temp \
		--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
		--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
		--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
		--http-scgi-temp-path=/var/cache/nginx/scgi_temp \
		--user=nginx \
		--group=nginx \
		--with-http_ssl_module \
		--with-http_realip_module \
		--with-http_addition_module \
		--with-http_sub_module \
		--with-http_dav_module \
		--with-http_flv_module \
		--with-http_mp4_module \
		--with-http_gunzip_module \
		--with-http_gzip_static_module \
		--with-http_random_index_module \
		--with-http_secure_link_module \
		--with-http_stub_status_module \
		--with-http_auth_request_module \
		--with-http_xslt_module=dynamic \
		--with-http_image_filter_module=dynamic \
		--with-http_geoip_module=dynamic \
		--with-http_perl_module=dynamic \
		--with-threads \
		--with-stream \
		--with-stream_ssl_module \
		--with-http_slice_module \
		--with-mail \
		--with-mail_ssl_module \
		--with-file-aio \
		--with-http_v2_module \
		--with-ipv6 \
	" \
	&& addgroup -S nginx \
	&& adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx \
	&& echo 'http://192.168.0.252/alpine/v3.4/main' > /etc/apk/repositories \
    	&& echo 'http://192.168.0.252/alpine/v3.4/community' >> /etc/apk/repositories \
	&& apk add --no-cache --virtual .build-deps \
		gcc \
		libc-dev \
		make \
		openssl-dev \
		pcre-dev \
		zlib-dev \
		linux-headers \
		curl \
		gnupg \
		libxslt-dev \
		gd-dev \
		geoip-dev \
		perl-dev \
        ca-certificates \
        tar \
        xz \
        curl-dev \
        libedit-dev \
        libxml2-dev \
        sqlite-dev \
        autoconf \
        file \
        g++ \
        pkgconf \
        re2c \        
	&& curl -fSL http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz -o nginx.tar.gz \
	&& curl -fSL http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz.asc  -o nginx.tar.gz.asc \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& rm -r "$GNUPGHOME" nginx.tar.gz.asc \
	&& mkdir -p /usr/src \
	&& tar -zxC /usr/src -f nginx.tar.gz \
	&& rm nginx.tar.gz \
	&& cd /usr/src/nginx-$NGINX_VERSION \
	&& ./configure $CONFIG --with-debug \
	&& make -j$(getconf _NPROCESSORS_ONLN) \
	&& mv objs/nginx objs/nginx-debug \
	&& mv objs/ngx_http_xslt_filter_module.so objs/ngx_http_xslt_filter_module-debug.so \
	&& mv objs/ngx_http_image_filter_module.so objs/ngx_http_image_filter_module-debug.so \
	&& mv objs/ngx_http_geoip_module.so objs/ngx_http_geoip_module-debug.so \
	&& mv objs/ngx_http_perl_module.so objs/ngx_http_perl_module-debug.so \
	&& ./configure $CONFIG \
	&& make -j$(getconf _NPROCESSORS_ONLN) \
	&& make install \
	&& rm -rf /etc/nginx/html/ \
	&& mkdir /etc/nginx/conf.d/ \
	&& mkdir -p /usr/share/nginx/html/ \
	&& echo '<?php ' >> /usr/share/nginx/html/index.php \
	&& echo 'phpinfo()' >> /usr/share/nginx/html/index.php \
	&& echo '?>' >> /usr/share/nginx/html/index.php \
	&& install -m644 html/index.html /usr/share/nginx/html/ \
	&& install -m644 html/50x.html /usr/share/nginx/html/ \
	&& install -m755 objs/nginx-debug /usr/sbin/nginx-debug \
	&& install -m755 objs/ngx_http_xslt_filter_module-debug.so /usr/lib/nginx/modules/ngx_http_xslt_filter_module-debug.so \
	&& install -m755 objs/ngx_http_image_filter_module-debug.so /usr/lib/nginx/modules/ngx_http_image_filter_module-debug.so \
	&& install -m755 objs/ngx_http_geoip_module-debug.so /usr/lib/nginx/modules/ngx_http_geoip_module-debug.so \
	&& install -m755 objs/ngx_http_perl_module-debug.so /usr/lib/nginx/modules/ngx_http_perl_module-debug.so \
	&& ln -s ../../usr/lib/nginx/modules /etc/nginx/modules \
	&& strip /usr/sbin/nginx* \
	&& strip /usr/lib/nginx/modules/*.so \
	&& rm -rf /usr/src/nginx-$NGINX_VERSION \
	\
	# Bring in gettext so we can get `envsubst`, then throw
	# the rest away. To do this, we need to install `gettext`
	# then move `envsubst` out of the way so `gettext` can
	# be deleted completely, then move `envsubst` back.
	&& apk add --no-cache --virtual .gettext gettext \
	&& mv /usr/bin/envsubst /tmp/ \
	\
	&& runDeps="$( \
		scanelf --needed --nobanner /usr/sbin/nginx /usr/lib/nginx/modules/*.so /tmp/envsubst \
			| awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
			| sort -u \
			| xargs -r apk info --installed \
			| sort -u \
	)" \
	&& apk add --no-cache --virtual .nginx-rundeps $runDeps \
	&& mv /tmp/envsubst /usr/local/bin/ \
	\
	# forward request and error logs to docker log collector
	&& ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx.vh.default.conf /etc/nginx/conf.d/default.conf

COPY docker-php-source /usr/local/bin/

ADD ./entrypoint.sh /entrypoint.sh

ENV PHPIZE_DEPS \
		autoconf \
		file \
		g++ \
		gcc \
		libc-dev \
		make \
		pkgconf \
		re2c
RUN apk add --no-cache --virtual .persistent-deps \
		ca-certificates \
		curl \
		tar \
		xz

ENV PHP_INI_DIR /etc/php
RUN mkdir -p $PHP_INI_DIR/conf.d

ENV PHP_EXTRA_CONFIGURE_ARGS --enable-fpm --with-fpm-user=nginx --with-fpm-group=nginx

ENV PHP_VERSION 5.4.45
ENV PHP_FILENAME php-5.4.45.tar.bz2

ENV REDIS_VERSION 2.2.8
ENV REDIS_FILENAME redis-2.2.8.tgz

ENV OP_VERSION 7.0.5
ENV OP_FILENAME zendopcache-7.0.5.tgz

RUN set -xe \
	&& apk add --no-cache --virtual .fetch-deps \
		gnupg \
		curl \
	&& mkdir -p /usr/src \
	&& cd /usr/src \
	&& curl -fSL "https://secure.php.net/get/$PHP_FILENAME/from/this/mirror" -o php.tar.bz2 \
    	&& apk add --no-cache --virtual .build-deps \
    		$PHPIZE_DEPS \
    		curl-dev \
    		libedit-dev \
    		libxml2-dev \
		openssl-dev \
    		sqlite-dev \
            	gettext \
            	libmcrypt-dev \
            	icu-libs \
            	zlib-dev \
    		libpng-dev \
		intltool \
		gettext-dev \
		icu \
		icu-dev \
		libvpx-dev \
		libjpeg-turbo-dev \
		freetype-dev \
		imap-dev \
		bzip2-dev \
		bison \
    	&& docker-php-source extract \
    	&& cd /usr/src/php \
	&& wget http://pecl.php.net/get/$REDIS_FILENAME -O /usr/src/php/ext/redis.tgz \
	&& wget http://pecl.php.net/get/$OP_FILENAME -O /usr/src/php/ext/opcache.tgz \
	&& tar xf /usr/src/php/ext/redis.tgz -C /usr/src/php/ext \
	&& tar xf /usr/src/php/ext/opcache.tgz -C /usr/src/php/ext \
	&& mv /usr/src/php/ext/redis-${REDIS_VERSION} /usr/src/php/ext/redis \
	&& mv /usr/src/php/ext/zendopcache-${OP_VERSION} /usr/src/php/ext/opcache \
    	&& ./configure \
    		--with-config-file-path="$PHP_INI_DIR" \
    		--with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
    		\
    		--disable-cgi \
		--disable-ipv6 \
    		\
    		--enable-ftp \
    		--enable-mbstring \
    		--enable-mysqlnd \
		--enable-sockets \
		--enable-sysvsem \
		--enable-sysvshm \
		--enable-exif \
		--enable-zip \
		--enable-intl \
		--enable-mbregex \
		--enable-gd-native-ttf \
    		\
		--with-pcre-regex \
    		--with-curl \
    		--with-libedit \
    		--with-openssl \
    		--with-zlib \
		--with-mcrypt \
		--with-gettext \
		--with-readline \
		--with-gd \
		--with-mhash \
		--with-iconv-dir \
		--with-pcre-dir \
		--with-jpeg-dir \
		--with-png-dir \
		--with-freetype-dir \
		--with-imap \
		--with-litespeed \
		--with-bz2 \
    		\
    		$PHP_EXTRA_CONFIGURE_ARGS \
    	&& make -j"$(getconf _NPROCESSORS_ONLN)" \
    	&& make install \
	&& cp php.ini-production $PHP_INI_DIR/php.ini \
	&& sed -ri "s#upload_max_filesize = 2M#upload_max_filesize = 30M#" /etc/php/php.ini \
	&& sed -ri "s#post_max_size = 8M#post_max_size = 30M#" /etc/php/php.ini \
	&& cd /usr/src/php/ext/redis \
	&& phpize \
	&& ./configure --with-php-config=/usr/local/bin/php-config \
	&& make \
	&& make install \
	&& echo '[redis]' >> $PHP_INI_DIR/conf.d/redis.ini \
	&& echo 'extension="redis.so"' >> $PHP_INI_DIR/conf.d/redis.ini \
        && cd /usr/src/php/ext/opcache \
        && phpize \
        && ./configure --with-php-config=/usr/local/bin/php-config --enable-opcache \
        && make \
        && make install \
	&&{ \
	   echo '[opcache]'; \
	   echo 'zend_extension="/usr/local/lib/php/extensions/no-debug-non-zts-20100525/opcache.so"'; \
	   echo 'opcache.memory_consumption=128'; \
	   echo 'opcache.interned_strings_buffer=8'; \
	   echo 'opcache.max_accelerated_files=4000'; \
	   echo 'opcache.revalidate_freq=60'; \
	   echo 'opcache.fast_shutdown=1'; \
	   echo 'opcache.enable_cli=1'; \
	} | tee $PHP_INI_DIR/conf.d/opcache.ini \
	&& cd /usr/src/php \
    	&& { find /usr/local/bin /usr/local/sbin -type f -perm +0111 -exec strip --strip-all '{}' + || true; } \
    	&& make clean \
    	&& docker-php-source delete \
    	\
    	&& runDeps="$( \
    		scanelf --needed --nobanner --recursive /usr/local \
    			| awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
    			| sort -u \
    			| xargs -r apk info --installed \
    			| sort -u \
    	)" \
    	&& apk add --no-cache --virtual .php-rundeps $runDeps \
    	\
	&& apk del .fetch-deps \
	&& apk del .build-deps \
	&& apk del .gettext 

    COPY docker-php-ext-* /usr/local/bin/

    RUN docker-php-ext-install bcmath intl mbstring mcrypt mysqli pdo_mysql

    WORKDIR /usr/share/nginx/html

    RUN set -ex \
    	&& cd /etc \
    	&& if [ -d php-fpm.d ]; then \
    		# for some reason, upstream's php-fpm.conf.default has "include=NONE/etc/php-fpm.d/*.conf"
    		sed 's!=NONE/!=!g' php-fpm.conf.default | tee php-fpm.conf > /dev/null; \
    		cp php-fpm.d/www.conf.default php-fpm.d/www.conf; \
    	else \
    		mkdir php-fpm.d; \
    		cp php-fpm.conf.default php-fpm.d/www.conf; \
    		{ \
    			echo '[global]'; \
    			echo 'include=/etc/php-fpm.d/*.conf'; \
    		} | tee php-fpm.conf; \
    	fi \
    	&& { \
            echo '[global]'; \
            echo 'error_log = /proc/self/fd/2'; \
            echo 'daemonize = no'; \
            echo; \
            echo '[www]'; \
            echo 'access.log = /proc/self/fd/2'; \
            echo 'clear_env = no'; \
            echo 'catch_workers_output = yes'; \
            echo 'user = nginx'; \
            echo 'group = nginx'; \
            echo 'listen.backlog = 4096'; \
            echo 'listen.owner = nginx'; \
            echo 'listen.group = nginx'; \
            echo 'listen.mode = 0660'; \
            echo 'listen = 9000'; \
            echo ';listen = /var/run/php-fpm.sock'; \
            echo 'rlimit_files = 65536'; \
            echo 'pm = dynamic'; \
            echo 'pm.max_children = 150'; \
            echo 'pm.start_servers = 10'; \
            echo 'pm.min_spare_servers = 10'; \
            echo 'pm.max_spare_servers = 100'; \
            echo 'request_terminate_timeout = 10m'; \
    	} | tee php-fpm.d/socket.conf \
	&& rm -rf /usr/src/php* \
	&& ln -s /etc/php-fpm.conf /usr/local/etc/php-fpm.conf


EXPOSE 80 443 9000

ENTRYPOINT ["/entrypoint.sh"]

CMD ["php-fpm"]
