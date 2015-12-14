#!/bin/sh

base_ip=$1
num_nodes=$2

echo "*** Configure internal DNS server..."

echo "${base_ip}0  master.internal master" >>/etc/hosts
for i in $(seq 0 ${num_nodes}); do
    [ ${i} -eq 0 ] && continue
    echo "${base_ip}${i}  node${i}.internal node${i}" >>/etc/hosts
done

cat <<-EOF >/etc/dnsmasq.d/internal.conf
	domain-needed
	bogus-priv
	local=/internal/
	expand-hosts
	domain=internal
EOF

systemctl start dnsmasq
systemctl enable dnsmasq
