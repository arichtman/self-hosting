#! /bin/sh

pushd ~
# Build our docker image for ProtonMail bridge
git clone https://github.com/sdelafond/docker-protonmail-bridge.git

cd ./docker-protonmail-bridge

curl https://protonmail.com/download/beta/protonmail-bridge_${PROTONMAIL_BRIDGE_VERSION}_amd64.deb -O
docker build . --build-arg SMTP_PORT=${PROTONMAIL_BRIDGE_SMTP_PORT} --build-arg IMAP_PORT=${PROTONMAIL_BRIDGE_IMAP_PORT} --build-arg PROTONMAIL_BRIDGE_VERSION=${PROTONMAIL_BRIDGE_VERSION} --tag ${PROTONMAIL_BRIDGE_IMAGE}

popd
