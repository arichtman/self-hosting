#! /bin/bash

# Install latest and greatest
apt update
apt full-upgrade -y

apt install -y jq python3-pip git httpie
http https://raw.githubusercontent.com/warrensbox/hubapp/release/install.sh | bash

apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CC86BB64
add-apt-repository ppa:rmescandon/yq
apt update -y
apt install -y yq

echo "https://$SECRET_GIT_USERNAME_ENCODED:$SECRET_GIT_PASSWORD_ENCODED@github.com" > ~/.git-credentials

# Install a handy alias. I suspect as we move away from root this will come out.
printf "\nalias python=python3" >> ~/.bash_aliases
printf "\nalias pip=pip3" >> ~/.bash_aliases
printf "\nalias sl='cd'" >> ~/.bash_aliases
printf "\nalias cls='clear'" >> ~/.bash_aliases

yq shell-completion > /etc/bash_completion.d/yq
printf "\n. /etc/bash_completion.d/yq" >> ~/.bashrc

printf "\nset show-all-if-ambiguous on\n" >> ~/.inputrc

exec bash -l
