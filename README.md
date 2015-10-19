# vagrant-openshift

## Environment

* VirtualBox
* Vagrant

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
