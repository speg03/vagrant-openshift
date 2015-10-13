#!/bin/sh

# Network configuration
if [ -n "$1" ]; then
    ip_addr=$1
    nmcli connection add type ethernet con-name eth1 ifname eth1
    nmcli connection modify eth1 ipv4.addresses ${ip_addr}/24
    nmcli connection modify eth1 ipv4.method manual
    nmcli connection down eth1
    nmcli connection up eth1
fi

# Install packages
yum install -y wget git net-tools bind-utils iptables-services bridge-utils bash-completion

# Install Docker
yum install -y docker

# Install Ansible
yum install -y epel-release
sed -i -e "s/^enabled=1/enabled=0/" /etc/yum.repos.d/epel.repo
yum --enablerepo=epel install -y ansible
