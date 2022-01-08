#!/bin/sh
## copied from nginx:alpine startup script
# vim:sw=4:ts=4:et

set -e

if [ -z "${NGINX_ENTRYPOINT_QUIET_LOGS:-}" ]; then
    exec 3>&1
else
    exec 3>/dev/null
fi

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
## end copy

echo >&3 "Starting nginx"
nginx
echo >&3 "sleeping before reload"
sleep 10
sed -i -e "s|\$STACKS_BLOCKCHAIN_API_HOST|$STACKS_BLOCKCHAIN_API_HOST|g" /srv/default.conf
sed -i -e "s|\$STACKS_BLOCKCHAIN_API_PORT|$STACKS_BLOCKCHAIN_API_PORT|g" /srv/default.conf
sleep 10
echo >&3 "copy new config"
cp /srv/default.conf /etc/nginx/conf.d/default.conf 
echo >&3 "Reloading nginx"
nginx -s reload -g "daemon off;"

