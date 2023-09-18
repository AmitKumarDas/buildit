```yaml
- ripgrep consists of MANY CRATES
- ripgrep good for CLI | PKG | Build
- .bazelrc in repository root
- By default, Bazel invokes rustc from the stable channel
- Aliter: Invoke the build with --@rules_rust//rust/toolchain/channel=nightly
- Aliter: Add to .bazelrc: build --@rules_rust//rust/toolchain/channel=nightly
- crate_universe: Generate Bazel targets from Cargo.lock files, for external dependencies
- If Bazel needs to download remotely need to be specified in a top-level WORKSPACE file
- Dockerhub Registry: index.docker.io
- Google Container Registry: gcr.io
- Gitlab Container Registry: registry.gitlab.com
- Github Packages: docker.pkg.github.com
```
