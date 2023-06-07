### 🍬 Motivation 🍬
- Teams feel use of distroless images are limited!
- Is distroless suitable for binaries that depend on shared dependencies e.g. c/c++ projects?
- Can distroless go beyond minimalism i.e. from minimal size to size that is accounted?
- What is distroless' answer to securing Software Supply Chain?
- Will understanding Bazel help build custom distroless images?

```diff
@@ Risk Reward Ratio: Learning Bazel vs. Managing thousands of CVEs @@
```

### 🏔️ References 🗻
```diff
# https://github.com/GoogleContainerTools/distroless
# https://github.com/tweag/nix_bazel_codelab
```

### 👩‍🔬 Hands On 👩‍🔬
```diff
@@ Distroless Quick Starter @@

# git clone https://github.com/GoogleContainerTools/distroless.git
# cd distroless
```

```diff
@@ Run 'bazel' command on your terminal @@

# Command 'bazel' NOT FOUND, but can be installed with:
# sudo apt install bazel-bootstrap
```

#### ⚙️ [Hands On] Setup Distroless on Bazel On Nix ⚙️
```diff
@@ We will setup Bazel inside a Nix shell instead @@

# Helps understand the EXACT BUILD requirements
# AVOIDS use of SYSTEM installations
# Builds will be easy to REPRODUCE
# In the future, we may want to use Nix to configure external dependencies for c/c++ projects

# refer: https://www.tweag.io/blog/2018-03-15-bazel-nix/
```

```diff
@@ Attempt 1: shell.nix @@

{ pkgs ? import <nixpkgs> {} }:

(pkgs.buildFHSUserEnv {
 name = "bazel-userenv-example";
 targetPkgs = pkgs: [
   pkgs.bazel
   pkgs.glibc
   pkgs.gcc
 ];
}).env

@@ Error @@

# ** (process:782091): ERROR **: 11:14:38.685: bind_mount: mount(source, target, NULL, MS_BIND | MS_REC, NULL): 
# NO SUCH FILE or DIRECTORY
# Trace/breakpoint trap (core dumped)
```

```diff
@@ Let us FIND what all Bazel VERSIONS are supported in Nix @@

nix-env -qP --available bazel
nixpkgs.bazel    bazel-3.7.2
nixpkgs.bazel_4  bazel-4.2.2
nixpkgs.bazel_5  bazel-5.4.0
nixpkgs.bazel_6  bazel-6.0.0-pre.20220720.3
```

```diff
@@ Attempt 2: bazel_5 in shell.nix @@

{ pkgs ? import <nixpkgs> {} }:

(pkgs.buildFHSUserEnv {
  name = "bazel-userenv";
  targetPkgs = pkgs: [
    pkgs.bazel_5
  ];
}).env

@@ Running nix-shell still gave ABOVE error @@
@@ Had same error with bazel_4 & bazel_6 as well @@
```

```diff
@@ Attempt 3: Tried a DIFFERENT shell.nix @@

{ pkgs ? import <nixpkgs> {} }:

with pkgs;
mkShell {
 packages = [ bazel_6 ];
}
 
@@ Got a DIFFERENT ERROR when executed bazel @@
# ERROR: The project you're trying to build requires Bazel 6.0.0
# (specified in /home/amitd2/work/distroless/.bazelversion), 
# but it wasn't found in /nix/store/qg9zsc4cvi5bhg6ds57rdcw9m17h33v5-bazel-6.0.0-pre.20220720.3/bin.
```

```sh
# Attempt 4: Debugging further

ls -ltr /nix/store/qg9zsc4cvi5bhg6ds57rdcw9m17h33v5-bazel-6.0.0-pre.20220720.3/bin/
total 31764
-r-xr-xr-x 1 root root      254 Jan  1  1970 bazel-execlog
-r-xr-xr-x 1 root root 32518044 Jan  1  1970 bazel-6.0.0-pre.20220720.3-linux-x86_64 👈 🧐 🤔
-r-xr-xr-x 1 root root     3363 Jan  1  1970 bazel

# Is it a problem in below config?
cat /home/amitd2/work/distroless/.bazelversion
6.0.0
```

```diff
@@ Attempt 5: Solution: Removing .bazelversion worked @@
# nix-shell
# bazel

@@ Current shell.nix @@

{ pkgs ? import <nixpkgs> {} }:

with pkgs;
mkShell {
 packages = [ bazel_6 ];
}
```

#### 🏃‍♀️ [Hands On] Run distroless on Bazel on Nix 🏃‍♀️
```diff
@@ Attempt 6: Execute following from the root of distroless @@
# bazel run //base

@@ Resulted in Error @@
# ERROR: /home/amitd2/work/distroless/WORKSPACE:96:13: 
# //external:jetty: no such attribute 'add_prefix' in 'http_archive' rule
```

```diff
@@ Attempt 7: Try DIFFERENT steps from a test file in distroless @@
# refer: https://github.com/GoogleContainerTools/distroless/blob/main/test.sh

# bazel clean --curses=no
# bazel build --curses=no //...

@@ Resulted in ABOVE error @@
```

```diff
@@ Attempt 8: Debug if add_prefix is present or not @@

# https://github.com/bazelbuild/bazel/commit/87c8b09061eb4d51271630353b1718c39dfd1ebe
# Above commit introduces add_prefix on Aug 23 2022

@@ Nix Installed Bazel version @@
bazel version
Build label: 6.0.0-pre.20220720.3- (@non-git)
Build target: bazel-out/k8-opt/bin/src/main/java/com/google/devtools/build/lib/bazel/BazelServer_deploy.jar
Build time: Tue Jan 1 00:00:00 1980 (315532800)
Build timestamp: 315532800
Build timestamp as int: 315532800
```

```diff
@@ Attempt 9: BUMP Bazel based on the commit from lazamar.co.uk site @@
```

```nix
# shell.nix
# Refer: https://lazamar.co.uk/nix-versions/?channel=nixpkgs-unstable&package=bazel

{ pkgs ? import (builtins.fetchTarball {
  url = "https://github.com/NixOS/nixpkgs/archive/8ad5e8132c5dcf977e308e7bf5517cc6cc0bf7d8.tar.gz";
}) {} }:

with pkgs;
mkShell {
  packages = [ bazel_6 ];
}
```

```sh
bazel version
Build label: 6.0.0- (@non-git)
Build target: bazel-out/k8-opt/bin/src/main/java/com/google/devtools/build/lib/bazel/BazelServer_deploy.jar
Build time: Tue Jan 1 00:00:00 1980 (315532800)
Build timestamp: 315532800
Build timestamp as int: 315532800
```

```sh
bazel run //base
ERROR: Skipping '//base': no such target '//base:base': target 'base' not declared in package 'base' defined by /home/amitd2/work/distroless/base/BUILD (Tip: use `query "//base:*"` to see all the targets in that package)
WARNING: Target pattern parsing failed.
ERROR: no such target '//base:base': target 'base' not declared in package 'base' defined by /home/amitd2/work/distroless/base/BUILD (Tip: use `query "//base:*"` to see all the targets in that package)
INFO: Elapsed time: 0.091s
INFO: 0 processes.
FAILED: Build did NOT complete successfully (0 packages loaded)
ERROR: Build failed. Not running target
```
