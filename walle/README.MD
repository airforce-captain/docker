集成打包lnmp环境的walle-web部署工具,适合懒人们使用. 根据php docker官方Dockerfile配置修改,有问题可以反馈给我.

环境配置是:
PHP 5.6.23
NGINX 1.10.1
MariaDB 10.1.14

系统组件:
git nginx mysql gettext libmcrypt-dev icu-libs zlib-dev unzip subversion ansible openssh-client

php组件:
bcmath intl mbstring mcrypt mysqli opcache pdo_mysql


1. 运行命令example.
docker run -d --name walle-web -v /data/mysql:/opt/mysql qq5894591/walle-web

(注意:－v 是挂载一个本地目录到容器内做mysql的永久数据保存，否则在容器被销毁的时候，数据将丢失.冒号前面的路径是本地主机的目录,后面是容器的目录。修改本地主机的即可.另外可加参数--restart always 让容器在本地主机重启后会自动启动.)

2. 当walle-web 有更新的时候,重新pull镜像,运行就可以了,数据都是保存在本地指定的数据库目录.
