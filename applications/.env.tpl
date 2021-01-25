
# Globals
BASE_DATA_LOCATION=${PRIVATE_BASE_DATA_LOCATION:=}
TOP_LEVEL_DOMAIN=${PRIVATE_TOP_LEVEL_DOMAIN:=}
DOCKER_SUBNET_CIDR=${PRIVATE_DOCKER_SUBNET_CIDR:=google.com}

# Traefik & TLS Configuration
TRAEFIK_DOCKER_IMAGE=${PRIVATE_TRAEFIK_DOCKER_IMAGE:=traefik:v2.3}
TRAEFIK_API_INSECURE_ENABLED=${PRIVATE_TRAEFIK_API_INSECURE_ENABLED:=false}
TRAEFIK_LETSENCRYPT_EMAIL=${PRIVATE_TRAEFIK_LETSENCRYPT_EMAIL:=ceo@google.com}
TRAEFIK_USER="${PRIVATE_TRAEFIK_USER:-admin}"
TRAEFIK_PASSWORD="${PRIVATE_TRAEFIK_PASSWORD:-pass}"

# Global Configuration
BASE_DATA_LOCATION=${PRIVATE_BASE_DATA_LOCATION-/var/}
TOP_LEVEL_DOMAIN="${PRIVATE_TOP_LEVEL_DOMAIN:-google.com}"
DOCKER_SUBNET_CIDR="${PRIVATE_DOCKER_SUBNET_CIDR:-172.0.0.0/8}"



# OAUTH

GOOGLE_CLIENT_ID=${PRIVATE_GOOGLE_CLIENT_ID:=*.apps.googleusercontent.com}
GOOGLE_CLIENT_SECRET=${PRIVATE_GOOGLE_CLIENT_SECRET:=}
OAUTH_SECRET=${PRIVATE_OAUTH_SECRET:=secret-nonce}

# Nextcloud Configuration
NEXTCLOUD_DOCKER_IMAGE=${PRIVATE_NEXTCLOUD_DOCKER_IMAGE:=nextcloud:21.0.1}
NEXTCLOUD_FQDN=${PRIVATE_NEXTCLOUD_FQDN:="cloud.$TOP_LEVEL_DOMAIN"}

NEXTCLOUD_HOST_WEB_DIR=${PRIVATE_NEXTCLOUD_HOST_WEB_DIR:=$BASE_DATA_LOCATION/nextcloud/html}

NEXTCLOUD_ADMIN_USER=${PRIVATE_NEXTCLOUD_ADMIN_USER:=nextcloud}
NEXTCLOUD_ADMIN_PASSWORD=${PRIVATE_NEXTCLOUD_ADMIN_PASSWORD:=nextcloud}

NEXTCLOUD_POSTGRES_DOCKER_IMAGE=${PRIVATE_NEXTCLOUD_POSTGRES_DOCKER_IMAGE:=postgres:13.2}
NEXTCLOUD_HOST_DB_DIR=${PRIVATE_NEXTCLOUD_HOST_DB_DIR:=$BASE_DATA_LOCATION/nextcloud/postgres}
NEXTCLOUD_POSTGRES_DB=${PRIVATE_NEXTCLOUD_POSTGRES_DB:=nextcloud}
NEXTCLOUD_POSTGRES_USER=${PRIVATE_NEXTCLOUD_POSTGRES_USER:=nextcloud}
NEXTCLOUD_POSTGRES_PASSWORD=${PRIVATE_NEXTCLOUD_POSTGRES_PASSWORD:=}

# Tiny Tiny RSS Configuration
TTRSS_HOST_DIR=${PRIVATE_TTRSS_HOST_DIR:=$BASE_DATA_LOCATION/ttrss}
TTRSS_HOST_DB_DIR=${PRIVATE_TTRSS_HOST_DB_DIR:=$BASE_DATA_LOCATION/ttrss/postgres}
TTRSS_POSTGRES_DB=${PRIVATE_TTRSS_POSTGRES_DB:=ttrss}
TTRSS_POSTGRES_USER=${PRIVATE_TTRSS_POSTGRES_USER:=ttrss}
TTRSS_POSTGRES_PASSWORD=${PRIVATE_TTRSS_POSTGRES_PASSWORD:=ttrss}

# These are broken but might not be in use
# TRAEFIK_PASSWORD_HASHED=${PRIVATE_TRAEFIK_PASSWORD_HASHED:=$( htpasswd -nbB "admin" "$TRAEFIK_PASSWORD") }
# TRAEFIK_PASSWORD_ESCAPED=${PRIVATE_TRAEFIK_PASSWORD_ESCAPED:=$( printf "%q" "$TRAEFIK_PASSWORD_HASHED") }
