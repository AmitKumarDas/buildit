## Find & Fix CVEs If Any

### Github
```yaml
- https://github.com/kubernetes-sigs/azuredisk-csi-driver
- git@github.com:kubernetes-sigs/azuredisk-csi-driver.git
```

### Shallow Clone
```shell
git clone --depth 1 git@github.com:kubernetes-sigs/azuredisk-csi-driver.git
cd azuredisk-csi-driver
git log --oneline
```

### Commands run on my Mac
```shell
uname -a
Darwin amitd2-a01.vmware.com 21.6.0 Darwin Kernel Version 21.6.0: Thu Sep 29 20:13:56 PDT 2022; root:xnu-8020.240.7~1/RELEASE_ARM64_T6000 arm64

go version
go version go1.19 darwin/amd64
```

```shell
cat go.mod

module sigs.k8s.io/azuredisk-csi-driver
go 1.18
...
```
