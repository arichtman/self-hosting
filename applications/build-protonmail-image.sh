#!/bin/sh

pushd /var/tmp
# Build our docker image for ProtonMail bridge
git clone https://github.com/arichtman/hydroxide-docker.git --branch ft-2fa

cd ./hydroxide-docker

docker build . --build-arg SMTP_PORT=${PROTONMAIL_BRIDGE_SMTP_PORT} --build-arg IMAP_PORT=${PROTONMAIL_BRIDGE_IMAP_PORT} --build-arg PROTONMAIL_BRIDGE_VERSION=${PROTONMAIL_BRIDGE_VERSION} --tag "${PROTONMAIL_BRIDGE_IMAGE}:${PROTONMAIL_BRIDGE_VERSION}" --tag "${PROTONMAIL_BRIDGE_IMAGE_NAME}:latest"

popd
