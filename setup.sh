#! /bin/bash

# Arguments: 1, IP/URI to server
# Assumptions: Working location includes secrets file

jq -r .hetzner.ssh.privateKey ./secrets.json > ~/.ssh/hetzner

ssh "root@${0}" -i hetzner
dnf install -y python36
alias python=python3
pip install hcloud