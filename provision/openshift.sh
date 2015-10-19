#!/bin/sh

cd $HOME

ssh-keygen -f .ssh/id_rsa -N ''
for host in \
    master.192.168.133.10.xip.io \
    node.192.168.133.11.xip.io;
do
    ssh-copy-id vagrant@${host}
done

git clone -b v3.0.2-1 https://github.com/openshift/openshift-ansible
ansible-playbook openshift-ansible/playbooks/byo/config.yml
