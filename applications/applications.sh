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
# All commands pretty much directly pulled from Hetzner's contextual help - need to add a TODO re doing this at server instantiation

docker-compose up -d;

# Unfortunately some NextCloud database indices are missing on installation (it's deliberate)
# We will wait till it is confirmed running and then issue the command to fix
while ! docker-compose logs nextcloud | grep "Command line: 'apache2 -D FOREGROUND'" ; do
  sleep 10;
done

docker-compose exec -u www-data nextcloud php occ --no-interaction --quiet db:add-missing-indices
docker-compose exec -u www-data nextcloud php occ --no-interaction --quiet db:convert-filecache-bigint

# TODO: Turn these into issues
# So we're pretty good for NextCloud but we're still leaking some info about our server and php
# Now normally you'd just amend the /etc/apache2/apache2.conf with ServerSignature Off and ServerTokens Prod
# but it appears cooked into the image so I've added Traefik middlewares to overwrite the header with a blank string
# hashtag notStupidItWorks
# Still on this topic with oc_sessionPassphrase: The 'secure' flag is not set on this cookie. There is no Cookie Prefix on this cookie. This is not a SameSite Cookie.
# Content-Security-Policy contains 'unsafe-inline' which is dangerous in the style-src directive.

# For development
# export -f get_env
# alias nuke="docker-compose down; rm -rf "${BASE_DATA_LOCATION}/nextcloud"; rm -rf ${BASE_DATA_LOCATION}/postgres; mkdir -p ${BASE_DATA_LOCATION}/postgres; mkdir -p {$NEXTCLOUD_HOST_DATA_DIR,$NEXTCLOUD_HOST_WEB_DIR,$NEXTCLOUD_HOST_DB_DIR}; get_env; sleep 1; docker-compose up -d"
# alias redo="docker-compose down; get_env; sleep 1; docker-compose up -d"
