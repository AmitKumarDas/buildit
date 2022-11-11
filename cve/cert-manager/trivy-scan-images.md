## Notes
- These images were built on my Mac workstation using cert-manager's `make` targets
- These scans were done on 11-Nov-2022

### docker images
```shell
docker images
REPOSITORY                                                      TAG                          IMAGE ID       CREATED             SIZE
cert-manager-ctl-arm                                            v1.10.0-41-g6c5189c916dc17   8c7860f443f6   43 minutes ago      47.2MB
cert-manager-ctl-ppc64le                                        v1.10.0-41-g6c5189c916dc17   9e4015925661   43 minutes ago      48.7MB
cert-manager-ctl-s390x                                          v1.10.0-41-g6c5189c916dc17   ee4ce58a3ab4   43 minutes ago      52.5MB
cert-manager-ctl-arm64                                          v1.10.0-41-g6c5189c916dc17   7848746d41a2   44 minutes ago      48.2MB
cert-manager-ctl-amd64                                          v1.10.0-41-g6c5189c916dc17   f013b7b64828   44 minutes ago      49.8MB
cert-manager-acmesolver-arm                                     v1.10.0-41-g6c5189c916dc17   1bec03d254c4   44 minutes ago      27.4MB
cert-manager-acmesolver-ppc64le                                 v1.10.0-41-g6c5189c916dc17   fb2c34baefaf   44 minutes ago      27.6MB
cert-manager-acmesolver-s390x                                   v1.10.0-41-g6c5189c916dc17   2f5fb73c034e   45 minutes ago      30.1MB
cert-manager-acmesolver-arm64                                   v1.10.0-41-g6c5189c916dc17   54003f40e797   45 minutes ago      27.6MB
cert-manager-acmesolver-amd64                                   v1.10.0-41-g6c5189c916dc17   48db6dba2dbb   45 minutes ago      28.3MB
cert-manager-cainjector-arm                                     v1.10.0-41-g6c5189c916dc17   3cec10e9eee7   47 minutes ago      36.6MB
cert-manager-cainjector-ppc64le                                 v1.10.0-41-g6c5189c916dc17   0ef2fad8ae57   47 minutes ago      37.4MB
cert-manager-cainjector-s390x                                   v1.10.0-41-g6c5189c916dc17   577e25e3b5bd   47 minutes ago      40.5MB
cert-manager-cainjector-arm64                                   v1.10.0-41-g6c5189c916dc17   2132e044983d   47 minutes ago      37MB
cert-manager-cainjector-amd64                                   v1.10.0-41-g6c5189c916dc17   5474686e6486   47 minutes ago      38.2MB
cert-manager-webhook-arm                                        v1.10.0-41-g6c5189c916dc17   59fb99a61413   51 minutes ago      42.7MB
cert-manager-webhook-ppc64le                                    v1.10.0-41-g6c5189c916dc17   e3440ec5e49b   51 minutes ago      44.2MB
cert-manager-webhook-s390x                                      v1.10.0-41-g6c5189c916dc17   43f2f39cb2e9   51 minutes ago      47.4MB
cert-manager-webhook-arm64                                      v1.10.0-41-g6c5189c916dc17   0876bb4bd878   51 minutes ago      43.9MB
cert-manager-webhook-amd64                                      v1.10.0-41-g6c5189c916dc17   01fcf9d5a218   52 minutes ago      45MB
cert-manager-controller-arm                                     v1.10.0-41-g6c5189c916dc17   10685c5f8302   About an hour ago   56.3MB
cert-manager-controller-ppc64le                                 v1.10.0-41-g6c5189c916dc17   53c9eef33778   About an hour ago   58.8MB
cert-manager-controller-s390x                                   v1.10.0-41-g6c5189c916dc17   36d852ca8178   About an hour ago   62.6MB
cert-manager-controller-arm64                                   v1.10.0-41-g6c5189c916dc17   7300f651b401   About an hour ago   58.2MB
cert-manager-controller-amd64                                   v1.10.0-41-g6c5189c916dc17   640d4e9e64f3   About an hour ago   60MB
```

#### cert-manager-ctl-amd64:v1.10.0-41-g6c5189c916dc17
```shell
_bin/tools/trivy image cert-manager-ctl-amd64:v1.10.0-41-g6c5189c916dc17

2022-11-11T15:04:19.308+0530	INFO	Vulnerability scanning is enabled
2022-11-11T15:04:19.308+0530	INFO	Secret scanning is enabled
2022-11-11T15:04:19.308+0530	INFO	If your scanning is slow, please try '--security-checks vuln' to disable secret scanning
2022-11-11T15:04:19.308+0530	INFO	Please see also https://aquasecurity.github.io/trivy/v0.32/docs/secret/scanning/#recommendation for faster secret detection
2022-11-11T15:04:19.337+0530	INFO	Detected OS: debian
2022-11-11T15:04:19.337+0530	INFO	Detecting Debian vulnerabilities...
2022-11-11T15:04:19.337+0530	INFO	Number of language-specific files: 1
2022-11-11T15:04:19.337+0530	INFO	Detecting gobinary vulnerabilities...

cert-manager-ctl-amd64:v1.10.0-41-g6c5189c916dc17 (debian 11.5)

Total: 0 (UNKNOWN: 0, LOW: 0, MEDIUM: 0, HIGH: 0, CRITICAL: 0)
```

#### cert-manager-acmesolver-amd64:v1.10.0-41-g6c5189c916dc17
```shell
_bin/tools/trivy image cert-manager-acmesolver-amd64:v1.10.0-41-g6c5189c916dc17
2022-11-11T15:06:13.944+0530	INFO	Vulnerability scanning is enabled
2022-11-11T15:06:13.944+0530	INFO	Secret scanning is enabled
2022-11-11T15:06:13.944+0530	INFO	If your scanning is slow, please try '--security-checks vuln' to disable secret scanning
2022-11-11T15:06:13.944+0530	INFO	Please see also https://aquasecurity.github.io/trivy/v0.32/docs/secret/scanning/#recommendation for faster secret detection
2022-11-11T15:06:13.970+0530	INFO	Detected OS: debian
2022-11-11T15:06:13.970+0530	INFO	Detecting Debian vulnerabilities...
2022-11-11T15:06:13.970+0530	INFO	Number of language-specific files: 1
2022-11-11T15:06:13.970+0530	INFO	Detecting gobinary vulnerabilities...

cert-manager-acmesolver-amd64:v1.10.0-41-g6c5189c916dc17 (debian 11.5)

Total: 0 (UNKNOWN: 0, LOW: 0, MEDIUM: 0, HIGH: 0, CRITICAL: 0)
```

#### cert-manager-cainjector-amd64:v1.10.0-41-g6c5189c916dc17
```shell
_bin/tools/trivy image cert-manager-cainjector-amd64:v1.10.0-41-g6c5189c916dc17
2022-11-11T15:07:23.633+0530	INFO	Vulnerability scanning is enabled
2022-11-11T15:07:23.633+0530	INFO	Secret scanning is enabled
2022-11-11T15:07:23.633+0530	INFO	If your scanning is slow, please try '--security-checks vuln' to disable secret scanning
2022-11-11T15:07:23.633+0530	INFO	Please see also https://aquasecurity.github.io/trivy/v0.32/docs/secret/scanning/#recommendation for faster secret detection
2022-11-11T15:07:23.662+0530	INFO	Detected OS: debian
2022-11-11T15:07:23.662+0530	INFO	Detecting Debian vulnerabilities...
2022-11-11T15:07:23.662+0530	INFO	Number of language-specific files: 1
2022-11-11T15:07:23.662+0530	INFO	Detecting gobinary vulnerabilities...

cert-manager-cainjector-amd64:v1.10.0-41-g6c5189c916dc17 (debian 11.5)

Total: 0 (UNKNOWN: 0, LOW: 0, MEDIUM: 0, HIGH: 0, CRITICAL: 0)
```

#### cert-manager-webhook-amd64:v1.10.0-41-g6c5189c916dc17
```shell
_bin/tools/trivy image cert-manager-webhook-amd64:v1.10.0-41-g6c5189c916dc17
2022-11-11T15:08:35.164+0530	INFO	Vulnerability scanning is enabled
2022-11-11T15:08:35.164+0530	INFO	Secret scanning is enabled
2022-11-11T15:08:35.164+0530	INFO	If your scanning is slow, please try '--security-checks vuln' to disable secret scanning
2022-11-11T15:08:35.164+0530	INFO	Please see also https://aquasecurity.github.io/trivy/v0.32/docs/secret/scanning/#recommendation for faster secret detection
2022-11-11T15:08:35.196+0530	INFO	Detected OS: debian
2022-11-11T15:08:35.196+0530	INFO	Detecting Debian vulnerabilities...
2022-11-11T15:08:35.196+0530	INFO	Number of language-specific files: 1
2022-11-11T15:08:35.196+0530	INFO	Detecting gobinary vulnerabilities...

cert-manager-webhook-amd64:v1.10.0-41-g6c5189c916dc17 (debian 11.5)

Total: 0 (UNKNOWN: 0, LOW: 0, MEDIUM: 0, HIGH: 0, CRITICAL: 0)
```

#### cert-manager-controller-amd64:v1.10.0-41-g6c5189c916dc17
```shell
_bin/tools/trivy image cert-manager-controller-amd64:v1.10.0-41-g6c5189c916dc17
2022-11-11T15:09:16.093+0530	INFO	Vulnerability scanning is enabled
2022-11-11T15:09:16.093+0530	INFO	Secret scanning is enabled
2022-11-11T15:09:16.093+0530	INFO	If your scanning is slow, please try '--security-checks vuln' to disable secret scanning
2022-11-11T15:09:16.093+0530	INFO	Please see also https://aquasecurity.github.io/trivy/v0.32/docs/secret/scanning/#recommendation for faster secret detection
2022-11-11T15:09:16.122+0530	INFO	Detected OS: debian
2022-11-11T15:09:16.122+0530	INFO	Detecting Debian vulnerabilities...
2022-11-11T15:09:16.122+0530	INFO	Number of language-specific files: 1
2022-11-11T15:09:16.122+0530	INFO	Detecting gobinary vulnerabilities...

cert-manager-controller-amd64:v1.10.0-41-g6c5189c916dc17 (debian 11.5)

Total: 0 (UNKNOWN: 0, LOW: 0, MEDIUM: 0, HIGH: 0, CRITICAL: 0)
```
