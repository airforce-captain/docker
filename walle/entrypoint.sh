#!/usr/bin/env sh
set -e

#inital db
if [ ! -d "$DATADIR/mysql" ]; then
	mkdir -p $DATADIR
	chown -R mysql:mysql $DATADIR
	mkdir -p $DATADIR/walle
	chown -R mysql $DATADIR/walle
	mysql_install_db --user=mysql --datadir=$DATADIR
	mysqld_safe --user=mysql --datadir=$DATADIR&
	sleep 5
else
	if [ ! -d "$DATADIR/walle" ]; then
		mkdir -p $DATADIR/walle
		chown -R mysql $DATADIR/walle
		mysqld_safe --user=mysql --datadir=$DATADIR&
		sleep 5
	else
		mysqld_safe --user=mysql --datadir=$DATADIR&
		sleep 5
	fi
fi

#set mysql root pass,if no change will be use default value.

WALLE_DB_PASS=${WALLE_DB_PASS:-"walle"}

/usr/bin/mysql -e 'use mysql;update user set password=password("$WALLE_DB_PASS") where user="root";flush privileges'

/usr/bin/mysql -uroot -p${WALLE_DB_PASS} -e 'grant all on *.* to "root"@"%" identified by "$WALLE_DB_PASS";flush privileges;'

#if no index
if [ ! -e /var/www/html/index.php ];then
  mkdir -p /var/www/html
  echo '<?php' >/var/www/html/index.php
  echo 'phpinfo();' >>/var/www/html/index.php
  echo '?>' >>/var/www/html/index.php
fi

#replace default server_name
if [ $SERVER_NAME != "walle.company.com" ];then
	sed -ri "s/walle.company.com/$SERVER_NAME/" /etc/nginx/nginx.conf
fi


#disable walle ldap login feature.
if [ -e /opt/walle-web/config/params.php ];then
	sed -i "s/'user_driver'=>'ldap'/'user_driver'=>''/" /opt/walle-web/config/params.php
fi

#start nginx
/usr/sbin/nginx

#init walle
/opt/walle-web/yii walle/setup --interactive=0

exec $@
