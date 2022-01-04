FROM blockstack/stacks-blockchain:2.05.0.0.0
COPY configs/Stacks-*.toml /stacks-blockchain/
COPY configs/nginx.conf /etc/nginx/http.d/default.conf 
RUN apk add nginx

EXPOSE 80 20443 20444