### Rules of the Game
```yaml
# TODO
- basics.1: https://github.com/bazelbuild/examples/tree/main
```

```yaml
# TODO
- advanced.1: https://github.com/GoogleContainerTools/distroless
```

### WORKSPACE | Remote Import | rules_rust
```bazel
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
http_archive(
    name = "rules_rust",
    sha256 = "48e715be2368d79bc174efdb12f34acfc89abd7ebfcbffbc02568fcb9ad91536",
    urls = ["https://github.com/bazelbuild/rules_rust/releases/download/0.24.0/rules_rust-v0.24.0.tar.gz"],
)

load("@rules_rust//rust:repositories.bzl", "rules_rust_dependencies", "rust_register_toolchains")
rules_rust_dependencies()
rust_register_toolchains(
    edition = "2018",
    versions = [
        "1.70.0",
        "nightly/2023-06-01",
    ],
)
```

#### Thoughts
```yaml
- Similar to YAML | TOML
- Datatypes | Struct | List | String
- Invokes HTTP | GIT
- Is REPRODUCIBLE
- Community growth via REUSABLE RULES | LOAD/IMPORT
```

### FROM bamnet/bqproxy | In Bazel | WORKSPACE at root folder
```bazel
load("@io_bazel_rules_docker//container:container.bzl", "container_pull")

container_pull(
    name = "bqproxy_latest",
    registry = "index.docker.io",
    repository = "bamnet/bqproxy",
    tag = "latest",
)
```
```yaml
- Above exposes a @{name}//image format
- I.e. @bgproxy_latest//image can be used in bzl files
```

