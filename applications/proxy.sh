#! /bin/sh

. .env

docker network create $DEFAULT_NETWORK
mkdir -p /etc/traefik
touch /etc/traefik/{traefik.toml,docker-compose.yml,acme.json,nginx.toml}
chmod 0600 /etc/traefik/acme.json

docker-compose -f ./proxy-docker-compose.yml up -d