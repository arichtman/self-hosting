#! /bin/bash

# Install latest, greatest, and needest
yum install epel-release -y # Repo must be installed before dnf
yum install dnf -y

dnf remove git* -y
dnf -y install https://packages.endpoint.com/rhel/7/os/x86_64/endpoint-repo-1.7-1.x86_64.rpm

dnf update -y
dnf upgrade -y
dnf install -y python3-devel tar git gcc jq snapd

dnf autoremove
dnf clean all

sudo systemctl enable --now snapd.socket

snap install yq

# Install a handy alias. I suspect as we move away from root this will come out.
printf "\nalias python=python3" >> ~/.bashrc
printf "\nalias pip=python3" >> ~/.bashrc
printf "\nalias sl='cd'" >> ~/.bashrc
printf "\nalias cls='clear'" >> ~/.bashrc
printf "\neval $(thefuck --alias)" >> ~./bashrc
printf "\nalias fu='fuck'" >> ~/.bashrc

yq shell-completion > /etc/bash_completion.d/yq

printf "\n. /etc/bash_completion.d/yq" >> ~/.bashrc

printf "\nset show-all-if-ambiguous on\n" >> ~/.inputrc

# remove $PATH duplicate entries
# May be a way to use %q here to handle the escaping
printf "\nPATH=\$(echo -n \$PATH | awk -v RS=: '!(\$0 in a) {a[\$0]; printf(\"%%s%%s\", length(a) > 1 ? \":\" : \"\", \$0)}')\n" >> ~/.bashrc

exec bash -l

pip install thefuck
