#! /bin/sh

apt install -y docker.io docker-compose apache2-utils
systemctl start docker

# Might need to review this, was really hoping for a github-aware package manager. I found *something* but this smells a little.
unlink /bin/envsubst && echo "\n" | hubapp install a8m/envsubst && ln -s /usr/local/bin/envsubst /usr/bin/envsubst

# Load use-case specific, secret variables into the session
set -a && eval "$(<./.env.private)" && set +a
# Generate the compose environment file
cat ./.env.tpl | envsubst > .env
set -a && eval "$(<./.env)" && set +a

mkdir -p ${BASE_DATA_LOCATION}/{letsencrypt,nextcloud,website,proxy,ttrss};
mkdir -p {$NEXTCLOUD_HOST_WEB_DIR,$NEXTCLOUD_HOST_DB_DIR}

# Prepare website files
cat ./www/index.tpl.html | envsubst > ./www/index.html
cp ./www/* "${BASE_DATA_LOCATION}/website"

CERT_DETAILS_FILE="${BASE_DATA_LOCATION}/letsencrypt/acme.json";
chmod 600 $CERT_DETAILS_FILE >> $CERT_DETAILS_FILE;

docker-compose up -d;

# Unfortunately some NextCloud database indices are missing on installation (it's deliberate)
# We will wait till it is confirmed running and then issue the command to fix
while ! docker-compose logs nextcloud | grep "Command line: 'apache2 -D FOREGROUND'" ; do
  sleep 10;
done

docker-compose exec -u www-data cloud php occ --no-interaction --quiet db:add-missing-indices
docker-compose exec -u www-data cloud php occ --no-interaction --quiet db:convert-filecache-bigint
