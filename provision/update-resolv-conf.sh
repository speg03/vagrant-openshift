#!/bin/sh

dns_ipaddr=$1

echo "*** Update resolv.conf..."

cat <<-EOF >/etc/resolv.conf
	# Generated by vagrant provision scripts
	nameserver ${dns_ipaddr}
	nameserver 10.0.2.3
EOF
