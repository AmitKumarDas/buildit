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

```yaml
- # ---
- # Idea: Developer Environments @ 21 Sep 2023
- # ---
- devenvs/my_cli.go
- devenvs/Dockerfile.my_cli.tpl
- Generate a Dockerfile to INSTALL (or RUN) specific version of my_cli
- Generate the Dockerfile by embedding the Dockerfile.my_cli.tpl
- my_cli.go's Generate() can be IMPORTED by other go projects
- Maybe: go install github.com/someone/project/cmd/my_cli@rev
- Maybe: go run github.com/someone/project/cmd/my_cli@rev
- Maybe: rev is a Dockerfile ARG to set my_cli version
- Maybe: rev defaults to main
```

```yaml
- # ---
- # Design: Adapters & Interfaces: Single Contract Interface @ 23 Sep 2023
- # ---
- Create a Writer Interface that exposes Write()
- Create a FileGenerator Interface that exposes GenerateFile()
- Create an FileGenWriteAdapter struct that composes FileGenerator Interface
- FileGenWriteAdapter implements Writer using FileGenerator
```
