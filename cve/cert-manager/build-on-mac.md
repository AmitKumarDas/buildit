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
