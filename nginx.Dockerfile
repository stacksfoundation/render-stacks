FROM nginx:alpine
ARG API_DOMAIN
ENV API_DOMAIN=${API_DOMAIN}

COPY configs/nginx.conf /etc/nginx/http.d/default.conf 
COPY scripts/nginx.sh /new-entrypoint.sh

EXPOSE 80
CMD /new-entrypoint.sh
