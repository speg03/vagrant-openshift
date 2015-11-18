#!/bin/sh

# Install ansible
yum install -y pyOpenSSL epel-release
sed -i -e "s/^enabled=1/enabled=0/" /etc/yum.repos.d/epel.repo
yum --enablerepo=epel install -y ansible

# Ansible configuration
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
