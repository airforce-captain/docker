FROM alpine:latest

MAINTAINER YougnMan <bushengquan@eastspider.com>

LABEL description="使用轻量级alpine linux重新打包image,自定义logstash配置的docker image, 增加了配置nginx与postfix的自定义日志格式匹配."

ENV GOSU_VERSION 1.10
RUN set -x \
    && apk add --no-cache --virtual .gosu-deps \
        dpkg \
        gnupg \
        openssl \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true 

#install jdk,bash,libzmq
# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
RUN { \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
	} > /usr/local/bin/docker-java-home \
	&& chmod +x /usr/local/bin/docker-java-home
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk/jre
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin

ENV JAVA_VERSION 8u92
ENV JAVA_ALPINE_VERSION 8.111.14-r1

RUN set -x \
	&& apk add --no-cache \
		openjdk8-jre="$JAVA_ALPINE_VERSION" \
		libzmq \
		bash \
	&& [ "$JAVA_HOME" = "$(docker-java-home)" ]


ENV LOGSTASH_VERSION 5.1.2
ENV PATH /usr/share/logstash/bin:$PATH
ENV LS_SETTINGS_DIR /etc/logstash

RUN mkdir -p /etc/logstash/conf.d/patterns.d \
	&& cd /usr/share \
	&& wget https://artifacts.elastic.co/downloads/logstash/logstash-${LOGSTASH_VERSION}.tar.gz \
	&& tar xf logstash-${LOGSTASH_VERSION}.tar.gz \
	&& mv logstash-${LOGSTASH_VERSION} logstash \
	&& cp /usr/share/logstash/config/* /etc/logstash/ \
	&& wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz -O /etc/logstash/conf.d/GeoLite2-City.mmdb.gz \
        && gzip -d /etc/logstash/conf.d/GeoLite2-City.mmdb.gz \
	&& if [ -f "$LS_SETTINGS_DIR/logstash.yml" ]; then \
                sed -ri 's!^(path.log|path.config):!#&!g' "$LS_SETTINGS_DIR/logstash.yml"; \
   	   fi \
	&&addgroup logstash \
            && adduser -S \
                    -D -G logstash \
                    -h /usr/share/logstash/ \
                logstash \
            && chown -R logstash:logstash /usr/share/logstash \
	&& apk del .gosu-deps \
	&& rm -f /usr/share/logstash-${LOGSTASH_VERSION}.tar.gz

#add configfile
ADD ./logstash.conf /etc/logstash/conf.d
ADD ./httpd.grok /etc/logstash/conf.d/patterns.d
ADD ./postfix.grok /etc/logstash/conf.d/patterns.d

COPY docker-entrypoint.sh /

EXPOSE 5124/tcp	5125/tcp

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["-e", "logstash"]
