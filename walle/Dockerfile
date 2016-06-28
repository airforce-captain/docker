FROM php:5-fpm-alpine

MAINTAINER YougnMan <bushengquan@eastspider.com>

LABEL description="walle 全集成版本，包含lnmp.测试"

RUN apk add --update \
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



EXPOSE 80
CMD ["nginx"]
