#!/bin/bash

os=alpine

version=$1
version=${version:-"latest"}

app_component=proxy
app_database=mysql

if [[ ! $version =~ ^[0-9]*\.[0-9]*\.[0-9]*$ ]] && [ "$version" != "latest" ]; then
    echo "Incorrect syntax of the version"
    exit 1
fi

docker build -t zabbix-$app_component-$app_database:$os-$version -f Dockerfile .

#docker rm -f zabbix-$app_component-$app_database
#docker rm -f mysql-server

#docker run --name mysql-server -t -e MYSQL_DATABASE="zabbix" -e MYSQL_USER="zabbix" -e MYSQL_PASSWORD="zabbix" -e MYSQL_RANDOM_ROOT_PASSWORD=true -d mysql:5.7
#sleep 5
#docker run --name zabbix-$app_component-$app_database -t -d --link mysql-server:mysql --link zabbix-server:zabbix-server zabbix-$app_component-$app_database:$os-$version
