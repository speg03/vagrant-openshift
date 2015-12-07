# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  params = {
    cpus: ENV['OPENSHIFT_CPUS'] || 2,
    memory: ENV['OPENSHIFT_MEMORY'] || 1024,
    base_ip: ENV['OPENSHIFT_BASE_IP'] || "192.168.133.10",
    num_nodes: (ENV['OPENSHIFT_NUM_NODES'] || 2).to_i
  }

  config.vm.box = "centos/7"
  config.vm.provider "virtualbox" do |vb|
    vb.cpus = params[:cpus]
    vb.memory = params[:memory]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
  end
  config.vm.synced_folder ".", "/home/vagrant/sync", disabled: true

  config.vm.provision "shell", path: "provision/install-packages.sh"

  1.upto(params[:num_nodes]) do |i|
    config.vm.define "node#{i}" do |c|
      hostname = "node#{i}.internal"
      ipaddr = "#{params[:base_ip]}#{i}"
      dns_ipaddr = "#{params[:base_ip]}0"
      c.vm.network "private_network", ip: ipaddr, auto_config: false
      c.vm.provision "shell", path: "provision/configure-network.sh",
                     args: [hostname, ipaddr, dns_ipaddr]
    end
  end

  config.vm.define "master" do |c|
    hostname = "master.internal"
    ipaddr = "#{params[:base_ip]}0"
    c.vm.network "private_network", ip: ipaddr, auto_config: false
    c.vm.provision "shell", path: "provision/configure-network.sh",
                   args: [hostname, ipaddr, ipaddr]
    c.vm.provision "shell", path: "provision/configure-dns.sh",
                   args: [params[:base_ip], params[:num_nodes]]
    c.vm.provision "shell", path: "provision/install-openshift.sh",
                   args: [params[:base_ip], params[:num_nodes]]
  end
end
