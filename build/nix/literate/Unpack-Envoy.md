## Build Envoy - Docker Way
### What is What
```yaml
- envoy-build-tools repo:
  - Has source code of all the images
  - Provides a Self Contained Environment to BUILD Envoy binary
  - & Run Tests that reflects the latest built Ubuntu Envoy image
```

```yaml
- Docker image envoyproxy/envoy:dev-<hash> has the Envoy binary at /usr/local/bin/envoy
- The <hash> corresponds to the MAIN COMMIt at which the binary was compiled
- envoyproxy/envoy:dev contains an Envoy binary built from the LATEST TIP of MAIN that passed tests
```

```yaml
- MINIMAL images based on Alpine Linux allows quick DEPLOYMENT of Envoy
- Alpine base image is only built with SYMBOLS STRIPPED
- To get the binary with symbols, use the corresponding Ubuntu based DEBUG image
```

```yaml
- Windows 2019 based Envoy Docker image at envoyproxy/envoy-build-windows2019:<hash> is used for CI checks
```

### Hot Takes
```yaml
- envoyproxy/envoy-build-ubuntu: 
  - Ubuntu 20.04 (Focal) with GCC 9 and Clang 14 compiler
- envoyproxy/envoy-build-centos:
  - CentOS 7 with GCC 9 and Clang 14 compiler, this image is experimental and not well tested
- envoyproxy/envoy-build-windows2019:
  - Windows ltsc2019 with VS 2019 Build Tools, as well as LLVM
```

```yaml
- We use the Clang compiler for all Linux CI runs with tests 👈
- We have an additional Linux CI run with GCC which BUILDS the binary ONLY 👈 # WHY
```

### My Hands On Experience
```diff
Step 0: https://github.com/envoyproxy/envoy/tree/main/ci
```

```diff
Step 1: git clone https://github.com/envoyproxy/envoy.git
```

### Build Envoy - Bazel Way
```yaml
- refer: https://github.com/envoyproxy/envoy/tree/main/bazel

```
