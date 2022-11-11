## Takeaways
### KIND & `--unsafe-no-fsync`
- The `--unsafe-no-fsync` decreases the load on the pod's filesystem
- Which in turn decreases the end-to-end tests duration
- It is OK for us to use this flag because we are using a one-node etcd cluster
- The fsync feature is used for the raft consensus protocol
    - & is thus only useful when using 3 or more etcd# nodes
- refer: https://github.com/cert-manager/cert-manager/blob/master/make/config/kind/cluster.yaml

### KIND & service subnet
- Custom service subnet allows us to have a fixed/predictable clusterIP
- For various addon Services such as ingress-nginx, Gateway etc.
- refer: https://github.com/cert-manager/cert-manager/blob/master/make/config/kind/cluster.yaml

### Download Trivy
- curl --silent --show-error --fail --location --retry 10 --retry-connrefused https://github.com/aquasecurity/trivy/releases/download/v0.32.0/trivy_0.32.0_macOS-ARM64.tar.gz -o _bin/downloaded/tools/trivy@v0.32.0_darwin_arm64.tar.gz
- ./hack/util/checkhash.sh _bin/downloaded/tools/trivy@v0.32.0_darwin_arm64.tar.gz 41a3d4c12cd227cf95db6b30144b85e571541f587837f2f3814e2339dd81a21a
- tar xfO _bin/downloaded/tools/trivy@v0.32.0_darwin_arm64.tar.gz trivy > _bin/downloaded/tools/trivy@v0.32.0_darwin_arm64
- chmod +x _bin/downloaded/tools/trivy@v0.32.0_darwin_arm64
- rm _bin/downloaded/tools/trivy@v0.32.0_darwin_arm64.tar.gz
- cd _bin/tools/ && ln -f -s ../downloaded/tools/trivy@v0.32.0_darwin_arm64 trivy
- refer: `make trivy-scan-all`

### Run Trivy scan
- _bin/tools/trivy image --input _bin/containers/cert-manager-controller-linux-amd64.tar --format json --exit-code 1
- _bin/tools/trivy image --input _bin/containers/cert-manager-acmesolver-linux-amd64.tar --format json --exit-code 1
- _bin/tools/trivy image --input _bin/containers/cert-manager-webhook-linux-amd64.tar --format json --exit-code 1
- _bin/tools/trivy image --input _bin/containers/cert-manager-cainjector-linux-amd64.tar --format json --exit-code 1
- _bin/tools/trivy image --input _bin/containers/cert-manager-ctl-linux-amd64.tar --format json --exit-code 1
- 