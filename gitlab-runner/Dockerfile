FROM alpine

MAINTAINER YougnMan <bushengquan@eastspider.com>

LABEL description="这个是基于gitlab官方的Dockerfile来build的image,增加一些额外需要的软件包,测试中."

RUN apk --no-cache update && apk add --update \
		bash \
		ca-certificates \
		git \
		openssl \
		wget \
    		python \
    		bzip2 \
    		xz \
    		rsync

RUN wget -q -O /usr/bin/gitlab-ci-multi-runner https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-ci-multi-runner-linux-amd64 && \
	chmod +x /usr/bin/gitlab-ci-multi-runner && \
	ln -s /usr/bin/gitlab-ci-multi-runner /usr/bin/gitlab-runner && \
	wget -q https://github.com/docker/machine/releases/download/v0.7.0/docker-machine-Linux-x86_64 -O /usr/bin/docker-machine && \
	chmod +x /usr/bin/docker-machine && \
	mkdir -p /etc/gitlab-runner/certs && \
	chmod -R 700 /etc/gitlab-runner

ADD entrypoint /
RUN chmod +x /entrypoint

VOLUME ["/etc/gitlab-runner"]
ENTRYPOINT ["/entrypoint"]
CMD ["run"]
