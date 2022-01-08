#!/usr/bin/env sh
export SERVICE_FQDN=$(nslookup $SERVICE_NAME | grep Name | awk '{print $2}')
export SERVICE_PORT=$STACKS_BLOCKCHAIN_API_PORT
export NAMESERVER=$(cat /etc/resolv.conf | grep "nameserver" | head -n1 | awk '{print $2}')

/docker-entrypoint.sh "$@"


# echo "Checking for env var API_SERVICE_NAME"
# if [ ! -z "${API_SERVICE_NAME}" ]; then
#     echo "Editing nginx config file for %%API_SERVICE_NAME%%, replace with ${API_SERVICE_NAME}"
#     sed -i -e "s|%%API_SERVICE_NAME%%|${API_SERVICE_NAME}|g" /etc/nginx/conf.d/default.conf
# fi