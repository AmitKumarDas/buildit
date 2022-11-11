## Reference
https://github.com/cert-manager/cert-manager/blob/master/make/config/kind/cluster.yaml

### KIND & `--unsafe-no-fsync`
- The `--unsafe-no-fsync` decreases the load on the pod's filesystem
- Which in turn decreases the end-to-end tests duration
- It is OK for us to use this flag because we are using a one-node etcd cluster
- The fsync feature is used for the raft consensus protocol
- & is thus only useful when using 3 or more etcd# nodes

### KIND & service subnet
- Custom service subnet allows us to have a fixed/predictable clusterIP
- For various addon Services such as ingress-nginx, Gateway etc.
