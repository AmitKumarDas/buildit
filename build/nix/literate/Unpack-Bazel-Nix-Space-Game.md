## Program
```yaml
- main: https://github.com/benradf/space-game
- starter: https://github.com/tweag/nix_bazel_codelab
```

```yaml
- others: https://github.com/benradf
- blog: https://www.tweag.io/blog/2022-12-15-bazel-nix-migration-experience/
```

## Starter
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

### Starter: My Journey
```diff
@@ Step 0: @@
```
```yaml
- repo: https://github.com/tweag/nix_bazel_codelab
- commit: 93dd8eaed74e27b527f46b62736377b8d9949d1a
```
```diff
@@ Step 1: git clone https://github.com/tweag/nix_bazel_codelab.git @@
```
```diff
@@ Step 2: go mod tidy @@
```
```sh
Command 'go' not found
```
```diff
@@ Step 3: nix-shell @@
```
```sh
[nix-shell:~/work/nix_bazel_codelab]$ go version
bash: go: command not found
```
```sh
[nix-shell:~/work/nix_bazel_codelab]$ bazel version
Extracting Bazel installation...
Starting local Bazel server and connecting to it...
Build label: 4.2.1- (@non-git)
Build target: bazel-out/k8-opt/bin/src/main/java/com/google/devtools/build/lib/bazel/BazelServer_deploy.jar
Build time: Tue Jan 1 00:00:00 1980 (315532800)
Build timestamp: 315532800
Build timestamp as int: 315532800
```
```sh
[nix-shell:~/work/nix_bazel_codelab]$ lab
Usage: lab [compare|display|install|help] path/to/BUILD.bazel

    compare: show the differences between the solution and your version
    display: display the solution (aliased to cat and show)
    install: copy the solution, overwrite file if any

Usage: lab install_all

    install_all: copy all the solutions files, overwriting files if any

Example: lab compare go/cmd/server/BUILD.bazel
```
```sh
[nix-shell:~/work/nix_bazel_codelab]$ java --version
openjdk 11.0.17 2022-10-18
OpenJDK Runtime Environment (build 11.0.17+8-post-Ubuntu-1ubuntu222.04)
OpenJDK 64-Bit Server VM (build 11.0.17+8-post-Ubuntu-1ubuntu222.04, mixed mode, sharing)
```

```diff
@@ Step 4: Section 1: Hello Bazel @@
```
```sh
[nix-shell:~/work/nix_bazel_codelab]$ bazel run //java/src/main/java/bazel/bootcamp:HelloBazelBootcamp
warning: unknown setting 'experimental-features'
these derivations will be built:
  /nix/store/3dxfwycgdjg78fk087b2cb7vqx4b4n51-nodejs.drv
these paths will be fetched (18.68 MiB download, 88.98 MiB unpacked):
  /nix/store/3g96vlb1gjw3wnkim3lsjdm1g8a7qziw-icu4c-67.1
  /nix/store/6irxz4fbf1d1ac7wvdjf8cqb3sgmnvg8-zlib-1.2.11-dev
  /nix/store/9ywbwnbmdnbdd5mmjpw8xahq5rf7hvnw-http-parser-2.9.4
  /nix/store/d0rzva0zy5lgdbacxwswfkg91wiqn45y-icu4c-67.1-dev
  /nix/store/irr034r9sv783lagbdn7gy4pcmkld2wv-nodejs-10.24.1
  /nix/store/vf93dl6kzkwdwjbd32ys4mb94v3hbhpb-libuv-1.42.0
/nix/store/lif05q7hxk5n85zza5k056njq9z08zjn-nodejs
ERROR: Skipping '//java/src/main/java/bazel/bootcamp:HelloBazelBootcamp': no such target '//java/src/main/java/bazel/bootcamp:HelloBazelBootcamp': target 'HelloBazelBootcamp' not declared in package 'java/src/main/java/bazel/bootcamp' defined by /home/amitd2/work/nix_bazel_codelab/java/src/main/java/bazel/bootcamp/BUILD.bazel
WARNING: Target pattern parsing failed.
ERROR: no such target '//java/src/main/java/bazel/bootcamp:HelloBazelBootcamp': target 'HelloBazelBootcamp' not declared in package 'java/src/main/java/bazel/bootcamp' defined by /home/amitd2/work/nix_bazel_codelab/java/src/main/java/bazel/bootcamp/BUILD.bazel
INFO: Elapsed time: 45.323s
INFO: 0 processes.
FAILED: Build did NOT complete successfully (1 packages loaded)
FAILED: Build did NOT complete successfully (1 packages loaded)
```

## Main
### Main: What is What

### Main: Takeaways


## Blog
### Blog: Takeaways

## Others: New .md file?
