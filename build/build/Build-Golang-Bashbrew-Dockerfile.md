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
WORKDIR /usr/src/bashbrew
ENV CGO_ENABLED 0
```

