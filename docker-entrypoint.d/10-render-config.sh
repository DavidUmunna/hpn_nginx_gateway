#!/bin/sh
set -eu

envsubst '${BACKEND_UPSTREAM_URL}' \
  < /etc/nginx/templates/default.conf.template \
  > /etc/nginx/conf.d/default.conf