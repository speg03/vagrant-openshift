#!/bin/sh

echo *** Install required packages...

yum install -y wget git net-tools bind-utils iptables-services \
    bridge-utils bash-completion docker pyOpenSSL
