#!/bin/sh

# DNS server
cat <<EOF >>/etc/hosts
192.168.133.10  master.internal master
EOF

cat <<EOF >/etc/dnsmasq.d/internal.conf
domain-needed
bogus-priv
local=/internal/
expand-hosts
domain=internal
EOF

systemctl start dnsmasq
systemctl enable dnsmasq
