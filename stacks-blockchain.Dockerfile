ARG STACKS_BLOCKCHAIN_VERSION=2.05.0.1.0


FROM blockstack/stacks-blockchain:${STACKS_BLOCKCHAIN_VERSION}
ARG STACKS_NETWORK=mainnet
ARG LOG_DIR=/var/log/
ARG STACKS_SVC_DIR=/etc/service

ENV STACKS_NETWORK=${STACKS_NETWORK}

RUN apk add \
    nginx \
    runit \
    && mkdir -p \
    /root/stacks-blockchain/data \
    ${STACKS_SVC_DIR}/stacks-blockchain \
    ${STACKS_SVC_DIR}/nginx \
    ${STACKS_SVC_DIR}/nginx/log \
    ${LOG_DIR}/nginx/log


COPY configs/nginx-stacks.conf /etc/nginx/http.d/default.conf 
COPY configs/Stacks-*.toml /stacks-blockchain/
COPY unit-files/run/stacks-blockchain ${STACKS_SVC_DIR}/stacks-blockchain/run
COPY unit-files/run/nginx ${STACKS_SVC_DIR}/nginx/run
COPY unit-files/log/nginx ${STACKS_SVC_DIR}/nginx/log/run
COPY scripts/entrypoint.sh /docker-entrypoint.sh

RUN chmod 755 \
    /docker-entrypoint.sh \
    ${STACKS_SVC_DIR}/stacks-blockchain/run \
    ${STACKS_SVC_DIR}/nginx/run \
    ${STACKS_SVC_DIR}/nginx/log/run

CMD /docker-entrypoint.sh
