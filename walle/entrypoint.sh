#!/usr/bin/env sh
#set -e
set -x

#inital db
if [ ! -d "$DATADIR/mysql" ]; then
	mkdir -p $DATADIR
	chown -R mysql:mysql $DATADIR
	mkdir -p $DATADIR/walle
	chown -R mysql $DATADIR/walle
	mysql_install_db --user=mysql --datadir=$DATADIR
	mysqld_safe --user=mysql --datadir=$DATADIR&
	sleep 5
fi

#set mysql root pass,if no change will be use default value.

WALLE_DB_PASS=${WALLE_DB_PASS:-"walle"}

/usr/bin/mysql -uroot -e "create database if not exists walle default charset='utf8mb4';"

/usr/bin/mysql -uroot -e "grant all on *.* to 'root'@'%' identified by '$WALLE_DB_PASS';flush privileges;"

/usr/bin/mysqladmin -u root password "${WALLE_DB_PASS}"

#change walle connect to DB passwd.
sed -ri "/WALLE_DB_PASS/ s/(.*:)? (.*)$/\1 '$WALLE_DB_PASS',/" /opt/walle-web/config/local.php

#smtp setup, if want change.
WALLE_MAIL_HOST=${WALLE_MAIL_HOST:-"smtp.exmail.qq.com"}
WALLE_MAIL_USER=${WALLE_MAIL_USER:-"service@huamanshu.com"}
WALLE_MAIL_PASS=${WALLE_MAIL_PASS:-"K84erUuxg1bHqrfD"}
WALLE_MAIL_PORT=${WALLE_MAIL_PORT:-"25"}
WALLE_MAIL_ENCRYPTION=${WALLE_MAIL_ENCRYPTION:-"tls"}

for s in WALLE_MAIL_HOST WALLE_MAIL_USER WALLE_MAIL_PASS WALLE_MAIL_PORT WALLE_MAIL_ENCRYPTION
do
case $s in
	*HOST)
	sed -ri "/$s/ s/(.*:)? (.*)$/\1 '$WALLE_MAIL_HOST',/" /opt/walle-web/config/local.php
	;;
	*USER)
	sed -ri "/$s/ s/(.*:)? (.*)$/\1 '$WALLE_MAIL_USER',/" /opt/walle-web/config/local.php
	;;
	*PASS)
	sed -ri "/$s/ s/(.*:)? (.*)$/\1 '$WALLE_MAIL_PASS',/" /opt/walle-web/config/local.php
	;;
	*PORT)
	sed -ri "/$s/ s/(.*:)? (.*)$/\1 '$WALLE_MAIL_PORT',/" /opt/walle-web/config/local.php
	;;
	*ENCRYPTION)
	sed -ri "/$s/ s/(.*:)? (.*)$/\1 '$WALLE_MAIL_ENCRYPTION',/" /opt/walle-web/config/local.php
esac
done

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
