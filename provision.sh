#!/bin/sh

# Enable SELinux
setenforce enforcing
sed -i -e "s/^SELINUX=permissive$/SELINUX=enforcing/g" /etc/selinux/config

# Install packages
yum install -y wget git net-tools bind-utils iptables-services bridge-utils bash-completion

# Install Docker
yum install -y docker
sed -i -e "/^# INSECURE_REGISTRY/a INSECURE_REGISTRY='--insecure-registry 172.30.0.0/16'" /etc/sysconfig/docker

# Install Ansible
yum install -y epel-release
sed -i -e "s/^enabled=1/enabled=0/" /etc/yum.repos.d/epel.repo
yum --enablerepo=epel install -y ansible
