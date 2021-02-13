#! /bin/sh

dnf install -y httpd-tools certbot # certbot-dns-route53 <= Need to test this is needed - I think we're using TLS challenge instead of DNS so no need for aws modules

get_env()
{
    set -a;
    source .env;
    set +a;
};

get_env

make_directories()
{
    mkdir -p ${BASE_DATA_LOCATION}/{letsencrypt,nextcloud,website,proxy,ttrss};
    mkdir -p {$NEXTCLOUD_HOST_WEB_DIR,$NEXTCLOUD_HOST_DB_DIR}
}

make_directories

cp ./www/* "${BASE_DATA_LOCATION}/website";

config_traefik()
{
    # There's definitely nicer approaches to shell templating than this
    cat ./traefik.yaml.tpl | envsubst > "${BASE_DATA_LOCATION}/proxy/traefik.yaml"
}

config_traefik

CERT_DETAILS_FILE="${BASE_DATA_LOCATION}/letsencrypt/acme.json";
chmod 600 $CERT_DETAILS_FILE >> $CERT_DETAILS_FILE;

docker-compose up -d;

# Unfortunately some NextCloud database indices are missing on installation (it's deliberate)
# We will wait till it is confirmed running and then issue the command to fix
while ! docker-compose logs nextcloud | grep "Command line: 'apache2 -D FOREGROUND'" ; do
  sleep 10;
done

docker-compose exec -u www-data nextcloud php occ --no-interaction --quiet db:add-missing-indices
docker-compose exec -u www-data nextcloud php occ --no-interaction --quiet db:convert-filecache-bigint

# For development
# export -f get_env
# alias nuke="docker-compose down; rm -rf "${BASE_DATA_LOCATION}/nextcloud"; make_directories ; cat ./traefik.yaml.tpl | envsubst > "${BASE_DATA_LOCATION}/proxy/traefik.yaml"; get_env; sleep 5; docker-compose up -d"

# alias redo="docker-compose down; config_traefik ; get_env; sleep 1; docker-compose up -d"
