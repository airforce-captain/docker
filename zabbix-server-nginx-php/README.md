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

#### 1. 直接使用image,首先拉取镜像:
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
  -e MYSQL_USER="root" \
  -e MYSQL_PASSWORD="passwd123" \
  -e MYSQL_DATABASE=zabbix \
  -e ZBX_SERVER_HOST=zabbix-server \
  -e DB_SERVER_HOST=mysql-server \
  -p 80:80 \
  -p 10051:10051 \
  -v /etc/localtime:/etc/localtime:ro \
  -v /etc/timezone:/etc/timezone:ro \
  -v /usr/lib/zabbix/alertscripts:/usr/lib/zabbix/alertscripts:ro \
  -v /usr/lib/zabbix/externalscripts:/usr/lib/zabbix/externalscripts:ro \
  -v /var/lib/zabbix/ssh_keys:/var/lib/zabbix/ssh_keys:ro \
  --restart=always \
  zabbix-server-nginx-php
```

#### 2. 使用源码自行定制构建.

```
git clone https://github.com/airforce-captain/docker/tree/master/zabbix-server-nginx-php
cd zabbix-server-nginx-php
docker build -t zabbix-server-nginx-php .
```
