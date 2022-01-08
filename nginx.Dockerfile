FROM nginx:alpine
COPY configs/nginx.conf /etc/nginx/templates/default.conf.template
# COPY scripts/nginx.sh /entrypoint.sh
# RUN chmod 755 /entrypoint.sh
# CMD ["/entrypoint.sh", "nginx", "-g", "daemon off;"]

# FROM alpine
# ARG STACKS_SVC_DIR=/etc/service
# COPY configs/nginx.conf /etc/nginx/http.d/default.conf
# COPY scripts/entrypoint.sh /docker-entrypoint.sh
# COPY unit-files/run/nginx ${STACKS_SVC_DIR}/nginx/run

# RUN apk add \
#     nginx \
#     runit \
#     && mkdir -p \
#     ${STACKS_SVC_DIR}/nginx \
#     && chmod 755 \
#     /docker-entrypoint.sh \
#     ${STACKS_SVC_DIR}/nginx/run


# EXPOSE 80
# CMD /docker-entrypoint.sh