### https://iximiuz.com/en/posts/containers-distroless-images/

- The image is Debian-based 
- So, there is a distro in the distroless image, but it's stripped down
- It's just ~2MB big and has a single layer 
- There is a Linux distro-like directory structure inside
- The /etc/passwd, /etc/group, and even /etc/nsswitch.conf files are present
- Certificates and the timezone db seem to be in place as well
- Last but not least, the licenses seem to be preserved
- No packages, no package manager, not even a trace of libc!
- For Go program with CGO disabled

### Notes
- Constructing a container image without the Linux distro’s packaging tools is referred to as distroless
- refer - https://www.redhat.com/en/blog/introduction-ubi-micro
