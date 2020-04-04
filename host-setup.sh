#! /bin/bash

dnf update -y
dnf upgrade -y
dnf install -y python36 tar
printf "\nalias python=python3" >> ~/.bashrc

# Setup remote dev
# Could just be missing tar package? Not sure but this works soo...

HASH=$(ls /root/.vscode-server/bin/ | head -n 1)
FOLDER="~/.vscode-server/bin/${HASH}"
curl --create-dirs -L "https://update.code.visualstudio.com/commit:${HASH}/server-linux-x64/stable" -o "${FOLDER}/vscode-server-linux-x64.tar.gz"
cd $FOLDER
tar -xvzf vscode-server-linux-x64.tar.gz --strip-components 1
#TODO: Find cowsay/banner/figlet package for CentOS
printf "\n\n***************\nYou may now use VSCode Remote-SSH extension\n***************"