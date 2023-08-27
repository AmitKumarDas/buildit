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
- What: GENERATE SHA256SUMS-amd64 file via docker build in current directory
  - REPRO: DEVEX: Dockerfile.generate-hash is your SELF CONTAINED SCRIPT
  - DEVEX: IDEAL: All Dockerfiles used at DEV & CI envs
  - CMD: CONSUMER: docker build --output . -f Dockerfile.generate-hash .
  - TIP: Dockerfile(s) to GENERATE FILE         # 🎖️🎖️🎖️
```

### Commits
```yaml
- version: https://github.com/reproducible-containers/repro-get/pull/94/
```
