#! /bin/bash

# Install latest, greatest, and needest
yum install epel-release -y # Repo must be installed before dnf
yum install dnf -y

dnf update -y
dnf upgrade -y
dnf install -y python36 tar

# Install a handy alias. I suspect as we move away from root this will come out.
printf "\nalias python=python3" >> ~/.bashrc