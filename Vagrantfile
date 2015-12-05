# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"
  config.vm.provider "virtualbox" do |vb|
    vb.cpus = 2
    vb.memory = 2048
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
  end
  config.vm.synced_folder ".", "/home/vagrant/sync", disabled: true

  config.vm.network "private_network", ip: "192.168.133.10", auto_config: false
  config.vm.provision "shell", inline: <<-SHELL
    echo *** Configure internal network...
    nmcli general hostname master.internal
    nmcli connection add type ethernet con-name eth1 ifname eth1
    nmcli connection modify eth1 ipv4.addresses 192.168.133.10/24
    nmcli connection modify eth1 ipv4.method manual
    nmcli connection modify eth1 ipv4.dns 192.168.133.10
    nmcli connection down eth1 && nmcli connection up eth1
  SHELL

  config.vm.provision "shell", inline: <<-SHELL
    echo *** Configure internal DNS server...
    cat <<-EOF >>/etc/hosts
		192.168.133.10  master.internal master
	EOF
    cat <<-EOF >/etc/dnsmasq.d/openshift.conf
		domain-needed
		bogus-priv
		local=/internal/
		expand-hosts
		domain=internal
	EOF
    systemctl start dnsmasq
    systemctl enable dnsmasq
  SHELL

  config.vm.provision "shell", inline: <<-SHELL
    echo *** Install required packages...
    yum install -y wget git net-tools bind-utils iptables-services \
        bridge-utils bash-completion docker pyOpenSSL epel-release
    sed -i -e "s/^enabled=1/enabled=0/" /etc/yum.repos.d/epel.repo
    yum --enablerepo=epel install -y ansible
  SHELL

  config.vm.provision "shell", inline: <<-SHELL
    echo *** Set parameters for openshift-ansible...
    cat <<-EOF >/etc/ansible/hosts
		[OSEv3:children]
		masters
		nodes
		[OSEv3:vars]
		product_type=openshift
		deployment_type=origin
		openshift_master_identity_providers=[{'name': 'allow_all', 'login': 'true', 'challenge': 'true', 'kind': 'AllowAllPasswordIdentityProvider'}]
		osm_default_subdomain=cloudapps.192.168.133.10.xip.io
		osm_default_node_selector='region=primary'
		[masters]
		master.internal
		[nodes]
		master.internal
	EOF

    mkdir /etc/ansible/host_vars
    cat <<-EOF >/etc/ansible/host_vars/master.internal
		---
		openshift_hostname: master.internal
		openshift_public_hostname: master.192.168.133.10.xip.io
		openshift_ip: 192.168.133.10
		openshift_public_ip: 192.168.133.10
		openshift_node_labels: "{'region': 'primary', 'zone': 'default'}"
		openshift_schedulable: true
	EOF
  SHELL

  config.vm.provision "shell", inline: <<-SHELL
    echo *** Ensuring non-interactive host access...
    mkdir -m 0700 /root/.ssh
    ssh-keygen -q -f /root/.ssh/id_rsa -N ''
    cat /root/.ssh/id_rsa.pub >>/root/.ssh/authorized_keys
    cat <<-EOF >/root/.ssh/config
		Host master.internal
		  UserKnownHostsFile /dev/null
		  StrictHostKeyChecking no
		  PasswordAuthentication no
		  IdentityFile ~/.ssh/id_rsa
		  IdentitiesOnly yes
		  LogLevel FATAL
	EOF
    chmod 0600 /root/.ssh/authorized_keys /root/.ssh/config
  SHELL

  config.vm.provision "shell", inline: <<-SHELL
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
  SHELL
end
