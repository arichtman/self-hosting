#! /bin/sh

. .env

dnf install -y httpd-tools cargo certbot certbot-dns-route53
cargo install toml-cli yj

# may just need temporary addition to path if uninstalling later
# consider building a docker image for this setup if most is unneeded for operations
printf "\nPATH=\$PATH:/root/.cargo/bin\n" >> ~/.bashrc

# remove $PATH duplicate entries
printf "\nPATH=\$(echo -n \$PATH | awk -v RS=: '!(\$0 in a) {a[\$0]; printf(\"%%s%%s\", length(a) > 1 ? \":\" : \"\", \$0)}')\n" >> ~/.bashrc
exec bash -l

toml get ./applications/traefik.toml . | yj -jy > ./applications/traefik.yaml

PWD_STRING=$(htpasswd -nb admin $PASSWORD)
yq w -i ./applications/traefik.yaml entryPoints.dashboard.auth.basic.users[0] $PWD_STRING
yq w -i ./applications/traefik.yaml docker.domain $MY_DOMAIN
yq w -i ./applications/traefik.yaml acme.email $MY_EMAIL

docker network create $DEFAULT_NETWORK
mkdir -p /etc/traefik
touch /etc/traefik/acme.json
chmod 600 /etc/traefik/acme.json

docker run -d -v /var/run/docker.sock:/var/run/docker.sock \
  -v $PWD/traefik.toml:/etc/traefik.toml -v $PWD/acme.json:/etc/acme.json \
  -p 80:80 -p 443:443 \
  -l traefik.frontend.rule=Host:$MY_DOMAIN -l traefik.port=8080 \
  --network $DEFAULT_NETWORK --name traefik \
  traefik:v2.3

docker container kill traefik; docker container rm traefik

docker-compose -f ./proxy-docker-compose.yml up -d
