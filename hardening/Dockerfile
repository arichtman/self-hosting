FROM centos:7

# Install packages and role
RUN dnf install ansible ansible-galaxy -y \
    && ansible-galaxy install git+https://github.com/openstack/ansible-hardening 

COPY ./hardening/hosts /etc/ansible
COPY ./hardening/playbook.yml /tmp

ENTRYPOINT [ ansible-playbook ]
CMD [ "-i", "/etc/ansible/hosts", "/tmp/playbook.yml"]