ARG STACKS_API_VERSION=3.0.1

FROM hirosystems/stacks-blockchain-api:${STACKS_API_VERSION} 

ARG STACKS_NETWORK=mainnet
ARG LOG_DIR=/var/log/
ARG STACKS_SVC_DIR=/etc/service
ARG STACKS_BLOCKCHAIN_API_PORT=3999
ARG STACKS_CORE_EVENT_PORT=3700
ARG V2_POX_MIN_AMOUNT_USTX=90000000260
ARG STACKS_CORE_RPC_PORT=20443
ARG STACKS_CORE_P2P_PORT=20444

ENV STACKS_NETWORK=${STACKS_NETWORK}
ENV STACKS_CORE_EVENT_PORT=${STACKS_CORE_EVENT_PORT}
ENV STACKS_CORE_EVENT_HOST=127.0.0.1
ENV STACKS_BLOCKCHAIN_API_PORT=${STACKS_BLOCKCHAIN_API_PORT}
ENV STACKS_BLOCKCHAIN_API_HOST=0.0.0.0
ENV STACKS_CORE_RPC_HOST=127.0.0.1
ENV STACKS_CORE_RPC_PORT=${STACKS_CORE_RPC_PORT}
ENV STACKS_CORE_P2P_PORT=${STACKS_CORE_P2P_PORT}
ENV V2_POX_MIN_AMOUNT_USTX=${V2_POX_MIN_AMOUNT_USTX}

RUN apk add \
    nginx \
    runit \
    && mkdir -p \
    /root/stacks-blockchain/data \
    ${STACKS_SVC_DIR}/stacks-blockchain-api \
    ${STACKS_SVC_DIR}/nginx \
    ${STACKS_SVC_DIR}/nginx/log \
    ${LOG_DIR}/nginx/log


COPY configs/nginx-api.conf /etc/nginx/http.d/default.conf 
COPY configs/Stacks-*.toml /stacks-blockchain/
COPY unit-files/run/stacks-blockchain-api ${STACKS_SVC_DIR}/stacks-blockchain-api/run
COPY unit-files/run/nginx ${STACKS_SVC_DIR}/nginx/run
COPY unit-files/log/nginx ${STACKS_SVC_DIR}/nginx/log/run
COPY scripts/entrypoint.sh /docker-entrypoint.sh
COPY scripts/setup-bns.sh /setup-bns.sh

RUN chmod 755 \
    /docker-entrypoint.sh \
    /setup-bns.sh \
    ${STACKS_SVC_DIR}/stacks-blockchain-api/run \
    ${STACKS_SVC_DIR}/nginx/run \
    ${STACKS_SVC_DIR}/nginx/log/run

CMD /docker-entrypoint.sh
