FROM nginx:alpine
# COPY configs/nginx.conf /etc/nginx/conf.d/default.conf 
COPY configs/nginx.conf /etc/nginx/templates/default.conf.template 
# COPY scripts/nginx.sh /entrypoint.sh
# RUN chmod 755 /entrypoint.sh
# CMD ["/entrypoint.sh"]
