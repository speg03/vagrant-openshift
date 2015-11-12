#!/bin/sh

# Disable default DNS
nmcli connection modify eth0 ipv4.ignore-auto-dns yes
systemctl restart NetworkManager
