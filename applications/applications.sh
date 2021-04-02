#! /bin/sh

# dnf install -y httpd-tools certbot

apt install -y docker.io apache2-utils
# systemctl start docker # Seems to start automagically when docker cli is used

# Load use-case specific, secret variables into the session
eval $(<./.env.private)
# Generate the compose environment file
cat ./.env.tpl | envsubst > .env


mkdir -p ${BASE_DATA_LOCATION}/{letsencrypt,nextcloud,website,proxy,ttrss};
mkdir -p {$NEXTCLOUD_HOST_WEB_DIR,$NEXTCLOUD_HOST_DB_DIR}

# Prepare website files
yes | cp ./www/* "${BASE_DATA_LOCATION}/website" ;
cat ./www/index.html | envsubst > "${BASE_DATA_LOCATION}/website/index.html" ;

# TODO: remove this, not sure traefik even supports hybrid configuration methods and we're definitely preferring the docker provider
# TODO: rework the traefik static config for secure TLS only
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

# Clear the session variables?
# exec bash -l
