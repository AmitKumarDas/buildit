### Refer
```yaml
- main: https://github.com/benradf/space-game
- others: https://github.com/benradf
- blog: https://www.tweag.io/blog/2022-12-15-bazel-nix-migration-experience/
- starter: https://github.com/tweag/nix_bazel_codelab/tree/main#nixbazel-codelab
```

### Starter: What is What
```yaml
- WORKSPACE: External Dependencies
- BUILD.bazel: Define Bazel packages & targets in that package
- .bazelrc: Configures Bazel
```

```yaml
- http_archive: Import Bazel Dependencies
- nixpkgs_package: Import Nix Dependencies into Bazel
- nix/: Pinning Nix
- shell.nix: Development Environment that includes Bazel
```

### Starter: Takeaways
```yaml
- Bazel: Rule Sets
- Tool: Buildfier
- Tool: Nix based Development Environment
- Bazel: rules_nixpkgs
- Tool: direnv
```

### Main: What is What

### Main: Takeaways
