# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
  end
  config.vm.synced_folder ".", "/home/vagrant/sync", disabled: true

  config.vm.define :master do |c|
    c.vm.network "private_network", ip: "192.168.133.10", auto_config: false
    c.vm.provision "shell", path: "provision/configure-network.sh"
    c.vm.provision "shell", path: "provision/install-packages.sh"
    c.vm.provision "shell", path: "provision/install-dns-server.sh"
    c.vm.provision "shell", path: "provision/install-openshift.sh"
  end
end
