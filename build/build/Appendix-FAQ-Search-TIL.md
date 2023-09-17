```
- ripgrep consists of MANY CRATES
- ripgrep good for CLI | PKG | Build
- .bazelrc in repository root
- By default, Bazel invokes rustc from the stable channel
- Aliter: Invoke the build with --@rules_rust//rust/toolchain/channel=nightly
- Aliter: Add to .bazelrc: build --@rules_rust//rust/toolchain/channel=nightly
```
