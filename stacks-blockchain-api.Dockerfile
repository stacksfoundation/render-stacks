FROM hirosystems/stacks-blockchain-api:1.0.4
COPY configs/nginx-api.conf /etc/nginx/http.d/default.conf 
COPY scripts/start-api.sh /start
RUN apk add nginx && chmod 755 /start
EXPOSE 80 3700 3999

CMD "/start"