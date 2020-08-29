# Modified from philm/ansible_playbook

FROM gliderlabs/alpine:3.4

RUN \
    apk-install \
    curl \
    openssh-client \
    python \
    py-boto \
    py-dateutil \
    py-httplib2 \
    py-jinja2 \
    py-paramiko \
    py-pip \
    py-setuptools \
    py-yaml \
    tar \
    ansible \
    git && \
    pip install --upgrade pip python-keyczar && \
    rm -rf /var/cache/apk/*

RUN mkdir /etc/ansible/ /ansible
RUN echo "[local]" >> /etc/ansible/hosts && \
    echo "localhost" >> /etc/ansible/hosts

RUN \
    curl -fsSL https://releases.ansible.com/ansible/ansible-2.9.9.tar.gz -o ansible.tar.gz && \
    tar -xzf ansible.tar.gz -C ansible --strip-components 1 && \
    rm -fr ansible.tar.gz /ansible/docs /ansible/examples /ansible/packaging

RUN \
    mkdir -p ~/.ansible/roles/ && \
    git clone https://github.com/openstack/ansible-hardening ~/.ansible/roles/ansible-hardening

RUN mkdir -p /root/.ssh
# && touch /root/.ssh/known_hosts && touch /root/.ssh/authorized_keys

RUN ssh-keyscan -t rsa 127.0.0.1 >> /root/.ssh/known_hosts

USER root
RUN cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

# No idea why this fails and not about to get into it.
# RUN /usr/bin/ansible-galaxy install git+https://github.com/openstack/ansible-hardening

RUN mkdir -p /ansible/playbooks
WORKDIR /ansible/playbooks

ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING True
ENV PATH /ansible/bin:$PATH
ENV PYTHONPATH /ansible/lib

ENTRYPOINT ["ansible-playbook"]
