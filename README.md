# vagrant-openshift

## Create instances

```
vagrant up
```

## Install OpenShift Origin

```
sh sync/provision/openshift.sh
```

## Default project configuration

The *default* project/namespace is a special one where we will put some of our infrastructure-related resources.

```
oc edit namespace default
```

In the annotations list, add this line:

```
openshift.io/node-selector: region=infra
```

## Create infra resources

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


## Routing

First routing (`ip r`)

```
default via 10.0.2.2 dev eth0  proto static  metric 100
10.0.2.0/24 dev eth0  proto kernel  scope link  src 10.0.2.15
10.0.2.0/24 dev eth0  proto kernel  scope link  src 10.0.2.15  metric 100
10.1.0.0/16 dev tun0  proto kernel  scope link
192.168.133.0/24 dev eth1  proto kernel  scope link  src 192.168.133.10
192.168.133.0/24 dev eth1  proto kernel  scope link  src 192.168.133.10  metric 100
```

After reloading (`ip r`)

```
default via 10.0.2.2 dev eth0  proto static  metric 100
10.0.2.0/24 dev eth0  proto kernel  scope link  src 10.0.2.15
10.0.2.0/24 dev eth0  proto kernel  scope link  src 10.0.2.15  metric 100
10.1.0.0/24 dev lbr0  proto kernel  scope link  src 10.1.0.1
10.1.0.0/24 dev tun0  proto kernel  scope link  src 10.1.0.1
10.1.0.0/16 dev tun0  proto kernel  scope link
192.168.133.0/24 dev eth1  proto kernel  scope link  src 192.168.133.10
192.168.133.0/24 dev eth1  proto kernel  scope link  src 192.168.133.10  metric 100
```

Remove obstructive routes

```
ip route del 10.1.0.0/24 dev lbr0
ip route del 10.1.0.0/24 dev tun0
```
