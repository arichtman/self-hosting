#! /bin/bash

# If this folder exists a VSCode Server install has been attempted already. Often triggered by trying to Remote-SSH before tar binary was available in PATH
HASH=$(ls /root/.vscode-server/bin/ | head -n 1)
if [ $HASH ]
then
FOLDER="~/.vscode-server/bin/${HASH}"
curl --create-dirs -L "https://update.code.visualstudio.com/commit:${HASH}/server-linux-x64/stable" -o "${FOLDER}/vscode-server-linux-x64.tar.gz"
cd $FOLDER
tar -xvzf vscode-server-linux-x64.tar.gz --strip-components 1
fi
#TODO: Find cowsay/banner/figlet package for CentOS
printf "\n\n***************\nYou may now use VSCode Remote-SSH extension\n***************\n"