FROM alpine

MAINTAINER YougnMan <bushengquan@eastspider.com>

LABEL description="这个是基于gitlab官方的Dockerfile来build的image,增加一些额外需要的软件包,测试中."

RUN set -xe \
    	&& echo 'http://mirrors.ustc.edu.cn/alpine/v3.4/main' > /etc/apk/repositories \
    	&& echo 'http://mirrors.ustc.edu.cn/alpine/v3.4/community' >> /etc/apk/repositories \
	&& apk --no-cache update && apk add --update \
		bash \
		ca-certificates \
		git \
		openssl \
		wget \
    		python \
    		bzip2 \
    		xz \
    		rsync \
		openssh-client

RUN wget -q -O /usr/bin/gitlab-ci-multi-runner https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-ci-multi-runner-linux-amd64 && \
	chmod +x /usr/bin/gitlab-ci-multi-runner && \
	ln -s /usr/bin/gitlab-ci-multi-runner /usr/bin/gitlab-runner && \
	wget -q -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.1.1/dumb-init_1.1.1_amd64 && \
	chmod +x /usr/local/bin/dumb-init && \
	mkdir -p /etc/gitlab-runner/certs && \
	chmod -R 700 /etc/gitlab-runner

VOLUME ["/etc/gitlab-runner"]
ENTRYPOINT ["/usr/local/bin/dumb-init"]
CMD ["gitlab-ci-multi-runner", "run"]
