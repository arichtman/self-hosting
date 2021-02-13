#! /bin/bash

# Arguments: 1, IP/URI to server
# Assumptions: Working location includes secrets file

jq -r .hetzner.ssh.privateKey ./secrets.json > ~/.ssh/hetzner

ssh "root@${0}" -i hetzner
dnf install -y python36
alias python=python3


# Setup remote dev
# Update pre-requisites
dnf upgrade -y glibc libgcc libstdc++ python ca-certificates tar

HASH='c47d83b293181d9be64f27ff093689e8e7aed054'
FOLDER="~/.vscode-server/bin/${HASH}"
curl --create-dirs -L "https://update.code.visualstudio.com/commit:${HASH}/server-linux-x64/stable" -o "${FOLDER}/vscode-server-linux-x64.tar.gz"
cd $FOLDER
tar -xvzf vscode-server-linux-x64.tar.gz --strip-components 1