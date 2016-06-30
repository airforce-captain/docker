#!/usr/bin/env sh
set -e

#init walle
/opt/walle-web/yii walle/setup --interactive=0

#start php-fpm
/usr/local/sbin/php-fpm&

#start nginx
/usr/sbin/nginx

exec $@
