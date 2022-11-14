## Notes
- These images were built on my Mac workstation using cert-manager's `make` targets
  - refer: ./build-on-mac.md
- Base image: `gcr.io/distroless/base@sha256:e5ef8136477df3acb7d86db402fd56a7e6d971c81fe48e17149d44e2796b8f3b`
- These scans were done on 14-Nov-2022

### docker images
```shell
docker images
REPOSITORY                                                      TAG                          IMAGE ID       CREATED             SIZE
cert-manager-ctl-arm                                            v1.10.0-41-g6c5189c916dc17   321dc06ffafb   About a minute ago   58.7MB
cert-manager-ctl-ppc64le                                        v1.10.0-41-g6c5189c916dc17   e4e4c2abb786   2 minutes ago        79.9MB
cert-manager-ctl-s390x                                          v1.10.0-41-g6c5189c916dc17   e2c1ad8a00e6   2 minutes ago        67.9MB
cert-manager-ctl-arm64                                          v1.10.0-41-g6c5189c916dc17   fae3f843aee4   2 minutes ago        63.2MB
cert-manager-ctl-amd64                                          v1.10.0-41-g6c5189c916dc17   67d5a83ea087   2 minutes ago        67.7MB
cert-manager-cainjector-arm                                     v1.10.0-41-g6c5189c916dc17   ded98cf06e79   2 minutes ago        48MB
cert-manager-cainjector-ppc64le                                 v1.10.0-41-g6c5189c916dc17   a1fd0e433a1a   2 minutes ago        68.6MB
cert-manager-cainjector-s390x                                   v1.10.0-41-g6c5189c916dc17   07702f4e69c0   2 minutes ago        55.9MB
cert-manager-cainjector-arm64                                   v1.10.0-41-g6c5189c916dc17   b82a961fb82c   2 minutes ago        52MB
cert-manager-cainjector-amd64                                   v1.10.0-41-g6c5189c916dc17   a171bf874247   3 minutes ago        56.2MB
cert-manager-acmesolver-arm                                     v1.10.0-41-g6c5189c916dc17   9ade52e19f12   3 minutes ago        38.9MB
cert-manager-acmesolver-ppc64le                                 v1.10.0-41-g6c5189c916dc17   a469b799ae78   3 minutes ago        58.8MB
cert-manager-acmesolver-s390x                                   v1.10.0-41-g6c5189c916dc17   60083c1b95e9   3 minutes ago        45.5MB
cert-manager-acmesolver-arm64                                   v1.10.0-41-g6c5189c916dc17   82e694946935   3 minutes ago        42.6MB
cert-manager-acmesolver-amd64                                   v1.10.0-41-g6c5189c916dc17   9d12b27006c8   3 minutes ago        46.3MB
cert-manager-webhook-arm                                        v1.10.0-41-g6c5189c916dc17   d934def862e4   3 minutes ago        54.2MB
cert-manager-webhook-ppc64le                                    v1.10.0-41-g6c5189c916dc17   1cf6e1db902f   3 minutes ago        75.3MB
cert-manager-webhook-s390x                                      v1.10.0-41-g6c5189c916dc17   dfd2e5b6eb73   3 minutes ago        62.9MB
cert-manager-webhook-arm64                                      v1.10.0-41-g6c5189c916dc17   d53f45a8461f   4 minutes ago        58.9MB
cert-manager-webhook-amd64                                      v1.10.0-41-g6c5189c916dc17   cc9a4146fdda   4 minutes ago        63MB
cert-manager-controller-arm                                     v1.10.0-41-g6c5189c916dc17   21d77ddf5824   4 minutes ago        67.8MB
cert-manager-controller-ppc64le                                 v1.10.0-41-g6c5189c916dc17   cdbff4552365   4 minutes ago        89.9MB
cert-manager-controller-s390x                                   v1.10.0-41-g6c5189c916dc17   e3c17c94ad45   4 minutes ago        78.1MB
cert-manager-controller-arm64                                   v1.10.0-41-g6c5189c916dc17   84c97378d312   5 minutes ago        73.2MB
cert-manager-controller-amd64                                   v1.10.0-41-g6c5189c916dc17   4cba9af07ddf   7 minutes ago        77.9MB
```

#### cert-manager-ctl-amd64:v1.10.0-41-g6c5189c916dc17
```shell
_bin/tools/trivy image cert-manager-ctl-amd64:v1.10.0-41-g6c5189c916dc17

2022-11-14T11:30:01.650+0530	INFO	Detected OS: debian
2022-11-14T11:30:01.650+0530	INFO	Detecting Debian vulnerabilities...
2022-11-14T11:30:01.653+0530	INFO	Number of language-specific files: 1
2022-11-14T11:30:01.653+0530	INFO	Detecting gobinary vulnerabilities...

cert-manager-ctl-amd64:v1.10.0-41-g6c5189c916dc17 (debian 11.5)

Total: 13 (UNKNOWN: 0, LOW: 11, MEDIUM: 2, HIGH: 0, CRITICAL: 0)
```

#### cert-manager-acmesolver-amd64:v1.10.0-41-g6c5189c916dc17
```shell
_bin/tools/trivy image cert-manager-acmesolver-amd64:v1.10.0-41-g6c5189c916dc17

2022-11-14T11:31:56.960+0530	INFO	Detected OS: debian
2022-11-14T11:31:56.960+0530	INFO	Detecting Debian vulnerabilities...
2022-11-14T11:31:56.962+0530	INFO	Number of language-specific files: 1
2022-11-14T11:31:56.962+0530	INFO	Detecting gobinary vulnerabilities...

cert-manager-acmesolver-amd64:v1.10.0-41-g6c5189c916dc17 (debian 11.5)

Total: 13 (UNKNOWN: 0, LOW: 11, MEDIUM: 2, HIGH: 0, CRITICAL: 0)
```

#### cert-manager-cainjector-amd64:v1.10.0-41-g6c5189c916dc17
```shell
_bin/tools/trivy image cert-manager-cainjector-amd64:v1.10.0-41-g6c5189c916dc17

2022-11-14T11:41:08.879+0530	INFO	Detected OS: debian
2022-11-14T11:41:08.879+0530	INFO	Detecting Debian vulnerabilities...
2022-11-14T11:41:08.880+0530	INFO	Number of language-specific files: 1
2022-11-14T11:41:08.880+0530	INFO	Detecting gobinary vulnerabilities...

cert-manager-cainjector-amd64:v1.10.0-41-g6c5189c916dc17 (debian 11.5)

Total: 13 (UNKNOWN: 0, LOW: 11, MEDIUM: 2, HIGH: 0, CRITICAL: 0)
```

#### cert-manager-webhook-amd64:v1.10.0-41-g6c5189c916dc17
```shell
_bin/tools/trivy image cert-manager-webhook-amd64:v1.10.0-41-g6c5189c916dc17

2022-11-14T11:46:45.361+0530	INFO	Detected OS: debian
2022-11-14T11:46:45.361+0530	INFO	Detecting Debian vulnerabilities...
2022-11-14T11:46:45.364+0530	INFO	Number of language-specific files: 1
2022-11-14T11:46:45.364+0530	INFO	Detecting gobinary vulnerabilities...

cert-manager-webhook-amd64:v1.10.0-41-g6c5189c916dc17 (debian 11.5)

Total: 13 (UNKNOWN: 0, LOW: 11, MEDIUM: 2, HIGH: 0, CRITICAL: 0)
```

#### cert-manager-controller-amd64:v1.10.0-41-g6c5189c916dc17
```shell
_bin/tools/trivy image cert-manager-controller-amd64:v1.10.0-41-g6c5189c916dc17

2022-11-14T11:47:10.354+0530	INFO	Detected OS: debian
2022-11-14T11:47:10.354+0530	INFO	Detecting Debian vulnerabilities...
2022-11-14T11:47:10.355+0530	INFO	Number of language-specific files: 1
2022-11-14T11:47:10.355+0530	INFO	Detecting gobinary vulnerabilities...

cert-manager-controller-amd64:v1.10.0-41-g6c5189c916dc17 (debian 11.5)

Total: 13 (UNKNOWN: 0, LOW: 11, MEDIUM: 2, HIGH: 0, CRITICAL: 0)
```
