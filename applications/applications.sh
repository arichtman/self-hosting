#! /bin/sh

source .env

dnf install -y httpd-tools cargo certbot certbot-dns-route53
cargo install toml-cli yj #may not need to install toml-cli

# may just need temporary addition to path if uninstalling later
# consider building a docker image for this setup if most is unneeded for operations
printf "\nPATH=\$PATH:/root/.cargo/bin\n" >> ~/.bashrc

# remove $PATH duplicate entries
printf "\nPATH=\$(echo -n \$PATH | awk -v RS=: '!(\$0 in a) {a[\$0]; printf(\"%%s%%s\", length(a) > 1 ? \":\" : \"\", \$0)}')\n" >> ~/.bashrc
exec bash -l

# need to see about native yaml support or dynamic config options. All this means nothing atm cos we can't convert back to toml
toml get ./applications/traefik.toml . | yj -jy > ./applications/traefik.yaml

TRAEFIK_PASSWORD_HASHED=$(htpasswd -nb admin ${TRAEFIK_PASSWORD})
yq w -i ./applications/traefik.yaml entryPoints.dashboard.auth.basic.users[0] $TRAEFIK_PASSWORD_HASHED
yq w -i ./applications/traefik.yaml docker.domain $MY_DOMAIN
yq w -i ./applications/traefik.yaml acme.email $MY_EMAIL

#this is still super important tho
mkdir -p $BASE_DATA_LOCATION/{database,letsencrypt,nextcloud};
touch $BASE_DATA_LOCATION/letsencrypt/acme.json;
chmod 600 $BASE_DATA_LOCATION/letsencrypt/acme.json;

# in progress
# cat ./postgres-init.sql  | envsubst > ./postgres.sql

# Somewhere along the line I attached a volume and mounted it to /data as well as added floating IP and added it to /etc/sysconfig/network-scripts/ifcfg-eth0:1
# All commands pretty much directly pulled from Hetzner's contextual help

docker-compose up -d;

#docker-compose down; source .env; sleep 1; docker-compose up -d