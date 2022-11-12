## https://jcvassort.open-web.fr/how-to-build-alpine-distroless-docker-images/

- Alpine Linux is a security-oriented, lightweight Linux distribution based on:
  - musl libc
  - & busybox

### Busybox
- If you have a closer look at Alpine utilities, you will notice they are all symbolic links to busybox
```shell
$ ls -alh /bin/ | head
lrwxrwxrwx    1 root     root          12 Nov 24 09:20 arch -> /bin/busybox
lrwxrwxrwx    1 root     root          12 Nov 24 09:20 ash -> /bin/busybox
lrwxrwxrwx    1 root     root          12 Nov 24 09:20 base64 -> /bin/busybox
lrwxrwxrwx    1 root     root          12 Nov 24 09:20 bbconfig -> /bin/busybox
-rwxr-xr-x    1 root     root      805.6K Nov 23 00:57 busybox
lrwxrwxrwx    1 root     root          12 Nov 24 09:20 cat -> /bin/busybox
lrwxrwxrwx    1 root     root          12 Nov 24 09:20 chgrp -> /bin/busybox
```
- 🙇‍♀️BusyBox is a suite that provides several Unix utilities in a **single executable file** 😍

### As Alpine Linux relies on busybox, removing busybox and apk makes Alpine a distroless distro
```Dockerfile
FROM alpine:latest
RUN apk upgrade --no-cache; \
    # Distroless magic \
    # 1/ Remove all busybox **symlinks**
    find /sbin /bin /usr/bin /usr/local/bin/ -type l  -exec busybox rm -rf {} \;; \
    # 2/ use busybox to remove apk
    # 3/ use busybox to remove itself (which in turn removes all utilities) 
    busybox rm /sbin/apk /bin/busybox
```

```Dockerfile
FROM php:alpine
RUN apk upgrade --no-cache; \
    # Distroless magic
    find /sbin /bin /usr/bin /usr/local/bin/ -type l  -exec busybox rm -rf {} \;; \
    busybox rm /sbin/apk /bin/busybox
ENTRYPOINT ["/usr/local/bin/php"]
```

```Dockerfile
FROM alpine:latest

COPY public /usr/share/nginx/html
COPY nginx/default.conf /default.conf
RUN apk upgrade --no-cache; \
    apk add --no-cache nginx ; \
    mv /default.conf /etc/nginx/http.d/default.conf ; \
    ln -sf /dev/stdout /var/log/nginx/access.log ; \
    ln -sf /dev/stderr /var/log/nginx/error.log ; \
    # Distroless magic 
    find /sbin /bin /usr/bin /usr/local/bin/ -type l  -exec busybox rm -rf {} \;; \
    busybox rm /sbin/apk /bin/busybox

USER nginx
EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]
```
