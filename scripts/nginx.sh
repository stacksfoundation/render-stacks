#!/bin/sh
# vim:sw=4:ts=4:et

set -e

echo "Checking for env var API_SERVICE_NAME"
if [ ! -z "${API_SERVICE_NAME}" ]; then
    echo "Editing nginx config file for %%API_SERVICE_NAME%%, replace with ${API_SERVICE_NAME}"
    sed -i -e "s|%%API_SERVICE_NAME%%|${API_SERVICE_NAME}|g" /etc/nginx/http.d/default.conf
fi
runsvdir /etc/service

# echo "Start default /docker-entrypoint.sh"
# /docker-entrypoint.sh nginx
