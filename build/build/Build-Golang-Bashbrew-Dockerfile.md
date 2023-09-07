### Shoutout
```yaml
- https://github.com/docker-library/bashbrew/blob/master/Dockerfile.release
```

### Best Practices
```Dockerfile
SHELL ["bash", "-Eeuo", "pipefail", "-xc"]
```

```Dockerfile
RUN apt-get update; \
    apt-get install -y --no-install-recommends \
        file \
        gnupg \
        wget \
    ; \
    rm -rf /var/lib/apt/lists/*
```

```Dockerfile
# Stress on use of /usr/src/           🧐🧐🧐
WORKDIR /usr/src/bashbrew
ENV CGO_ENABLED 0
```

```Dockerfile
# Architectures
ENV BASHBREW_ARCHES \
    amd64 \
    arm32v5 \
    arm32v6 \
    arm32v7 \
    arm64v8 \
    darwin-amd64 \
    i386 \
    mips64le \
    ppc64le \
    riscv64 \
    s390x \
    windows-amd64

# Stress on use of /usr/local/bin/           🧐🧐🧐
COPY scripts/bashbrew-arch-to-goenv.sh /usr/local/bin/
```
