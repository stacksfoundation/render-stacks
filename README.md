# Stacks Blockchain on Render

**What is this?**\
This repo makes it possible to spin up an instance of the [stacks-blockchain](https://github.com/blockstack/stacks-blockchain) and [stacks-blockchain-api](https://github.com/hirosystems/stacks-blockchain-api) on the hosted [render.com](https://render.com) service. \
[Register for a render account](https://dashboard.render.com/register) \
[Docs for render](https://render.com/docs)


One thing to note is that with the free-tier plan, it's **possible** to run this with some modifications (mainly to the persistent disks), but it's **NOT recommended**



## Components
### stacks-blockchain
This is the stacks-blockchain container, built from the [officially released docker image](https://hub.docker.com/r/blockstack/stacks-blockchain/tags) \
Some additional components were added to make the startup work within render's platform (essentially there is an nginx proxy in front of stacks-blockchain)


### stacks-blockchain-api
This is the stacks-blockchain API container, built from the [officially released docker image](https://hub.docker.com/r/hirosystems/stacks-blockchain-api/tags) \
As with the stacks-blockchain container, some additional components were added to make the startup work within render's platform (essentially there is an nginx proxy in front of stacks-blockchain-api)


### postgres
Using the render.yaml file, this spins up a managed instance of postgres

### nginx
The only publicly accessible service, this container acts as a proxy for the API (both /`extended/v1` and `/v2` endpoints)
During startup, it's not uncommon to see this service take a while before the root domain works.  \
During this time though, `/status` will respond with `200 OK` to satisfy the health checks for render. 

## Deployment
Fork this repo and update [render.yaml](./render.yaml) to your liking, or use the button below to launch a render blueprint directly \
[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy?repo=https://github.com/wileyj/render-stacks&branch=master)

