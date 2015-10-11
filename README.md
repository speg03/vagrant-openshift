# vagrant-openshift

```
git clone https://github.com/openshift/openshift-ansible
cd openshift-ansible
git checkout v3.0.2-1
```

```
ssh-keygen -f ~/.ssh/id_rsa -N ''
ssh-copy-id vagrant@master.192.168.133.10.xip.io
```

```
sudo cp /vagrant/ansible/hosts /etc/ansible/
sudo cp -R /vagrant/ansible/host_vars /etc/ansible/
```

```
ansible-playbook ~/openshift-ansible/playbooks/byo/config.yml
```
