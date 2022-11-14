### Notes
```shell
# Remove old docker images if any

make container

CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -ldflags "-X sigs.k8s.io/azuredisk-csi-driver/pkg/azuredisk.driverVersion=v1.25.0 -X sigs.k8s.io/azuredisk-csi-driver/pkg/azuredisk.gitCommit=1ca3cc8efa9f8a37bf0f5b213a06ab0f6250f985 -X sigs.k8s.io/azuredisk-csi-driver/pkg/azuredisk.buildDate=2022-11-14T08:03:20Z -extldflags "-static""  -mod vendor -o _output/amd64/azurediskplugin ./pkg/azurediskplugin
docker build --no-cache -t andyzhangx/azuredisk-csi:v1.25.0 --output=type=docker -f ./pkg/azurediskplugin/Dockerfile .
Error response from daemon: exporter "docker" could not be found
make: *** [container] Error 1
```

#### Context
- --load		Shorthand for --output=type=docker
- Will automatically load the single-platform build result to docker images

#### Retry
```shell
CGO_ENABLED=0 \
  GOOS=linux \
  GOARCH=amd64 \
  go build -a -ldflags "-X sigs.k8s.io/azuredisk-csi-driver/pkg/azuredisk.driverVersion=v1.25.0 -X sigs.k8s.io/azuredisk-csi-driver/pkg/azuredisk.gitCommit=1ca3cc8efa9f8a37bf0f5b213a06ab0f6250f985 -X sigs.k8s.io/azuredisk-csi-driver/pkg/azuredisk.buildDate=2022-11-14T08:03:20Z -extldflags "-static""  \
  -mod vendor \
  -o _output/amd64/azurediskplugin \
  ./pkg/azurediskplugin

docker build --no-cache -t andyzhangx/azuredisk-csi:v1.25.0 -f ./pkg/azurediskplugin/Dockerfile .
```

```shell
docker images
REPOSITORY                                                      TAG               IMAGE ID       CREATED         SIZE
andyzhangx/azuredisk-csi                                        v1.25.0           fb238900b87e   9 seconds ago   237MB
```

```shell
trivy image fb238900b87e

2022-11-14T15:53:11.857+0530	INFO	Detected OS: debian
2022-11-14T15:53:11.857+0530	INFO	Detecting Debian vulnerabilities...
2022-11-14T15:53:11.863+0530	INFO	Number of language-specific files: 1
2022-11-14T15:53:11.863+0530	INFO	Detecting gobinary vulnerabilities...

fb238900b87e (debian 11.5)

Total: 136 (UNKNOWN: 0, LOW: 79, MEDIUM: 18, HIGH: 33, CRITICAL: 6)

...

azurediskplugin (gobinary)

Total: 1 (UNKNOWN: 0, LOW: 0, MEDIUM: 1, HIGH: 0, CRITICAL: 0)
```