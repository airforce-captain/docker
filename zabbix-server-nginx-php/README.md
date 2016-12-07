[![](https://images.microbadger.com/badges/image/qq58945591/zabbix-server-nginx-php.svg)](https://microbadger.com/images/qq58945591/zabbix-server-nginx-php "Get your own image badge on microbadger.com")
# 关于本镜像

写在前面: 由于误操作,导致之前编辑好的东西被清空了,忘记commit了,fuck～


### 本镜像基于zabbix官方dockerfile改造,改造目的:

1. zabbix 官方将各个组件进行微服务配置,每个组件单独一个image, 我觉得有时候东西太散了也不是一件好事,所以将server端和web界面整合在一个image内.简化操作,反正也占不了多少空间.
2. 修正了zabbix官方的引用外部报警脚本的问题, 默认是/usr/lib/zabbix ,而web 端使用的则是/usr/share/zabbix,导致触发调用脚本的时候会失败.
3. 增加了一些系统组件命令，方便调用执行一些自定任务: curl,nmap,ansible.
4. 增加了几个第三方python模块,可以编写一些工具时可以调用: psutil,requests,MySQL-python.
5. zabbix 编译选项增加了编译代理工具,可以利用客户端工具zabbix_get 进行一些debug操作.
6. 修改了默认时区为Asia/Shanghai, 如果是其他可以自行设置环境变量如TZ="xxx/yyy".

### 如何使用?

#### 1. 直接使用docker run image方式,首先拉取镜像:

```
docker pull qq58945591/zabbix-server-nginx-php

```
启动之前,需要事先准备一个数据库容器.然后使用link命令链接到数据库.如果使用外部已存在的数据库则无需增加link参数,需要指定数据库地址.

for example:

```
docker run -d \
  --name zabbix-server \
  --link mariadb:mysql-server \
  --user root \
  -e ZBX_USER="zabbix" \
  -e ZBX_PASSWORD="zabbix_sec_pass" \
  -e MYSQL_USER=root \
  -e MYSQL_PASSWORD=root_sec_pass \
  -e MYSQL_DATABASE=zabbix \
  -e ZBX_SERVER_HOST=zabbix-server \
  -e DB_SERVER_HOST=mysql-server \
  -e DB_SERVER_ROOT_USER=root \
  -e DB_SERVER_ROOT_PASS=root_sec_pass \
  -p 80:80 \
  -p 10051:10051 \
  -v /etc/localtime:/etc/localtime:ro \
  -v /etc/timezone:/etc/timezone:ro \
  -v /usr/lib/zabbix/alertscripts:/usr/lib/zabbix/alertscripts:ro \
  -v /usr/lib/zabbix/externalscripts:/usr/lib/zabbix/externalscripts:ro \
  -v /var/lib/zabbix/ssh_keys:/var/lib/zabbix/ssh_keys:ro \
  --restart=always \
  qq58945591/zabbix-server-nginx-php
```

#### 2. 使用docker-compose 启动

首先确保安装了docker-compose, 如果没有安装,执行如下命令安装:

```
curl -L "https://github.com/docker/compose/releases/download/1.9.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

```
chmod +x /usr/local/bin/docker-compose
```

编写compose配置文件,如zabbix-compose.yml, for example:
(注: docker-compose新版本environment:字段可以使用`key: value`形式，也支持原来的`- key=value`的形式)

```
version: '2'
services:
 zabbix-server:
  image: qq58945591/zabbix-server-nginx-php
  ports:
   - "10051:10051"
   - "80:80"
  volumes:
   - /etc/localtime:/etc/localtime:ro
   - /etc/timezone:/etc/timezone:ro
   - /usr/lib/zabbix/alertscripts:/usr/lib/zabbix/alertscripts:ro
   - /usr/lib/zabbix/externalscripts:/usr/lib/zabbix/externalscripts:ro
   - /var/lib/zabbix/ssh_keys:/var/lib/zabbix/ssh_keys:ro
  links:
   - mariadb:mysql-server
  ulimits:
   nproc: 65535
   nofile:
    soft: 20000
    hard: 40000
   mem_limit: 512m
  environment:
     ZBX_USER: "zabbix"
     ZBX_PASSWORD: "zabbix_pass"
     MYSQL_USER: "root"
     MYSQL_PASSWORD: "root_sec_pass"
     MYSQL_DATABASE: "zabbix"
     TZ: Asia/Shanghai
     ZBX_SERVER_HOST: zabbix-server
     DB_SERVER_HOST: mysql-server
     DB_SERVER_ROOT_USER: "root"
     DB_SERVER_ROOT_PASS: "root_sec_pass"
     ZBX_HOUSEKEEPINGFREQUENCY: 1
     ZBX_MAXHOUSEKEEPERDELETE: 5000
     ZBX_SENDERFREQUENCY: 30
     ZBX_CACHESIZE: 8M
     ZBX_CACHEUPDATEFREQUENCY: 60
     ZBX_STARTDBSYNCERS: 4
     ZBX_HISTORYCACHESIZE: 16M
     ZBX_HISTORYINDEXCACHESIZE: 4M
     ZBX_TRENDCACHESIZE: 4M
     ZBX_VALUECACHESIZE: 8M
  user: root
  networks:
   zbx_net:
    aliases:
     - zabbix-server
  labels:
   com.zabbix.description: "Zabbix server with MySQL database support"
   com.zabbix.company: "Zabbix SIA"
   com.zabbix.component: "zabbix-server"
   com.zabbix.dbtype: "mysql"
   com.zabbix.os: "alpine"

 mariadb:
  image: mariadb
  volumes:
    - /opt/mysql/conf.d:/etc/mysql/conf.d
    - /opt/mysql/data:/var/lib/mysql
  environment:
    MYSQL_ROOT_PASSWORD: "root_sec_pass"
  ports:
    - "3306:3306"
  user: root
  networks:
   zbx_net:
     aliases:
      - mysql-server
      - mariadb

networks:
 zbx_net:
   driver: bridge
   driver_opts:
     com.docker.network.enable_ipv6: "false"
   ipam:
     driver: default
     config:
     - subnet: 172.18.1.0/24
       gateway: 172.18.1.1
```

然后执行启动命令:

```
docker-compose -f zabbix-compose.yml up -d
```

### 内置主要环境变量

zabbix用户:

ZBX_USER
ZBX_PASSWORD

zabbix数据库名:

MYSQL_DATABASE

创建zabbix用户的角色(root):

MYSQL_USER
MYSQL_PASSWORD

zabbix服务器主机(默认zabbix-server):

ZBX_SERVER_HOST

数据库主机:

DB_SERVER_HOST

数据库root账户密码:

DB_SERVER_ROOT_USER
DB_SERVER_ROOT_PASS



