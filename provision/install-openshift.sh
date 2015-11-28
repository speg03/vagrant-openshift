#!/bin/sh

### Install OpenShift

# Install ansible

yum install -y pyOpenSSL epel-release
sed -i -e "s/^enabled=1/enabled=0/" /etc/yum.repos.d/epel.repo
yum --enablerepo=epel install -y ansible

# Ansible setting for provisioning OpenShift

cat <<EOF >/etc/ansible/hosts
[OSEv3:children]
masters
nodes
[OSEv3:vars]
product_type=openshift
deployment_type=origin
openshift_master_identity_providers=[{'name': 'allow_all', 'login': 'true', 'challenge': 'true', 'kind': 'AllowAllPasswordIdentityProvider'}]
osm_default_subdomain=cloudapps.192.168.133.10.xip.io
osm_default_node_selector='region=primary'
[masters]
master.internal
[nodes]
master.internal
EOF

mkdir /etc/ansible/host_vars
cat <<EOF >/etc/ansible/host_vars/master.internal
---
openshift_hostname: master.internal
openshift_public_hostname: master.192.168.133.10.xip.io
openshift_ip: 192.168.133.10
openshift_public_ip: 192.168.133.10
openshift_node_labels: "{'region': 'primary', 'zone': 'default'}"
openshift_schedulable: true
EOF

# SSH settings for connecting to oneself automatically

mkdir -m 0700 $HOME/.ssh
ssh-keygen -q -f $HOME/.ssh/id_rsa -N ''
cat $HOME/.ssh/id_rsa.pub >>$HOME/.ssh/authorized_keys

cat <<EOF >>$HOME/.ssh/config
Host master.internal
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentityFile ~/.ssh/id_rsa
  IdentitiesOnly yes
  LogLevel FATAL
EOF

chmod 0600 $HOME/.ssh/authorized_keys $HOME/.ssh/config

# Install OpenShift by using openshift-ansible

git clone -b openshift-ansible-3.0.16-1 https://github.com/openshift/openshift-ansible $HOME/openshift-ansible
ansible-playbook $HOME/openshift-ansible/playbooks/byo/config.yml

# Deploy docker-registry

oadm registry --service-account=registry \
     --config=/etc/origin/master/admin.kubeconfig \
     --credentials=/etc/origin/master/openshift-registry.kubeconfig \
     --mount-host=/registry

# Deploy router

oadm router --service-account=router \
     --credentials=/etc/origin/master/openshift-router.kubeconfig
