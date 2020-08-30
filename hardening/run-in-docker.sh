#!/bin/sh

# Install packages
dnf install -y docker

systemctl start docker
systemctl enable docker

pushd /tmp/hardening

ssh-keygen -t ed25519 -f /root/.ssh/id_rsa -P ""

# Build image
docker build --tag hardening:latest .
# Run with localhost connectivity
docker run --rm -it --network="host" -v "$(pwd):/ansible/playbooks" hardening playbook.yml

# Remove everything from docker
docker system prune --force

popd

git clone https://github.com/docker/docker-bench-security.git
./docker-bench-security/docker-bench-security.sh -b > benchmark.txt 2>/dev/nul