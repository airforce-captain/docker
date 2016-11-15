[![](https://images.microbadger.com/badges/image/qq58945591/nginx_php-fpm.svg)](https://microbadger.com/images/qq58945591/nginx_php-fpm "Get your own image badge on microbadger.com")

# 关于本镜像:

打包nginx 1.10.2与php-fpm 5.4.45 添加redis,opcache 两个扩展,修改默认时区是Asia/Shanghai,修改php.ini 中最大上传为30M.

#### nginx 直接使用官方编译参数:

```
./configure \
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
--user=nginx --group=nginx \
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
--with-ipv6
```

#### php 编译为php-fpm,包含常用php扩展:

```
./configure \
--with-config-file-path="/etc/php" \
--with-config-file-scan-dir="/etc/php/conf.d" \
--disable-cgi \
--disable-ipv6 \
--enable-fpm \
--with-fpm-user=nginx \
--with-fpm-group=nginx \
--enable-ftp \
--enable-mbstring \
--enable-mysqlnd \
--enable-sockets \
--enable-sysvsem \
--enable-sysvshm \
--enable-opcache \
--enable-exif \
--enable-zip \
--enable-intl \
--enable-mbregex \
--with-pcre-regex \
--with-curl \
--with-libedit \
--with-openssl \
--with-zlib \
--with-mcrypt \
--with-gettext \
--with-readline \
--with-gd \
--enable-gd-native-ttf \
--with-mhash \
--with-iconv-dir \
--with-pcre-dir \
--with-jpeg-dir \
--with-png-dir \
--with-vpx-dir \
--with-freetype-dir \
--with-imap \
--with-litespeed \
--with-bz2 
```
#### 支持扩展列表:

bz2 Core ctype curl date dom ereg exif fileinfo filter ftp gd gettext hash iconv imap intl json libxml mbstring mcrypt mhash mysqli mysqlnd openssl pcre PDO pdo_mysql pdo_sqlite Phar posix readline redis Reflection session SimpleXML sockets SPL sqlite3 standard sysvsem sysvshm tokenizer xml xmlreader xmlwriter OPcache zip zlib

