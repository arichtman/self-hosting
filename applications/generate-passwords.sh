#!/bin/bash

function generatePassword() {
    openssl rand -hex 16
}

POSTGRES_PASSWORD=$(generatePassword)
TRAEFIK_PASSWORD=$(generatePassword)

sed -i.bak \
    -e "s#POSTGRES_PASSWORD=.*#POSTGRES_PASSWORD=${POSTGRES_PASSWORD}#g" \
    -e "s#TRAEFIK_PASSWORD=.*#TRAEFIK_PASSWORD=${TRAEFIK_PASSWORD}#g" \
    "$(dirname "$0")/.env"
