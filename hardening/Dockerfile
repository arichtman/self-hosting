
FROM centos:7

# Install packages and role
RUN yum install -y ansible ansible-galaxy git \
    && ansible-galaxy install git+https://github.com/openstack/ansible-hardening 

COPY ./hosts /etc/ansible
COPY ./playbook.yml /tmp

ENTRYPOINT [ ansible-playbook ]
CMD [ "-i", "/etc/ansible/hosts", "/tmp/playbook.yml"]
