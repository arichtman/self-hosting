#! /bin/sh
pushd /tmp/hardening

dnf install -y ansible
ansible-galaxy install git+https://github.com/openstack/ansible-hardening

ansible-playbook ./playbook.yml

popd