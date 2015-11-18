#!/bin/sh

# Disable default DNS
nmcli connection modify eth0 ipv4.ignore-auto-dns yes
systemctl restart NetworkManager

# Remove obstructive routes
ip route del 10.1.0.0/24 dev lbr0 || true
ip route del 10.1.0.0/24 dev tun0 || true
