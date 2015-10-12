# vagrant-openshift

```
# Network configuration
echo <<EOF >/etc/sysconfig/network-scripts/ifcfg-eth1
NM_CONTROLLED=no
BOOTPROTO=none
ONBOOT=yes
IPADDR=192.168.133.10
NETMASK=255.255.255.0
DEVICE=eth1
PEERDNS=no
EOF
```

```
git clone -b v3.0.2-1 https://github.com/openshift/openshift-ansible
```

```
ssh-keygen -f ~/.ssh/id_rsa -N ''
ssh-copy-id vagrant@master.192.168.133.10.xip.io
```

```
sudo cp sync/ansible/hosts /etc/ansible/
sudo cp -R sync/ansible/host_vars /etc/ansible/
```

```
ansible-playbook ~/openshift-ansible/playbooks/byo/config.yml
```

```
sudo oadm registry --service-account=registry \
  --config=/etc/origin/master/admin.kubeconfig \
  --credentials=/etc/origin/master/openshift-registry.kubeconfig \
  --mount-host=/registry
```

```
sudo oadm router --service-account=router \
  --credentials=/etc/origin/master/openshift-router.kubeconfig
```
