### Shoutout
```yaml
- https://github.com/reproducible-containers/repro-get
```

### Notes
```yaml
- Package: apt-cache show hello                # 🎖️🎖️🎖️
  - SHA256: 35b1508eeee9c1dfba798c4c04304ef0f266990f936a51f165571edf53325cbc
  - Filename: pool/main/h/hello/hello_2.10-2_amd64.deb
- Download_URL: http://debian.notset.fr/snapshot/by-hash/SHA256/35b1508eeee9c1dfba798c4c04304ef0f266990f936a51f165571edf53325cbc
```

### Generate SHA256SUMS-amd64
```yaml
- GENERATE: SHA256SUMS-amd64 file via a Dockerfile
- DEVEX: Dockerfile.generate-hash is your SELF CONTAINED SCRIPT that generates file
- DEVEX: Dockerfile.generate-hash is also GENERATED
- DEVEX: All Dockerfiles used at DEV & CI envs
- DEVEX: All Dockerfiles & Files are generated
-
- TIL: Dockerfile(s) GENERATEs FILE                       # 🎖️🎖️🎖️
- TIL: Dockerfile(s) themselves are generated             # 🎖️🎖️🎖️
```

### Dockerfile.generate-hash
```yaml
- Note: This file is generated
- IDEA: Dockerfile as the Command Runner
- IDEA: Dockerfile as the SELF CONTAINED SCRIPT
- IDEA: One reproducible Dockerfile per GNU Package from Debian to GET the package
- IDEA: One reproducible Dockerfile per BUILD TOOL to GET the tool
- IDEA: One reproducible Dockerfile per OSS COMPONENT IMAGE to BUILD the image
- IDEA: One reproducible Dockerfile per OSS COMPONENT PACKAGE to BUILD the package
```
```yaml
- Auto_Download: ADD ${REPRO_GET_BINARY_URL} .                 # 🎖️🎖️🎖️
- Auto_Download: ADD ${REPRO_GET_SHA256SUMS_URL} .
- Design: Lots of ARGs even before Dockerfile stages
- Design: A Dockerfile stage to DOWNLOAD the CLI from RELEASES - A Variant
- Design: A Dockerfile stage to COPY the CLI from LOCAL DEV WORKSTATION - Another Variant
- Design: DevEx A Dockerfile stage just to ALIAS one of the above!               # 🎖️🎖️🎖️

```

### Commits
```yaml
- version: https://github.com/reproducible-containers/repro-get/pull/94/
```
