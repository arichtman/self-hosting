#! /bin/sh

dnf install -y httpd-tools certbot # certbot-dns-route53 <= Need to test this is needed - I think we're using TLS challenge instead of DNS so no need for aws modules

get_env()
{
    set -a;
    source .env;
    set +a;
};

get_env

mkdir -p ${BASE_DATA_LOCATION}/{letsencrypt,nextcloud,website,proxy};
mkdir -p {$NEXTCLOUD_HOST_DATA_DIR,$NEXTCLOUD_HOST_WEB_DIR,$NEXTCLOUD_HOST_DB_DIR}

cp ./www/* "${BASE_DATA_LOCATION}/website";
# There's definitely nicer approaches to shell templating than this
cat ./traefik.yaml.tpl | envsubst > "${BASE_DATA_LOCATION}/proxy/traefik.yaml"

CERT_DETAILS_FILE="${BASE_DATA_LOCATION}/letsencrypt/acme.json";
chmod 600 $CERT_DETAILS_FILE >> $CERT_DETAILS_FILE;

# Somewhere along the line I attached a volume and mounted it to /data as well as added floating IP and added it to /etc/sysconfig/network-scripts/ifcfg-eth0:1
# All commands pretty much directly pulled from Hetzner's contextual help

docker-compose up -d;

# For development
# export -f get_env
# alias nuke="docker-compose down; rm -rf "${BASE_DATA_LOCATION}/nextcloud"; rm -rf ${BASE_DATA_LOCATION}/postgres; mkdir -p ${BASE_DATA_LOCATION}/postgres; mkdir -p {$NEXTCLOUD_HOST_DATA_DIR,$NEXTCLOUD_HOST_WEB_DIR,$NEXTCLOUD_HOST_DB_DIR}; get_env; sleep 1; docker-compose up -d"
# alias redo="docker-compose down; get_env; sleep 1; docker-compose up -d"
