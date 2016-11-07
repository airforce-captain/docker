#关于本镜像:

1. 自定义logstash配置的docker image, 增加了配置nginx与postfix的自定义日志格式匹配..
2. 增加了geoip数据库。可以方便调用ip数据库, 在logstash 5.0之后使用的数据库是GeoLite2-City.mmdb. 
3. 使用alpine linux作为系统底层, 减小image体积.

### 如何使用?

1. 拉取镜像.

```
docker pull qq58945591/logstash

```
2. 默认监听5124(maillog),5125(httpd) 两个来源日志.存入elasticsearch,索引名为logstash-maillog-* ,logstash-httpd-* , 默认使用rsyslog作为日志运输.需要修改nginx 的日志输出格式:

```
        log_format  main  '$remote_addr $host - $remote_user [$time_local] "$request" '
                '$status $body_bytes_sent "$http_referer" '
                '"$http_user_agent" ';
```

修改nginx的日志输出到rsyslog：

```
access_log syslog:server=192.168.10.1:514,facility=local6,tag=httpd,severity=info main;

```

修改/etc/rsyslog.conf,增加一个输出模版.

```
template(name="jsonTemplate"
     type="list"
     option.json="on") {
       constant(value="{")
         constant(value="\"timestamp\":\"")      property(name="timereported" dateFormat="rfc3339")
         constant(value="\",\"message\":\"")     property(name="rawmsg-after-pri")
         constant(value="\",\"host\":\"")        property(name="hostname")
         constant(value="\",\"severity\":\"")    property(name="syslogseverity-text")
         constant(value="\",\"facility\":\"")    property(name="syslogfacility-text")
         constant(value="\",\"program\":\"")   property(name="syslogtag")
       constant(value="\"}")
     }

```

光标移动到rsyslog.conf最后,加入过滤条件然后传送给logstash处理:

```
#只传送包含发送状态的日志.
if $syslogtag contains 'postfix' and $rawmsg-after-pri contains 'status=' and not ($msg contains 'connect from' and $ms
g contains 'disconnect from') then {
             mail.* @@172.23.254.218:5124;jsonTemplate
}
#只传送包含tag 为httpd的web记录.
if $syslogtag contains 'httpd' and $rawmsg-after-pri contains 'HTTP' then {
             local6.* @@172.23.254.218:5125;jsonTemplate
     }
```

3. 启动logstash, 默认输出到elaticsearch.

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
