#!/bin/sh

cd $HOME

mkdir -m 0700 .ssh
ssh-keygen -q -f .ssh/id_rsa -N ''
cat .ssh/id_rsa.pub >>.ssh/authorized_keys

cat <<EOF >>.ssh/config
Host master.internal
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentityFile ~/.ssh/id_rsa
  IdentitiesOnly yes
  LogLevel FATAL
EOF

chmod 0600 .ssh/authorized_keys .ssh/config

git clone -b openshift-ansible-3.0.13-1 https://github.com/openshift/openshift-ansible
ansible-playbook openshift-ansible/playbooks/byo/config.yml
