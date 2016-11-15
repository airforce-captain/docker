#!/usr/bin/env sh
set -e

#set default timezone.
TZ=${TZ:-"Asia/Shanghai"}
sed -ri "s#\;(date.timezone.*)#\1$TZ#" /etc/php/php.ini

#start nginx
/usr/sbin/nginx

exec $@
