FROM hirosystems/stacks-blockchain-api:1.0.4
COPY configs/nginx.conf /etc/nginx/http.d/default.conf 
RUN apk add nginx
EXPOSE 80 3700 3999