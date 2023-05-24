### 🚴‍♀️ How to Build Custom Distroless Images From Distroless Tooling 🚴‍♀️

```diff
@@ Lets learn the tricks of the trade by reading commit history of Distroless project @@
@@ We narrow down to Distroless project's NodeJS commit history @@
```

```diff
@@ Origins - May 25, 2017 @@

# https://github.com/GoogleContainerTools/distroless/commit/5a9613d06902f518a80edc0382dc51fe0520a4db

@@ WHAT @@
# nodejs/BUILD
# BUILD.nodejs
# WORKSPACE

@@ HOW @@
# load("@bazel_tools//tools/build_defs/pkg:pkg.bzl", "pkg_tar")
# load("@io_bazel_rules_docker//docker:docker.bzl", "docker_build")
# new_http_archive(sha256=xxx, url=https://nodejs.org/dist/v6.10.3/node-v6.10.3-linux-x64.tar.gz)

@@ USAGE @@
# examples/nodejs/hello_http.js
# examples/nodejs/hello.js
# examples/nodejs/testdata/hello.yaml
# load("@runtimes_common//structure_tests:tests.bzl", "structure_test")
```

```diff
@@ Oct 09, 2017 @@

# https://github.com/GoogleContainerTools/distroless/commit/82c279bf5c797697d76106c8b7285bc0ba3b5134

@@ WHAT @@
# debug busybox

@@ HOW @@
# load("@io_bazel_rules_docker//docker:docker.bzl", "docker_bundle")
# load("@io_bazel_rules_docker//contrib:push-all.bzl", "docker_push")
# package(default_visibility = ["//base:__subpackages__"])
```

```diff
@@ Sep 3, 2020 @@

# https://github.com/GoogleContainerTools/distroless/commit/a09561c78cc2da2ae97891805ed31133f3bc30bf

@@ Naming Conventions @@
# Debian versions X NodeJS versions

@@ CI CD / Usage @@
# bazel run
# docker tag
# load("@io_bazel_rules_docker//container:container.bzl", "container_image")
```

```diff
@@ Oct 1, 2020 @@

# https://github.com/GoogleContainerTools/distroless/commit/2d680191bf29b044a2e0b9d916040d733a725ba9

@@ Multi Architecture Support @@
# Nested for loops looks flat 🔥
```

```diff
@@ Oct 14, 2020 @@

# https://github.com/GoogleContainerTools/distroless/commit/40976b8b65aec783a7571ad20d7b1fa0cd12c69e

@@ WHAT @@
# Build s390x images on x86 machine
# Added BASE_ARCHITECTURES ["amd64", "arm64"]
# DEBIAN_SECURITY_SNAPSHOT DEBIAN_SNAPSHOT

@@ TIL @@
# Debian package Name to Version mapping
```

```diff
@@ Sep 20, 2021 @@

# https://github.com/GoogleContainerTools/distroless/commit/9c4d532437878c3694aac298b6a279bcd400577e

@@ 3 Major Versions of NodeJS @@
```

### 🥤 Takeaways from the Wild 🥤
```diff
# rules_docker is used by GCP's distroless to place Debian .debs into an image
# google/go-containerregistry is a Go module to interact with images & tarballs & layouts
# crane is a CLI that uses the above (in the same repo) to do the same stuff from the commandline
# `crane append` adds a layer to an image, entirely in the registry, without pulling the image
# For static binaries "crane append" + "crane push" eliminate the need for "docker build"
# Crane also exposes a good library for docker operations if you want to build custom tooling on top
```
