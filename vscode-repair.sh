#! /bin/bash

# This script repairs a botched VSCode Server install.
# Bad installs seem to triggered by trying to Remote-SSH before the tar binary was available in PATH. git binary may also be expected.
# Best mitigation is simply installing the packages before attempting to connect but I went down the rabbit hole so I'm keeping it.

# If this folder exists a VSCode Server install has been attempted already. HASH=$(ls /root/.vscode-server/bin/ | head -n 1)
if [ $HASH ]
then
FOLDER="~/.vscode-server/bin/${HASH}"
curl --create-dirs -L "https://update.code.visualstudio.com/commit:${HASH}/server-linux-x64/stable" -o "${FOLDER}/vscode-server-linux-x64.tar.gz"
cd $FOLDER
tar -xvzf vscode-server-linux-x64.tar.gz --strip-components 1
fi

printf "\n\n***************\nYou may now use VSCode Remote-SSH extension\n***************\n"
