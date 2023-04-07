#### Building Secure Supply Chain with GNU Guix
```yaml
- https://arxiv.org/pdf/2206.14606v1.pdf
```
```yaml
- a model and tool to authenticate new Git revisions
- Git checkout authentication is applicable beyond the specific use case of Guix

- Focuses on attestation—certifying each link of the supply chain
- Enabling independent verification of each step
- Reproducible builds, “bootstrappable” builds, and Provenance Tracking

- Reproducible Deployment, Reproducible and Verifiable builds, and Provenance Tracking
```

```yaml
- guix install python # installs the Python interpreter
- guix pull # updates Guix itself and the set of available packages
- guix upgrade # upgrades previously-installed packages to their latest available version
- Package management is per-user rather than system-wide
- it does not require system administrator privileges, nor does it require mutual trust among users
```

```yaml
- guix shell # creates a one-off development environment containing the given packages
- guix pack # creates standalone application bundles or container images 
  - providing one or more software packages and all the packages they depend on at run time
  - The container images can be loaded by Docker, podman, and similar container tools
```
