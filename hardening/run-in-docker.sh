#!/bin/sh

# Install packages
sudo dnf install -y docker ansible

sudo systemctl start docker
sudo systemctl enable docker

pushd /tmp/hardening
# Build image
docker build --tag hardening:latest .

# Run in background with localhost connectivity
docker container run hardening:latest --network="host" --name='hardening' --rm --detach
# Wait till finish
docker container wait 'hardening'
# Remove everything from docker
docker system prune --force

popd