### 🍬 Motivation 🍬
- Teams feel use of distroless images are limited!
- Is distroless suitable for binaries that depend on shared dependencies e.g. c/c++ projects?
- Can distroless go beyond minimalism i.e. from minimal size to size that is accounted?
- What is distroless' answer to securing Software Supply Chain?
- Will understanding Bazel help build custom distroless images?

```diff
@@ Risk Reward Ratio: Learning Bazel vs. Managing thousands of CVEs @@
```

### 🏔️ Destinations 🗻
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
- Command 'bazel' not found, but can be installed with:
- sudo apt install bazel-bootstrap
```

#### ⚙️ [Hands On] Setup Distroless on Bazel On Nix ⚙️
```diff
@@ We will setup Bazel inside a Nix shell instead @@

# This helps us to understand the exact build requirements
# This will avoid use of system installations. Therefore builds will be easy to reproduce
# In the future, we may want to use Nix to configure external dependencies for c/c++ projects

# refer: https://www.tweag.io/blog/2018-03-15-bazel-nix/
```

```diff
@@ Tried with followed in a file called shell.nix @@

{ pkgs ? import <nixpkgs> {} }:

(pkgs.buildFHSUserEnv {
 name = "bazel-userenv-example";
 targetPkgs = pkgs: [
   pkgs.bazel
   pkgs.glibc
   pkgs.gcc
 ];
}).env

@@ However, nix-shell resulted in error @@

- ** (process:782091): ERROR **: 11:14:38.685: bind_mount: mount(source, target, NULL, MS_BIND | MS_REC, NULL): 
- No such file or directory
- Trace/breakpoint trap (core dumped)
```

```diff
@@ Let us find what all Bazel versions are supported in Nix @@

nix-env -qP --available bazel
nixpkgs.bazel    bazel-3.7.2
nixpkgs.bazel_4  bazel-4.2.2
nixpkgs.bazel_5  bazel-5.4.0
nixpkgs.bazel_6  bazel-6.0.0-pre.20220720.3
```

```diff
@@ Lets try with bazel_5 in our shell.nix @@

{ pkgs ? import <nixpkgs> {} }:

(pkgs.buildFHSUserEnv {
  name = "bazel-userenv";
  targetPkgs = pkgs: [
    pkgs.bazel_5
  ];
}).env

@@ Running nix-shell still gave above error @@

- ** (process:784573): ERROR **: 11:29:45.049: bind_mount: mount(source, target, NULL, MS_BIND | MS_REC, NULL): 
- No such file or directory
- Trace/breakpoint trap (core dumped)

@@ Had same error with bazel_4 & bazel_6 as well @@
```

```diff
@@ Tried a different shell.nix @@

{ pkgs ? import <nixpkgs> {} }:

with pkgs;
mkShell {
 packages = [ bazel_6 ];
}
 
@@ Got a different error when executed bazel @@
- ERROR: The project you're trying to build requires Bazel 6.0.0
- (specified in /home/amitd2/work/distroless/.bazelversion), 
- but it wasn't found in /nix/store/qg9zsc4cvi5bhg6ds57rdcw9m17h33v5-bazel-6.0.0-pre.20220720.3/bin.

- Bazel binaries for all official releases can be downloaded from here:
-  https://github.com/bazelbuild/bazel/releases

- Please put the downloaded Bazel binary into this location:
-  /nix/store/qg9zsc4cvi5bhg6ds57rdcw9m17h33v5-bazel-6.0.0-pre.20220720.3/bin/bazel-6.0.0-linux-x86_64
```

```diff
@@ Debugging further @@

ls -ltr /nix/store/qg9zsc4cvi5bhg6ds57rdcw9m17h33v5-bazel-6.0.0-pre.20220720.3/bin/
total 31764
-r-xr-xr-x 1 root root      254 Jan  1  1970 bazel-execlog
-r-xr-xr-x 1 root root 32518044 Jan  1  1970 bazel-6.0.0-pre.20220720.3-linux-x86_64 👈 🧐 🤔
-r-xr-xr-x 1 root root     3363 Jan  1  1970 bazel

@@ Hey, the executable is already there !! @@

@@ Is it a problem in below config? @@
cat /home/amitd2/work/distroless/.bazelversion
6.0.0

@@ Solution: Removing .bazelversion worked @@
# nix-shell
# bazel

@@ Note that distroless project does not use Nix @@

@@ Out final shell.nix looks like below @@

{ pkgs ? import <nixpkgs> {} }:

with pkgs;
mkShell {
 packages = [ bazel_6 ];
}
```

#### 🏃‍♀️ [Hands On] Run distroless on Bazel on Nix 🏃‍♀️
```diff
@@ Execute following from the root of distroless @@
@@ bazel run //base @@

@@ Resulted in Error @@
- ERROR: /home/amitd2/work/distroless/WORKSPACE:96:13: 
- //external:jetty: no such attribute 'add_prefix' in 'http_archive' rule

- ERROR: Encountered error while reading extension file 'rust/repositories.bzl': 
- no such package '@rules_rust//rust': error loading package 'external': Could not load //external package
```

```diff
@@ Try the steps from a test file in distroless @@
# refer: https://github.com/GoogleContainerTools/distroless/blob/main/test.sh

# bazel clean --curses=no
# bazel build --curses=no //...

@@ Resulted in above error @@

- ERROR: /home/amitd2/work/distroless/WORKSPACE:96:13: 
- //external:jetty: no such attribute 'add_prefix' in 'http_archive' rule

- ERROR: Encountered error while reading extension file 'rust/repositories.bzl': 
- no such package '@rules_rust//rust': error loading package 'external': Could not load //external package
```

```diff
@@ Debug if add_prefix is present or not @@

# https://github.com/bazelbuild/bazel/commit/87c8b09061eb4d51271630353b1718c39dfd1ebe
# Above commit introduces add_prefix on Aug 23 2022

@@ What's our Bazel version @@
bazel version
Build label: 6.0.0-pre.20220720.3- (@non-git)
Build target: bazel-out/k8-opt/bin/src/main/java/com/google/devtools/build/lib/bazel/BazelServer_deploy.jar
Build time: Tue Jan 1 00:00:00 1980 (315532800)
Build timestamp: 315532800
Build timestamp as int: 315532800
```

```diff
@@ Let us set Bazel to 6.2.0 release @@
# https://github.com/bazelbuild/bazel/releases/tag/6.2.0


```

