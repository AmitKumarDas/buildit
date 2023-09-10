### Shoutouts
```yaml
- https://github.com/docker-library/bashbrew/blob/master/Dockerfile.release
- https://github.com/estesp/manifest-tool/blob/main/Dockerfile
- https://github.com/distribution/distribution/blob/main/dockerfiles/git.Dockerfile
- https://github.com/distribution/distribution/blob/main/dockerfiles/lint.Dockerfile
- https://github.com/distribution/distribution/blob/main/dockerfiles/vendor.Dockerfile
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
- chmod 1777 "$BASHBREW_CACHE"             # Ensures cache dir is writable by anyone (similar to /tmp)
- chmod 1777 "$BASHBREW_CACHE"             # Allows to decide at runtime the exact uid/gid we'd like to run as
- if [ "${1#*-}" = "$1" ]; then      # Does $1 contain -
- if [ "${1#*-}" = "$1" ]; then      # ${1#*-} deletes the shortest match of *- from $1 # abc-def -> def
- echo "${foo##*-}"                  # if foo = 123-456-789 then output is 789
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

### Dockerfile to RELEASE Golang - Include Build Script for DevEx - Part I
- bashbrew.sh
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

### Dockerfile to RELEASE Golang - Include Entrypoint Script for DevEx - Part II
- scripts/bashbrew-entrypoint.sh
```sh
#!/bin/sh
set -e

if [ "${1#-}" != "$1" ]; then
	set -- bashbrew "$@"
fi

# if our command is a valid bashbrew subcommand, let's invoke it through bashbrew instead
# (this allows for "docker run bashbrew build", etc)
if bashbrew "$1" --help > /dev/null 2>&1; then
	set -- bashbrew "$@"
fi

exec "$@"
```

```Dockerfile
FROM infosiftr/moby
SHELL ["bash", "-Eeuo", "pipefail", "-xc"]

RUN apt-get update; \
	apt-get install -y --no-install-recommends git ; \
	rm -rf /var/lib/apt/lists/*

COPY --from=build /bashbrew /usr/local/bin/
RUN bashbrew --version

ENV BASHBREW_CACHE /bashbrew-cache
# make sure our default cache dir exists and is writable by anyone (similar to /tmp)
RUN mkdir -p "$BASHBREW_CACHE"; \
	chmod 1777 "$BASHBREW_CACHE"
# (this allows us to decide at runtime the exact uid/gid we'd like to run as)

VOLUME $BASHBREW_CACHE

COPY scripts/bashbrew-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["bashbrew-entrypoint.sh"]
```

### Share Your Binary | Build From a Git COMMIT | Dockerfile Environment
```Dockerfile
FROM golang:1.20

RUN go install golang.org/x/tools/cmd/cover@latest \
    && go install golang.org/x/lint/golint@latest

ENV REGISTRY_COMMIT=a4d9db5a884b70be0c96dd6a7a9dbef4f2798c51
RUN set -x \
	&& mkdir -p /go/src/github.com/distribution && cd /go/src/github.com/distribution \
	&& git clone https://github.com/distribution/distribution.git && cd distribution \
	&& git checkout "$REGISTRY_COMMIT" \
	&& make binaries && cp bin/registry /usr/local/bin

# The source is bind-mounted into this folder
WORKDIR /go/src/github.com/estesp/manifest-tool
```

### Dockerfile Provides Go Environment | Makefile to Build
```Dockerfile
FROM golang:1.20

RUN go install golang.org/x/tools/cmd/cover@latest \
    && go install golang.org/x/lint/golint@latest

# The source is bind-mounted into this folder
WORKDIR /go/src/github.com/estesp/manifest-tool
```
```Mk
PREFIX ?= ${DESTDIR}/usr
INSTALLDIR=${PREFIX}/bin

WORKDIR := /go/src/github.com/estesp/manifest-tool
GIT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD 2>/dev/null)
COMMIT_NO := $(shell git rev-parse HEAD 2> /dev/null || true)
COMMIT := $(if $(shell git status --porcelain --untracked-files=no),"${COMMIT_NO}-dirty","${COMMIT_NO}")
DOCKER_IMAGE := manifest-tool-dev$(if $(GIT_BRANCH),:$(GIT_BRANCH))
DOCKER_RUN := docker run --rm -i
DOCKER_RUNIT := $(DOCKER_RUN) -v $(shell pwd):/go/src/github.com/estesp/manifest-tool -w /go/src/github.com/estesp/manifest-tool "$(DOCKER_IMAGE)"

shell: build-container
	$(DOCKER_RUN_DOCKER) bash

build:
	$(DOCKER_RUN) \
		-v $(shell pwd):$(WORKDIR) \
		-w $(WORKDIR) \
		golang:1.17 /bin/bash -c "\
		cd v2 && go build -ldflags \"-X main.gitCommit=${COMMIT}\" -o ../manifest-tool github.com/estesp/manifest-tool/v2/cmd/manifest-tool"
```

