### Shoutout
```yaml
- https://github.com/reproducible-containers/repro-get
```

### Notes
```yaml
- Design: Package: apt-cache show hello                # 🎖️🎖️🎖️
  - SHA256: 35b1508eeee9c1dfba798c4c04304ef0f266990f936a51f165571edf53325cbc
  - Filename: pool/main/h/hello/hello_2.10-2_amd64.deb
- Download_URL: http://debian.notset.fr/snapshot/by-hash/SHA256/35b1508eeee9c1dfba798c4c04304ef0f266990f936a51f165571edf53325cbc
- Design: Package:
  - Version_Codename
```

### Generate SHA256SUMS-amd64
```yaml
- GENERATE: SHA256SUMS-amd64 file via a Dockerfile
- DEVEX: Dockerfile.generate-hash is your SELF CONTAINED SCRIPT that generates file
- DEVEX: Dockerfile.generate-hash is also GENERATED
- DEVEX: All Dockerfiles used at DEV & CI envs
- DEVEX: All Dockerfiles & Files are generated
-
- Design: Dockerfile(s) GENERATEs FILE                       # 🎖️🎖️🎖️
- Design: Dockerfile(s) themselves are generated             # 🎖️🎖️🎖️
```

### Dockerfile.generate-hash
```yaml
- Note: This file is generated
- IDEA: Dockerfile as the Command Runner
- IDEA: Dockerfile as the SELF CONTAINED SCRIPT
- IDEA: One reproducible Dockerfile per GNU Package(s) from Debian to GET the package
- IDEA: One reproducible Dockerfile per BUILD TOOL(s) to GET the tool
- IDEA: One reproducible Dockerfile per OSS COMPONENT IMAGE to BUILD the image
- IDEA: One reproducible Dockerfile per OSS COMPONENT PACKAGE to BUILD the package
- IDEA: One reproducible Dockerfile per OSS COMPONENT PACKAGE BUNDLE to BUILD the package bundle
```
```yaml
- Design: File is generated from CLI
- Design: Generated FILE makes use of the local CLI or CLI from releases
- Design: docker build is used throughout
- Design: One CLI does it all
- Auto_Download: ADD ${REPRO_GET_BINARY_URL} .                 # 🎖️🎖️🎖️
- Auto_Download: ADD ${REPRO_GET_SHA256SUMS_URL} .
- Design: Lots of ARGs even before Dockerfile stages
- Design: A Dockerfile stage to DOWNLOAD the CLI from RELEASES - A Variant
- Design: A Dockerfile stage to COPY the CLI from LOCAL DEV WORKSTATION - Another Variant
- Design: DevEx A Dockerfile stage just to ALIAS one of the above!               # 🎖️🎖️🎖️
- DevEx: docker build is executed with defaults                                  # 🎖️🎖️🎖️
- Literate: DevEx: USAGE, etc. all DOCUMENTED in the generated Dockerfile        # 🎖️🎖️🎖️
- Practices: SOURCE_DATE_EPOCH, DEBIAN_FRONTEND; cache; backports; bind;
```

### Investigate
```yaml
- Version: https://github.com/reproducible-containers/repro-get/pull/94/
- WHAT: /etc/apt/apt.conf.d/docker-clean
- WHAT: /etc/apt/sources.list
- WHAT: /etc/os-release
- WHAT: /etc/apt/apt.conf.d/keep-cache
- WHAT: 'Binary::apt::APT::Keep-Downloaded-Packages "true";'
- WHAT: stat --format=%Y /etc/apt/sources.list
- WHAT: apt-get install -y --no-install-recommends
- WHAT: chmod 444 /out/*
- WHAT: touch --date=@${SOURCE_DATE_EPOCH} /out/*
```
