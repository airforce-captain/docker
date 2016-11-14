[![](https://images.microbadger.com/badges/image/qq58945591/elasticsearch.svg)](https://microbadger.com/images/qq58945591/elasticsearch "Get your own image badge on microbadger.com")
# 关于本镜像.

ELK官方image使用了debian做基础镜像, 体积较为臃肿, 因此便有了改造的想法,通过改造后,体积只有官方镜像的一半大. 使用轻量alpine linux 作为基础.


## 如何使用?

1. 使用方法同官方镜像一样,但是官方默认配置只监听在本地端口,本镜像修改为监听所有.官方宣称是为了安全起见,如何取舍自己考虑,也可以挂载自定义配置文件替换默认配置.
特别标注一下, 从5.0开始,传递变量不使用-Des, 而是使用-E 加上key/value的键值参数,如-Enode.name=test_node

for example:
拉取镜像:

```
docker pull qq58945591/elasticsearch

```
启动es:

```
docker run -d --name es -p 9200:9200 -p 9300:9300 qq58945591/elasticsearch -Enode.name=SERVER1 -Ecluster.name=MY_CLUSTER
```


