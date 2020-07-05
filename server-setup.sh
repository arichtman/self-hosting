#! /bin/bash

# Install latest, greatest, and needest
yum install epel-release -y # Repo must be installed before dnf
yum install dnf -y

dnf remove git* -y
dnf -y install https://packages.endpoint.com/rhel/7/os/x86_64/endpoint-repo-1.7-1.x86_64.rpm

dnf update -y
dnf upgrade -y
dnf install -y python36 tar git

# Install a handy alias. I suspect as we move away from root this will come out.
printf "\nalias python=python3" >> ~/.bashrc