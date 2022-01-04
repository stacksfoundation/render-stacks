FROM blockstack/stacks-blockchain:2.05.0.0.0
ARG STACKS_NETWORK=mocknet
ENV STACKS_NETWORK=${STACKS_NETWORK}
COPY configs/Stacks-*.toml /stacks-blockchain/
COPY configs/nginx-stacks.conf /etc/nginx/http.d/default.conf 
COPY scripts/start-stacks.sh /start
RUN apk add nginx && chmod 755 /start

EXPOSE 80 20443 20444
CMD "/start"
