## https://www.redhat.com/en/blog/introduction-ubi-micro

### Build on the UBI Micro image using Buildah
- Pull base image
- Mount it
- Install Apache
- Commit the image in the local container/storage cache

```shell
microcontainer=$(buildah from registry.access.redhat.com/ubi8/ubi-micro)
micromount=$(buildah mount $microcontainer)
yum install \
    --installroot $micromount \
    --releasever 8 \
    --setopt install_weak_deps=false \
    --nodocs -y \
    httpd
yum clean all \
    --installroot $micromount
buildah umount $microcontainer
buildah commit $microcontainer ubi-micro-httpd
```