#!/bin/sh

base_ip=$1
num_nodes=$2
app_domain="cloudapps.${base_ip}0.xip.io"

echo *** Set parameters for openshift-ansible...

cat <<-EOF >/etc/ansible/hosts
	[OSEv3:children]
	masters
	nodes
	[OSEv3:vars]
	product_type=openshift
	deployment_type=origin
	openshift_master_identity_providers=[{'name': 'allow_all', 'login': 'true', 'challenge': 'true', 'kind': 'AllowAllPasswordIdentityProvider'}]
	osm_default_subdomain=${app_domain}
	osm_default_node_selector='region=primary'
	[masters]
	master.internal
	[nodes]
	master.internal
EOF

mkdir /etc/ansible/host_vars
master_ip="${base_ip}0"
cat <<-EOF >/etc/ansible/host_vars/master.internal
	---
	openshift_hostname: master.internal
	openshift_public_hostname: master.${master_ip}.xip.io
	openshift_ip: ${master_ip}
	openshift_public_ip: ${master_ip}
	openshift_node_labels: "{'region': 'infra', 'zone': 'default'}"
	openshift_schedulable: true
EOF

for i in $(seq 0 ${num_nodes}); do
    [ ${i} -eq 0 ] && continue
    echo "node${i}.internal" >>/etc/ansible/hosts

    node_ip="${base_ip}${i}"
    cat <<-EOF >/etc/ansible/host_vars/node${i}.internal
	---
		openshift_hostname: node${i}.internal
		openshift_public_hostname: master.${node_ip}.xip.io
		openshift_ip: ${node_ip}
		openshift_public_ip: ${node_ip}
		openshift_node_labels: "{'region': 'primary', 'zone': 'default'}"
	EOF
done

echo *** Install OpenShift...
git clone https://github.com/openshift/openshift-ansible \
    /root/openshift-ansible
ansible-playbook /root/openshift-ansible/playbooks/byo/config.yml

echo *** Deploy docker-registry...
oadm registry --service-account=registry \
    --config=/etc/origin/master/admin.kubeconfig \
    --credentials=/etc/origin/master/openshift-registry.kubeconfig \
    --mount-host=/registry

echo *** Deploy router...
oadm router --service-account=router \
    --credentials=/etc/origin/master/openshift-router.kubeconfig
