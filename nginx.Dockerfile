FROM nginx:alpine
ARG API_DOMAIN
ENV API_DOMAIN=${API_DOMAIN}

COPY configs/nginx.conf /etc/nginx/conf.d/default.conf 
COPY scripts/nginx-update_proxy.sh /docker-entrypoint.d/40-update-proxy.sh
RUN chmod 755 \
    /docker-entrypoint.d/40-update-proxy.sh

EXPOSE 80
