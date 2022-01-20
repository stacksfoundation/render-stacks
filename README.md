# Stacks Blockchain on Render

This repo makes it possible to spin up an instance of the [stacks-blockchain](https://github.com/blockstack/stacks-blockchain) and [stacks-blockchain-api](https://github.com/hirosystems/stacks-blockchain-api) on the hosted [render.com](https://render.com) service.

To get started, you should [register for a render account](https://dashboard.render.com/register) and get familiar with the [documentation for render](https://render.com/docs).

Once you've registered, hit this big blue button, and select the network mode you want from the branches drop down (mainnet, testnet, mocknet)


[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy?repo=https://github.com/wileyj/render-stacks&branch=master)

### Important considerations 
One thing to note is that with the free-tier plan, it's **possible** to run this with some modifications (mainly to the persistent disks and database), but it's **NOT recommended**


## Components

This project is using render.com's infrastructure as code system, called blueprints. The blueprint is similar in nature to what you might see with a docker compose set up. Each service is a block of YAML. Read below to learn about each one.

### stacks-blockchain

This is the stacks-blockchain container, built from the [officially released docker image](https://hub.docker.com/r/blockstack/stacks-blockchain/tags)

Some additional components were added to make the startup work within render's platform (there is an nginx proxy in front of `stacks-blockchain`)

Note that this instance is unreachable on the P2P port 20444 from external neighbors, but the HTTP endpoint will be available over port `80` once the port opens (on first sync, this can take a while).

This container is built from [stacks-blockchain.Dockerfile](./stacks-blockchain.Dockerfile) and uses runit to start the 2 services (nginx, stacks-blockchain), with the [service script](./unit-files/run/stacks-blockchain) performing a `sed` replacement for the `event-observer` config directive before starting the service. 

The nginx service itself is a very [simple setup](./configs/nginx-stacks.conf) - `/status` returns a `200` for the render health check, and nginx proxies / to `localhost:20443` (it may take sometime before this port is open).

---

### stacks-blockchain-api
This is the stacks-blockchain API container, built from the [officially released docker image](https://hub.docker.com/r/hirosystems/stacks-blockchain-api/tags)

As with the `stacks-blockchain` container, some additional components were added to make the startup work within render's platform (there is an nginx proxy in front of stacks-blockchain-api)

In render, this means that the API's event-observer is running internally on port `3700`, and the HTTP interface is on `3999`, with an nginx proxy over port `80` to the HTTP endpoint (when it's available - dependent on `<stacks-blockchain>/v2/info` ). 

The container that is built from [stacks-blockchain-api.Dockerfile](./stacks-blockchain-api.Dockerfile) uses runit to start the 2 services (nginx, stacks-blockchain-api).

Nginx itself is a very [simple setup](./configs/nginx-api.conf) - `/status` returns a `200` for the render health check, and nginx proxies / to `localhost:3999`. 

---

### postgres

Using the [render.yaml](./render.yaml) file, this spins up a managed instance of postgres. Currently it's open to the world and the password is randomly generated. 

IP allowlist can be added to the `render.yaml` to restrict access further. 

---

### nginx

The only publicly accessible service, this container acts as a proxy for the API (both /`extended/v1` and `/v2` endpoints)

During startup, it's not uncommon to see this service take a while before the root domain is available. 

During this time, though, `/status` will respond with `200 OK` to satisfy the health checks for render. 

The [default config](configs/nginx-default.conf) is generic and only exposes `/status` for the render healtcheck. The [entrypoint script](scripts/nginx.sh) is periodically checking the `<stacks-blockchain-instance>/extended/v1/status` endpoint for a `200` response. \
Once the API is serving requests, an envsubst is run from the [entrypoint script](scripts/nginx.sh) on the [config](./configs/nginx.conf) and nginx is reloaded with the new config enabled. 
 
---

## Deployment
Fork this repo and update [render.yaml](./render.yaml) to your liking, or use the big blue **Deploy to Render** button above


