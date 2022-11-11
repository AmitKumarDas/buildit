## Notes
- These tar files were built on my Mac workstation using cert-manager's `make` targets
  - refer: ./build-on-mac.md
- These scans were done on 11-Nov-2022

### make trivy-scan-all
```shell
make trivy-scan-all
```

```shell
ls -ltr _bin/downloaded/tools/
```

```shell
ls -ltr _bin/tools/
```

### Scan cert-manager-controller-linux-amd64.tar
```shell
_bin/tools/trivy image --input _bin/containers/cert-manager-controller-linux-amd64.tar
2022-11-11T14:44:10.527+0530	INFO	Vulnerability scanning is enabled
2022-11-11T14:44:10.527+0530	INFO	Secret scanning is enabled
2022-11-11T14:44:10.527+0530	INFO	If your scanning is slow, please try '--security-checks vuln' to disable secret scanning
2022-11-11T14:44:10.527+0530	INFO	Please see also https://aquasecurity.github.io/trivy/v0.32/docs/secret/scanning/#recommendation for faster secret detection
2022-11-11T14:44:10.537+0530	INFO	Detected OS: debian
2022-11-11T14:44:10.537+0530	INFO	Detecting Debian vulnerabilities...
2022-11-11T14:44:10.537+0530	INFO	Number of language-specific files: 1
2022-11-11T14:44:10.537+0530	INFO	Detecting gobinary vulnerabilities...

_bin/containers/cert-manager-controller-linux-amd64.tar (debian 11.5)

Total: 0 (UNKNOWN: 0, LOW: 0, MEDIUM: 0, HIGH: 0, CRITICAL: 0)
```

### Scan cert-manager-acmesolver-linux-amd64.tar
```shell
_bin/tools/trivy image --input _bin/containers/cert-manager-acmesolver-linux-amd64.tar
2022-11-11T14:47:53.466+0530	INFO	Vulnerability scanning is enabled
2022-11-11T14:47:53.466+0530	INFO	Secret scanning is enabled
2022-11-11T14:47:53.466+0530	INFO	If your scanning is slow, please try '--security-checks vuln' to disable secret scanning
2022-11-11T14:47:53.466+0530	INFO	Please see also https://aquasecurity.github.io/trivy/v0.32/docs/secret/scanning/#recommendation for faster secret detection
2022-11-11T14:47:53.472+0530	INFO	Detected OS: debian
2022-11-11T14:47:53.472+0530	INFO	Detecting Debian vulnerabilities...
2022-11-11T14:47:53.472+0530	INFO	Number of language-specific files: 1
2022-11-11T14:47:53.472+0530	INFO	Detecting gobinary vulnerabilities...

_bin/containers/cert-manager-acmesolver-linux-amd64.tar (debian 11.5)

Total: 0 (UNKNOWN: 0, LOW: 0, MEDIUM: 0, HIGH: 0, CRITICAL: 0)
```

### Scan cert-manager-webhook-linux-amd64.tar
```shell
_bin/tools/trivy image --input _bin/containers/cert-manager-webhook-linux-amd64.tar
2022-11-11T14:48:47.817+0530	INFO	Vulnerability scanning is enabled
2022-11-11T14:48:47.817+0530	INFO	Secret scanning is enabled
2022-11-11T14:48:47.817+0530	INFO	If your scanning is slow, please try '--security-checks vuln' to disable secret scanning
2022-11-11T14:48:47.817+0530	INFO	Please see also https://aquasecurity.github.io/trivy/v0.32/docs/secret/scanning/#recommendation for faster secret detection
2022-11-11T14:48:47.825+0530	INFO	Detected OS: debian
2022-11-11T14:48:47.825+0530	INFO	Detecting Debian vulnerabilities...
2022-11-11T14:48:47.825+0530	INFO	Number of language-specific files: 1
2022-11-11T14:48:47.825+0530	INFO	Detecting gobinary vulnerabilities...

_bin/containers/cert-manager-webhook-linux-amd64.tar (debian 11.5)

Total: 0 (UNKNOWN: 0, LOW: 0, MEDIUM: 0, HIGH: 0, CRITICAL: 0)
```

### Scan cert-manager-cainjector-linux-amd64.tar
```shell
_bin/tools/trivy image --input _bin/containers/cert-manager-cainjector-linux-amd64.tar
2022-11-11T14:49:39.615+0530	INFO	Vulnerability scanning is enabled
2022-11-11T14:49:39.615+0530	INFO	Secret scanning is enabled
2022-11-11T14:49:39.615+0530	INFO	If your scanning is slow, please try '--security-checks vuln' to disable secret scanning
2022-11-11T14:49:39.615+0530	INFO	Please see also https://aquasecurity.github.io/trivy/v0.32/docs/secret/scanning/#recommendation for faster secret detection
2022-11-11T14:49:39.631+0530	INFO	Detected OS: debian
2022-11-11T14:49:39.631+0530	INFO	Detecting Debian vulnerabilities...
2022-11-11T14:49:39.631+0530	INFO	Number of language-specific files: 1
2022-11-11T14:49:39.631+0530	INFO	Detecting gobinary vulnerabilities...

_bin/containers/cert-manager-cainjector-linux-amd64.tar (debian 11.5)

Total: 0 (UNKNOWN: 0, LOW: 0, MEDIUM: 0, HIGH: 0, CRITICAL: 0)
```

### Scan
```shell
_bin/tools/trivy image --input _bin/containers/cert-manager-ctl-linux-amd64.tar
2022-11-11T14:50:05.836+0530	INFO	Vulnerability scanning is enabled
2022-11-11T14:50:05.836+0530	INFO	Secret scanning is enabled
2022-11-11T14:50:05.836+0530	INFO	If your scanning is slow, please try '--security-checks vuln' to disable secret scanning
2022-11-11T14:50:05.836+0530	INFO	Please see also https://aquasecurity.github.io/trivy/v0.32/docs/secret/scanning/#recommendation for faster secret detection
2022-11-11T14:50:05.851+0530	INFO	Detected OS: debian
2022-11-11T14:50:05.851+0530	INFO	Detecting Debian vulnerabilities...
2022-11-11T14:50:05.851+0530	INFO	Number of language-specific files: 1
2022-11-11T14:50:05.851+0530	INFO	Detecting gobinary vulnerabilities...

_bin/containers/cert-manager-ctl-linux-amd64.tar (debian 11.5)

Total: 0 (UNKNOWN: 0, LOW: 0, MEDIUM: 0, HIGH: 0, CRITICAL: 0)
```
