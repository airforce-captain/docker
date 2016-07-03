#!/usr/bin/env sh
set -e

#init db
if [ ! -d $DATADIR ]; then
	mkdir -p $DATADIR
	chown -R mysql:mysql $DATADIR
fi

#start db
if [ ! -d "$DATADIR/mysql" ]; then
	mysql_install_db --user=mysql --datadir=$DATADIR&&mysqld_safe --user=mysql --datadir=$DATADIR&
else
	mysqld_safe --user=mysql --datadir=$DATADIR&
fi

#if no index
if [ ! -e /var/www/html/index.php ];then
  echo '<?php' >/var/www/html/index.php
  echo 'phpinfo();' >>/var/www/html/index.php
  echo '?>' >>/var/www/html/index.php
fi

#replace default server_name
if [ $SERVER_NAME != "walle.company.com" ];then
	sed -ri "s/walle.company.com/$SERVER_NAME/" /etc/nginx/nginx.conf
fi

#start nginx
/usr/sbin/nginx

#init walle
/opt/walle-web/yii walle/setup --interactive=0

exec $@
