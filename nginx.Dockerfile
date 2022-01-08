FROM nginx:alpine
COPY configs/nginx.conf /srv/default.conf
COPY scripts/nginx.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
CMD ["/entrypoint.sh"]
