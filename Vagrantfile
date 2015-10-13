# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"
  config.vm.network "private_network", ip: "192.168.133.10", auto_config: false

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
  end

  config.vm.provision "shell", inline: <<-SHELL
    nmcli general hostname master.192.168.133.10.xip.io
    nmcli connection add type ethernet con-name eth1 ifname eth1
    nmcli connection modify eth1 ipv4.addresses 192.168.133.10/24
    nmcli connection modify eth1 ipv4.method manual
    nmcli connection down eth1 && nmcli connection up eth1
  SHELL
  config.vm.provision "shell", path: "packages.sh"
end
