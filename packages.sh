#!/bin/sh

# Install packages
yum install -y wget git net-tools bind-utils iptables-services bridge-utils bash-completion

# Install Docker
yum install -y docker

# Install Ansible
yum install -y epel-release
sed -i -e "s/^enabled=1/enabled=0/" /etc/yum.repos.d/epel.repo
yum --enablerepo=epel install -y ansible
