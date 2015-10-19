#!/bin/sh

# Network configuration
nmcli general hostname master.192.168.133.10.xip.io
nmcli connection add type ethernet con-name eth1 ifname eth1
nmcli connection modify eth1 ipv4.addresses 192.168.133.10/24
nmcli connection modify eth1 ipv4.method manual
nmcli connection down eth1 && nmcli connection up eth1
