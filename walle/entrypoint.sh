#!/usr/bin/env sh
set -e

#start db
mysqld_safe --user=mysql &

#start php-fpm
/usr/local/sbin/php-fpm&

#init walle
/opt/walle-web/yii walle/setup --interactive=0

#start nginx
#/usr/sbin/nginx

exec $@
