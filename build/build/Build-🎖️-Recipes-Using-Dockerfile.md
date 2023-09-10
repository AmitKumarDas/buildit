### Shoutouts
```yaml
- https://github.com/docker-library/bashbrew/blob/master/Dockerfile.release
- https://github.com/estesp/manifest-tool/blob/main/Dockerfile
- https://github.com/distribution/distribution/blob/main/dockerfiles/git.Dockerfile
- https://github.com/distribution/distribution/blob/main/dockerfiles/lint.Dockerfile
- https://github.com/distribution/distribution/blob/main/dockerfiles/vendor.Dockerfile
- https://github.com/estesp/manifest-tool/tree/main
```

### Commands | Bash | Shell
```yaml
- cp -a          # retains all properties
- cp -a          # symlinks are not dereferenced
- cp -l          # copy hardlink instead of copies
- $0 vs ${BASH_SOURCE[0]}            # Refers to self i.e. the current shell script itself
- exec "$dir/bin/bashbrew" "$@"      # Awesome DevEx # The LAST LINE in build script
- dirname /usr/bin/sort              # Outputs /usr/bin
- dirname stdio.h                    # Outputs .
- dir="$(readlink -f "$BASH_SOURCE")"      # Lazy
- dir="$(dirname "$dir")"                  # Lazy # Hence run inside Dockerfile WORKDIR
```

### A Dockerfile Env for Golang
```Dockerfile
FROM golang:1.20-bullseye
WORKDIR /usr/src/bashbrew
ENV CGO_ENABLED 0

COPY go.mod go.sum ./
RUN go mod download; go mod verify
COPY . .
```

### A Dockerfile Env for Golang Testing
```Dockerfile
FROM golang:1.20-bullseye
WORKDIR /usr/src/bashbrew

COPY go.mod go.sum ./
RUN go mod download; go mod verify
COPY . .

RUN go test -v -race -coverprofile=coverage.out ./...
RUN go tool cover -func=coverage.out
```

### A Dockerfile Env for Bash / Shell Scripting
```Dockerfile
FROM golang:1.20-bullseye
SHELL ["bash", "-Eeuo", "pipefail", "-xc"]
```

### A Dockerfile Env to Build Golang with Bash
```bash
#!/usr/bin/env bash
set -Eeuo pipefail

# A SMALL SHELL SCRIPT TO HELP COMPILE bashbrew
dir="$(readlink -f "$BASH_SOURCE")"
dir="$(dirname "$dir")"

export GO111MODULE=on
(
	cd "$dir"
	go build -o bin/bashbrew ./cmd/bashbrew > /dev/null
)

exec "$dir/bin/bashbrew" "$@"
```

```Dockerfile
FROM golang:1.20-bullseye AS build
SHELL ["bash", "-Eeuo", "pipefail", "-xc"]
WORKDIR /usr/src/bashbrew

COPY go.mod go.sum ./
RUN go mod download; go mod verify
COPY . .

RUN CGO_ENABLED=0 ./bashbrew.sh --version; \
	cp -al bin/bashbrew /
```

