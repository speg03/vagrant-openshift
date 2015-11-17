#!/bin/sh

cd $HOME

ssh-keygen -f .ssh/id_rsa -N ''
ssh-copy-id vagrant@master.internal

git clone -b openshift-ansible-3.0.12-1 https://github.com/openshift/openshift-ansible
ansible-playbook openshift-ansible/playbooks/byo/config.yml
