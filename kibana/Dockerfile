FROM alpine:latest

MAINTAINER YougnMan <bushengquan@eastspider.com>

LABEL description="使用轻量级alpine linux重新打包image."

ENV GOSU_VERSION 1.10
RUN set -x \
    && sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk add --no-cache --virtual .gosu-deps \
        dpkg \
        gnupg \
        openssl 
#    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
#    && 
#    && chmod +x /usr/local/bin/gosu \
#    && gosu nobody true 

COPY gosu /usr/local/bin/gosu

ENV KIBANA_MAJOR 5.0
ENV KIBANA_VERSION 5.3.0

RUN set -x \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true \
	&& wget -O /usr/share/kibana-${KIBANA_VERSION}.tar.gz https://artifacts.elastic.co/downloads/kibana/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz \
	&& cd /usr/share \
	&& tar xf kibana-${KIBANA_VERSION}.tar.gz \
	&& mv kibana-${KIBANA_VERSION}-linux-x86_64 kibana \
	&& sed -ri "s!^(\#\s*)?(server\.host:).*!\2 '0.0.0.0'!" /usr/share/kibana/config/kibana.yml \
	&& grep -q "^server\.host: '0.0.0.0'\$" /usr/share/kibana/config/kibana.yml \
	&& sed -ri "s!^(\#\s*)?(elasticsearch\.url:).*!\2 'http://elasticsearch:9200'!" /usr/share/kibana/config/kibana.yml \
	&& grep -q "^elasticsearch\.url: 'http://elasticsearch:9200'\$" /usr/share/kibana/config/kibana.yml \
	&& apk add --no-cache \
		nodejs \
		bash \
		tini \
	&&addgroup kibana \
            && adduser -S \
                    -D -G kibana \
                    -h /usr/share/kibana/ \
                kibana \
            && chown -R kibana:kibana /usr/share/kibana \
	&& apk del .gosu-deps \
	&& rm -rf /usr/share/kibana/node \
	&& rm -f /usr/share/kibana-${KIBANA_VERSION}.tar.gz

ENV PATH /usr/share/kibana/bin:$PATH

COPY docker-entrypoint.sh /

EXPOSE 5601

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["kibana"]
