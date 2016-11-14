[![](https://images.microbadger.com/badges/image/qq58945591/kibana.svg)](https://microbadger.com/images/qq58945591/kibana "Get your own image badge on microbadger.com")
# 关于本镜像

ELK官方使用debian做为系统底层,导致image体积很大,通过改造使用轻量级alpine linux作为系统底层,体积缩小至原来的一半.

### 如何使用?

拉取镜像:

```
docker pull qq58945591/kibana
```

运行容器,默认监听端口在5601,并且必须要指定elasticsearch的位置:

```
docker run --name kibana --link some-elasticsearch:elasticsearch -p 5601:5601 -d kibana
```

也可以使用环境变量:

```
docker run --name kibana -e ELASTICSEARCH_URL=http://some-elasticsearch:9200 -p 5601:5601 -d kibana
```
