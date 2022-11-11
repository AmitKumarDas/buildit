## References
- https://cert-manager.io/docs/contributing/building/#container-engines

## Setup
- git clone git@github.com:cert-manager/cert-manager.git
- cd cert-manager

## Build client binaries
- make cmctl-darwin
- ls -ltra _bin/cmctl

## Build containers
### make cert-manager-controller-linux
- make cert-manager-controller-linux
  - look at the command logs
- Look at the above command logs
- ls -ltr _bin/containers/
- docker images

### make cert-manager-webhook-linux
- make cert-manager-webhook-linux
  - look at command logs
- ls -ltr _bin/containers 
- docker images

### make cert-manager-cainjector-linux
- make cert-manager-cainjector-linux
- ls -ltr _bin/containers


### make cert-manager-acmesolver-linux
- make cert-manager-acmesolver-linux
- ls -ltr _bin/containers
- docker images

## All docker images
```shell
docker images              
REPOSITORY                                                      TAG                          IMAGE ID       CREATED          SIZE
cert-manager-ctl-arm                                            v1.10.0-41-g6c5189c916dc17   8c7860f443f6   14 minutes ago   47.2MB
cert-manager-ctl-ppc64le                                        v1.10.0-41-g6c5189c916dc17   9e4015925661   14 minutes ago   48.7MB
cert-manager-ctl-s390x                                          v1.10.0-41-g6c5189c916dc17   ee4ce58a3ab4   14 minutes ago   52.5MB
cert-manager-ctl-arm64                                          v1.10.0-41-g6c5189c916dc17   7848746d41a2   15 minutes ago   48.2MB
cert-manager-ctl-amd64                                          v1.10.0-41-g6c5189c916dc17   f013b7b64828   15 minutes ago   49.8MB
cert-manager-acmesolver-arm                                     v1.10.0-41-g6c5189c916dc17   1bec03d254c4   15 minutes ago   27.4MB
cert-manager-acmesolver-ppc64le                                 v1.10.0-41-g6c5189c916dc17   fb2c34baefaf   15 minutes ago   27.6MB
cert-manager-acmesolver-s390x                                   v1.10.0-41-g6c5189c916dc17   2f5fb73c034e   16 minutes ago   30.1MB
cert-manager-acmesolver-arm64                                   v1.10.0-41-g6c5189c916dc17   54003f40e797   16 minutes ago   27.6MB
cert-manager-acmesolver-amd64                                   v1.10.0-41-g6c5189c916dc17   48db6dba2dbb   16 minutes ago   28.3MB
cert-manager-cainjector-arm                                     v1.10.0-41-g6c5189c916dc17   3cec10e9eee7   18 minutes ago   36.6MB
cert-manager-cainjector-ppc64le                                 v1.10.0-41-g6c5189c916dc17   0ef2fad8ae57   18 minutes ago   37.4MB
cert-manager-cainjector-s390x                                   v1.10.0-41-g6c5189c916dc17   577e25e3b5bd   18 minutes ago   40.5MB
cert-manager-cainjector-arm64                                   v1.10.0-41-g6c5189c916dc17   2132e044983d   18 minutes ago   37MB
cert-manager-cainjector-amd64                                   v1.10.0-41-g6c5189c916dc17   5474686e6486   18 minutes ago   38.2MB
cert-manager-webhook-arm                                        v1.10.0-41-g6c5189c916dc17   59fb99a61413   22 minutes ago   42.7MB
cert-manager-webhook-ppc64le                                    v1.10.0-41-g6c5189c916dc17   e3440ec5e49b   22 minutes ago   44.2MB
cert-manager-webhook-s390x                                      v1.10.0-41-g6c5189c916dc17   43f2f39cb2e9   22 minutes ago   47.4MB
cert-manager-webhook-arm64                                      v1.10.0-41-g6c5189c916dc17   0876bb4bd878   22 minutes ago   43.9MB
cert-manager-webhook-amd64                                      v1.10.0-41-g6c5189c916dc17   01fcf9d5a218   23 minutes ago   45MB
cert-manager-controller-arm                                     v1.10.0-41-g6c5189c916dc17   10685c5f8302   42 minutes ago   56.3MB
cert-manager-controller-ppc64le                                 v1.10.0-41-g6c5189c916dc17   53c9eef33778   43 minutes ago   58.8MB
cert-manager-controller-s390x                                   v1.10.0-41-g6c5189c916dc17   36d852ca8178   44 minutes ago   62.6MB
cert-manager-controller-arm64                                   v1.10.0-41-g6c5189c916dc17   7300f651b401   45 minutes ago   58.2MB
cert-manager-controller-amd64                                   v1.10.0-41-g6c5189c916dc17   640d4e9e64f3   45 minutes ago   60MB
```
