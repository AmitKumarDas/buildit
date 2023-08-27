### Motivation
- https://github.com/kiwigrid/k8s-sidecar/tree/master is based on Alpine
- However, Alpine is not recommended in my org
- Moving k8s-sidecar to debian results in lot of CVEs
- Hence, attempt to build k8s-sidecar image on distroless

