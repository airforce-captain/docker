#!/usr/bin/env sh
set -e

#start nginx
/usr/sbin/nginx

exec $@
