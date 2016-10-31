FROM alpine:latest
MAINTAINER Youngman <58945591@qq.com>

ARG APK_FLAGS_COMMON="-q"
ARG APK_FLAGS_PERSISTANT="${APK_FLAGS_COMMON} --clean-protected --no-cache"
ARG APK_FLAGS_DEV="${APK_FLAGS_COMMON} --no-cache"
ARG DB_TYPE=mysql
ENV TERM=xterm
ENV MIBDIRS=/usr/share/snmp/mibs:/var/lib/zabbix/mibs MIBS=+ALL

RUN addgroup zabbix && \
    adduser -S \
            -D -G zabbix \
            -h /var/lib/zabbix/ \
        zabbix && \
    mkdir -p /etc/zabbix/ && \
    mkdir -p /etc/zabbix/web && \
    chown --quiet -R zabbix:root /etc/zabbix && \
    mkdir -p /var/lib/zabbix && \
    mkdir -p /var/lib/zabbix/enc && \
    mkdir -p /var/lib/zabbix/modules && \
    mkdir -p /var/lib/zabbix/ssh_keys && \
    mkdir -p /var/lib/zabbix/ssl && \
    mkdir -p /var/lib/zabbix/ssl/certs && \
    mkdir -p /var/lib/zabbix/ssl/keys && \
    mkdir -p /var/lib/zabbix/ssl/ssl_ca && \
    mkdir -p /usr/lib/zabbix/externalscripts && \
    mkdir -p /usr/lib/zabbix/alertscripts && \
    mkdir -p /var/lib/zabbix/mibs && \
    mkdir -p /var/lib/zabbix/snmptraps && \
    chown --quiet -R zabbix:root /var/lib/zabbix && \
    mkdir -p /usr/share/doc/zabbix-server-${DB_TYPE} && \
    echo 'http://192.168.0.252/alpine/v3.4/main' > /etc/apk/repositories && \
    echo 'http://192.168.0.252/alpine/v3.4/community' >> /etc/apk/repositories && \
    apk update && \
    apk add ${APK_FLAGS_PERSISTANT} \
            supervisor \
            bash \
            mariadb-client-libs \
            mariadb-client \
            fping \
	    ansible \
            py-pip \
            libxml2 \
            unixodbc \
            net-snmp-agent-libs \
            libldap \
            libcurl \
            openipmi-libs \
            openssh-client \
            nmap \
            sudo \
            libssh2 \
            nginx \
            php5-fpm \
            php5-mysqli \
            php5-ctype \
            php5-sockets \
            php5-gd \
            php5-gettext \
            php5-bcmath \
            php5-xmlreader \
            php5-ldap \
            php5-json \
            ttf-dejavu && \
    rm -rf /var/cache/apk/*

ARG MAJOR_VERSION=3.2
ARG ZBX_VERSION=${MAJOR_VERSION}.1
ARG ZBX_SOURCES=svn://svn.zabbix.com/tags/${ZBX_VERSION}/
ENV ZBX_VERSION=${ZBX_VERSION} ZBX_SOURCES=${ZBX_SOURCES} DB_TYPE=${DB_TYPE}

ADD conf/tmp/font-config /tmp/font-config

RUN apk add ${APK_FLAGS_DEV} --virtual build-dependencies \
            alpine-sdk \
            coreutils \
            gettext \
            automake \
            autoconf \
            mysql-dev \
            libxml2-dev \
            unixodbc-dev \
            net-snmp-dev \
            libssh2-dev \
            openipmi-dev \
            openldap-dev \
            curl-dev \
            subversion && \
    cd /tmp/ && \
    svn --quiet export ${ZBX_SOURCES} zabbix-${ZBX_VERSION} 1>/dev/null && \
    cd /tmp/zabbix-${ZBX_VERSION} && \
    zabbix_revision=`svn info ${ZBX_SOURCES} |grep "Last Changed Rev"|awk '{print $4;}'` && \
    sed -i "s/{ZABBIX_REVISION}/$zabbix_revision/g" include/version.h && \
    ./bootstrap.sh 1>/dev/null && \
    ./configure \
            --prefix=/usr \
            --silent \
            --sysconfdir=/etc/zabbix \
            --libdir=/usr/lib/zabbix \
            --datadir=/usr/lib \
            --enable-server \
	    --enable-ipv6 \
# Does not support stable iksemel library
#            --with-jabber \
            --with-net-snmp \
            --with-openipmi \
            --with-ssh2 \
            --with-libcurl \
            --with-unixodbc \
            --with-libxml2 \
            --with-openssl \
            --with-${DB_TYPE} && \
    make -j"$(nproc)" -s dbschema 1>/dev/null && \
    make -j"$(nproc)" -s 1>/dev/null && \
    cp src/zabbix_server/zabbix_server /usr/sbin/zabbix_server && \
    cp conf/zabbix_server.conf /etc/zabbix/zabbix_server.conf && \
    chown --quiet -R zabbix:root /etc/zabbix && \
    cp database/${DB_TYPE}/schema.sql /usr/share/doc/zabbix-server-${DB_TYPE}/ && \
    cp database/${DB_TYPE}/images.sql /usr/share/doc/zabbix-server-${DB_TYPE}/ && \
    cp database/${DB_TYPE}/data.sql /usr/share/doc/zabbix-server-${DB_TYPE}/ && \
    cd /tmp/ && \
    echo 'Defaults:zabbix    !requiretty' >> /etc/sudoers && \
    echo 'zabbix  ALL=(ALL)       NOPASSWD: ALL' >> /etc/sudoers && \
    rm -rf /tmp/zabbix-${ZBX_VERSION}/ && \
    cd /usr/share/ && \
    svn --quiet export ${ZBX_SOURCES}/frontends/php/ zabbix 1>/dev/null && \
    cd /usr/share/zabbix/ && \
    patch -p3 < /tmp/font-config && \
    rm /tmp/font-config && \
    rm -f conf/zabbix.conf.php && \
    rm -rf tests && \
    rm /usr/share/zabbix/fonts/DejaVuSans.ttf && \
    ./locale/make_mo.sh 2>/dev/null && \
    ln -s /usr/share/fonts/ttf-dejavu/DejaVuSans.ttf /usr/share/zabbix/fonts/graphfont.ttf && \
    apk del ${APK_FLAGS_COMMON} --purge \
            build-dependencies && \
    rm -rf /var/cache/apk/*

EXPOSE 10051/TCP 162/UDP 80/TCP 

WORKDIR /var/lib/zabbix

VOLUME ["/usr/lib/zabbix/alertscripts", "/usr/lib/zabbix/externalscripts", "/var/lib/zabbix/enc", "/var/lib/zabbix/modules", "/var/lib/zabbix/ssh_keys"]
VOLUME ["/var/lib/zabbix/snmptraps", "/var/lib/zabbix/mibs"]

ADD conf/etc/supervisor/ /etc/supervisor/
ADD conf/etc/zabbix/nginx.conf /etc/nginx/conf.d/
ADD conf/etc/zabbix/web/zabbix.conf.php /etc/zabbix/web/
ADD conf/etc/nginx/nginx.conf /etc/nginx/
ADD conf/etc/php5/php-fpm.conf /etc/php5/
ADD conf/etc/php5/conf.d/99-zabbix.ini /etc/php5/conf.d/
ADD run_zabbix_component.sh /

ENTRYPOINT ["/bin/bash"]

CMD ["/run_zabbix_component.sh","server", "mysql", "nginx"]
