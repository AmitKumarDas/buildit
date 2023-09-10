### Shoutouts
```yaml
- https://github.com/docker-library/bashbrew/blob/master/Dockerfile.release
- https://github.com/estesp/manifest-tool/blob/main/Dockerfile
- https://github.com/distribution/distribution/blob/main/dockerfiles/git.Dockerfile
- https://github.com/distribution/distribution/blob/main/dockerfiles/lint.Dockerfile
- https://github.com/distribution/distribution/blob/main/dockerfiles/vendor.Dockerfile
- https://github.com/estesp/manifest-tool/tree/main
```

### Snippet: An Environment for Golang
```Dockerfile
FROM golang:1.20-bullseye
WORKDIR /usr/src/bashbrew
ENV CGO_ENABLED 0

COPY go.mod go.sum ./
RUN go mod download; go mod verify
COPY . .
```

### Snippet: An Environment for Golang Testing
```Dockerfile
FROM golang:1.20-bullseye
WORKDIR /usr/src/bashbrew

COPY go.mod go.sum ./
RUN go mod download; go mod verify
COPY . .

RUN go test -v -race -coverprofile=coverage.out ./...
RUN go tool cover -func=coverage.out
```

### Snippet: An Environment for Bash / Shell Scripting
```Dockerfile
FROM golang:1.20-bullseye
SHELL ["bash", "-Eeuo", "pipefail", "-xc"]
```


