# FROM nginx:alpine
# ARG API_DOMAIN
# ENV API_DOMAIN=${API_DOMAIN}

# COPY configs/nginx.conf /etc/nginx/conf.d/default.conf 
# COPY scripts/nginx-update_proxy.sh /docker-entrypoint.d/40-update-proxy.sh
# RUN chmod 755 \
#     /docker-entrypoint.d/40-update-proxy.sh

# EXPOSE 80
FROM alpine
ARG STACKS_SVC_DIR=/etc/service
COPY configs/nginx.conf /etc/nginx/http.d/default.conf
COPY scripts/nginx.sh /docker-entrypoint.sh
COPY unit-files/run/nginx ${STACKS_SVC_DIR}/nginx/run

RUN apk add \
    nginx \
    runit \
    && mkdir -p \
    ${STACKS_SVC_DIR}/nginx \
    && chmod 755 \
    /docker-entrypoint.sh \
    ${STACKS_SVC_DIR}/nginx/run


EXPOSE 80
CMD /docker-entrypoint.sh