# -*- mode: ruby -*-
# vi: set ft=ruby :

MASTER_IP = ENV['OPENSHIFT_MASTER_IP'] || "192.168.133.10"

Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"
  config.vm.hostname = "openshift-master.internal"
  config.vm.network "private_network", ip: MASTER_IP, auto_config: false

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
  end

  config.vm.provision "shell", path: "provision.sh", args: MASTER_IP
end
