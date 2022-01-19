#!/bin/sh
# vim:sw=4:ts=4:et

set -e

if [ -z "${NGINX_ENTRYPOINT_QUIET_LOGS:-}" ]; then
    exec 3>&1
else
    exec 3>/dev/null
fi

if [ "$1" = "nginx" -o "$1" = "nginx-debug" ]; then
    if /usr/bin/find "/docker-entrypoint.d/" -mindepth 1 -maxdepth 1 -type f -print -quit 2>/dev/null | read v; then
        echo >&3 "$0: /docker-entrypoint.d/ is not empty, will attempt to perform configuration"

        echo >&3 "$0: Looking for shell scripts in /docker-entrypoint.d/"
        find "/docker-entrypoint.d/" -follow -type f -print | sort -V | while read -r f; do
            case "$f" in
                *.sh)
                    if [ -x "$f" ]; then
                        echo >&3 "$0: Launching $f";
                        "$f"
                    else
                        # warn on shell scripts without exec bit
                        echo >&3 "$0: Ignoring $f, not executable";
                    fi
                    ;;
                *) echo >&3 "$0: Ignoring $f";;
            esac
        done

        echo >&3 "$0: Configuration complete; ready for start up"
    else
        echo >&3 "$0: No files found in /docker-entrypoint.d/, skipping configuration"
    fi
fi
 nginx &

echo >&3 "$0: Waiting for the API to come up"
COUNTER=0
until [ $(curl --write-out "%{http_code}\n" "http://${STACKS_BLOCKCHAIN_API_HOST}/extended/v1/status" --output output.txt --silent) -eq "200" ]; do
    COUNTER=$((COUNTER+1))
    echo "$0:$COUNTER) Waiting for 200 from: http://${STACKS_BLOCKCHAIN_API_HOST}/extended/v1/status"
    sleep 30
done
echo >&3 "$0"
echo >&e "$0: API is reachable ($STACKS_BLOCKCHAIN_API_HOST:$STACKS_BLOCKCHAIN_API_PORT)"
echo >&3 "$0: Running envsubst on /srv/nginx.conf >  /etc/nginx/conf.d/default.conf"
envsubst < /srv/nginx.conf > /etc/nginx/conf.d/default.conf
cat /etc/nginx/conf.d/default.conf
echo >&3 "$0 Sleep 5"
echo >&3 "$0"
sleep 5
echo >&3 "$0: Reloading nginx"

nginx -s reload &
echo >&3 "$0: ###########################################"
echo >&3 "$0: ###########################################"
while [[ 2 -gt 1 ]]; do
    sleep 60
done

