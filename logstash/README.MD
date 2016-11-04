#关于本镜像:

1. 自定义logstash配置的docker image, 增加了配置nginx与postfix的自定义日志格式匹配..
2. 增加了geoip数据库。可以方便调用ip数据库.

### 如何使用?

1. 拉取镜像.
```
docker pull qq58945591/logstash
```
2. 默认监听5124(maillog),5125(httpd) 两个来源日志.存入elasticsearch,索引名为logstash-maillog-* ,logstash-httpd-*
```
docker run -d --name logstash -p 5124:5124 -p 5125:5125 qq58945591/logstash -f /etc/logstash/conf.d/logstash.conf
```

### 或许你想自定义配置? 使用Dockerfile.

1. 编辑一个Dockerfile如下内容:
```
FROM logstash

COPY logstash.conf /some/config-dir/

CMD ["-f", "/some/config-dir/logstash.conf"]
```
然后执行build
```
docker build -t my-logstash .
```
