FROM alpine:latest
MAINTAINER Youngman <58945591@qq.com>

LABEL description="elasticsearch 使用轻量级alpine linux重新打包image,"

ENV GOSU_VERSION 1.10

COPY gosu /usr/local/bin/gosu

RUN set -x \
    && sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk add --no-cache --virtual .gosu-deps \
        dpkg \
        gnupg \
        openssl \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true 


ARG APK_FLAGS_COMMON="-q"
ARG APK_FLAGS_PERSISTANT="${APK_FLAGS_COMMON} --clean-protected --no-cache"
ARG APK_FLAGS_DEV="${APK_FLAGS_COMMON} --no-cache"
ENV TERM=xterm
ENV ELASTICSEARCH_VERSION="5.3.0"
ENV JAVA_ALPINE_VERSION 8.121.13-r0

RUN cd /usr/share/ \
    && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz \
    && tar xf elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz \
    && mv  elasticsearch-${ELASTICSEARCH_VERSION} elasticsearch \
    &&addgroup elasticsearch \
            && adduser -S \
                    -D -G elasticsearch \
                    -h /usr/share/elasticsearch/ \
                elasticsearch \
            && apk add ${APK_FLAGS_PERSISTANT} \
                  openjdk8-jre="$JAVA_ALPINE_VERSION" \
		  bash \
            && cd /usr/share/elasticsearch \
            && for path in \
                  ./data \
                  ./logs \
                  ./config \
                  ./config/scripts \
                ; do \
                  mkdir -p "$path"; \
                  chown -R elasticsearch:elasticsearch "$path"; done \
                  && apk del .gosu-deps \
		  && rm -f /usr/share/elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz

ENV PATH=$PATH:/usr/share/elasticsearch/bin
ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk
ENV JRE_HOME=$JAVA_HOME/jre
ENV CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JRE_HOME/lib/
ENV PATH=$PATH:$JAVA_HOME/bin/

COPY ./config/* /usr/share/elasticsearch/config/

COPY ./docker-entrypoint.sh /

WORKDIR /usr/share/elasticsearch

VOLUME ["/usr/share/elasticsearch/data"]

EXPOSE 9200 9300

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/usr/share/elasticsearch/bin/elasticsearch"]
