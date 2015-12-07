#!/bin/sh

echo *** Install required packages...

yum install -y wget git net-tools bind-utils iptables-services \
    bridge-utils bash-completion docker pyOpenSSL epel-release

sed -i -e "s/^enabled=1/enabled=0/" /etc/yum.repos.d/epel.repo
yum --enablerepo=epel install -y ansible
