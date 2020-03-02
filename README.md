# Kind cluster setup for asm-istio on-prem!
Setting up local development to deploy a multi-node k8s cluster and asm-Istio

### PRE-REQUISITE
Because this kind cluster is setup to predominantly test Istio locally, Istio requires a lot of memory, for Istio's components to deploy properly. Please configure and restart your Docker by configuring Docker Preferences to match these settings:

![Alt text](/screenshots/docker-settings.png?raw=true "Docker CPU Memory Settings")


### Installation
```sh
# for macOS users
$ make -f Makefile.kind.mk kind.install_macOS
# OR if you have golang installed:
$ make -f Makefile.kind.mk kind.install_go
```

### Deploying a multi-node cluster
```sh
$ make -f Makefile.kind.mk kind.deploy_multinode
```

### Deploying Istio
```sh
$ make -f Makefile.kind.mk kind.deploy_istio
```


## TROUBLESHOOTING
### Cluster logs
```sh

$ make -f Makefile.kind.mk kind.logs
```
