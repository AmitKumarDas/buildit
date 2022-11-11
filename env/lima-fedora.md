## Lima
- RUN:
  - git clone git@github.com:lima-vm/lima.git
  - cd lima/examples
  - limactl start fedora.yaml
```shell
INFO[0019] Attempting to download the image from "https://download.fedoraproject.org/pub/fedora/linux/releases/36/Cloud/aarch64/images/Fedora-Cloud-Base-36-1.5.aarch64.qcow2"  digest="sha256:5c0e7e99b0c542cb2155cd3b52bbf51a42a65917e52d37df457d1e9759b37512"
```
  - limactl shell fedora
  - exit
  - limactl stop fedora
  - 