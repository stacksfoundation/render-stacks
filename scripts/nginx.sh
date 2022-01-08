#!/usr/bin/env sh
# export SERVICE_NAME=$(nslookup $STACKS_BLOCKCHAIN_API_HOST | grep Name | awk '{print $2}')
export SERVICE_NAME=$STACKS_BLOCKCHAIN_API_HOST
export SERVICE_PORT=$STACKS_BLOCKCHAIN_API_PORT
export NAMESERVER=$(cat /etc/resolv.conf | grep "nameserver" | head -n1 | awk '{print $2}')
# if [ -f "/tmp/default.conf" ]; then
#     sed -i -e "s|\$SERVICE_NAME|$SERVICE_NAME|g" /tmp/default.conf
#     sed -i -e "s|\$SERVICE_PORT|$SERVICE_PORT|g" /tmp/default.conf
#     sed -i -e "s|\$NAMESERVER|$NAMESERVER|g" /tmp/default.conf
#     mv /tmp/default.conf /etc/nginx/conf.d/default.conf
# fi
/docker-entrypoint.sh "$@"

# nginx -s reload


# echo "Checking for env var API_SERVICE_NAME"
# if [ ! -z "${API_SERVICE_NAME}" ]; then
#     echo "Editing nginx config file for %%API_SERVICE_NAME%%, replace with ${API_SERVICE_NAME}"
#     sed -i -e "s|%%API_SERVICE_NAME%%|${API_SERVICE_NAME}|g" /etc/nginx/conf.d/default.conf
# fi