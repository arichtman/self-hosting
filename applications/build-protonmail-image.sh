#!/bin/bash

pushd /var/tmp
# Build our docker image for ProtonMail bridge
git clone https://github.com/arichtman/hydroxide-docker.git --branch ft-2fa

cd ./hydroxide-docker

docker build . --build-arg APP_VERSION=${HYDROXIDE_VERSION} --tag "${HYDROXIDE_IMAGE_NAME}:${HYDROXIDE_VERSION}" --tag "${HYDROXIDE_IMAGE_NAME}:latest"

popd
rm -rf /var/tmp/hydroxide-docker