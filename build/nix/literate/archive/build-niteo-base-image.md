### ❌ Scenario: Use the OpenSSL Fix Available in Latest Nixpkgs i.e. un-released

```diff
@@ Approach 1: Update Nix packages to unstable release @@

! This should hopefully include the OpenSSL fix
```

```diff
@@ References @@

# https://github.com/NixOS/nixpkgs/commit/15cf84feea87949eb01b9b6e631246fe6991cd3a # 👈 openssl: 3.0.7 -> 3.0.8
# https://github.com/nixos/nixpkgs/tree/nixos-unstable # 👈 unstable branch
# https://nix.dev/tutorials/towards-reproducibility-pinning-nixpkgs # 👍
# https://nixos.wiki/wiki/FAQ/Pinning_Nixpkgs

# This helps picking up a specific commit
! https://status.nixos.org/
```

```diff
@@ Approach 1: Step 1: Inspect the nixpkgs channel @@

# sudo nix-channel --list
! nixpkgs https://nixos.org/channels/nixpkgs-unstable
```

```diff
@@ Approach 1: Step 2: use niv for dependency management @@

# nix-shell -p niv --run "niv init"
# nix-shell -p niv
# niv show
```
```sh
nixpkgs
  branch: release-21.05
  description: Nix Packages collection
  homepage: 
  owner: NixOS
  repo: nixpkgs
  rev: 5f244caea76105b63d826911b2a1563d33ff1cdc
  sha256: 1xlgynfw9svy7nvh9nkxsxdzncv9hg99gbvbwv3gmrhmzc3sar75
  type: tarball
  url: https://github.com/NixOS/nixpkgs/archive/5f244caea76105b63d826911b2a1563d33ff1cdc.tar.gz
  url_template: https://github.com/<owner>/<repo>/archive/<rev>.tar.gz
```

```diff
@@ Approach 1: Step 3 @@

# niv update nixpkgs
# niv show
```
```sh
nixpkgs
  branch: release-21.05
  description: Nix Packages collection
  homepage: 
  owner: NixOS
  repo: nixpkgs
  rev: 022caabb5f2265ad4006c1fa5b1ebe69fb0c3faf
  sha256: 12q00nbd7fb812zchbcnmdg3pw45qhxm74hgpjmshc2dfmgkjh4n
  type: tarball
  url: https://github.com/NixOS/nixpkgs/archive/022caabb5f2265ad4006c1fa5b1ebe69fb0c3faf.tar.gz
  url_template: https://github.com/<owner>/<repo>/archive/<rev>.tar.gz
```

```diff
@@ Approach 1: Step 4 @@

# niv modify nixpkgs -a branch=nixpkgs-unstable
# niv show

# Following output shows that git details has not changed
# However, branch name has changed
```
```sh
nixpkgs
  branch: nixpkgs-unstable
  .. same as earlier ..
```

```diff
@@ Approach 1: Step 5: Do not forget to run update command for changes to take effect @@

! niv update nixpkgs
# niv show

@@ Hi.. I am from future @@
@@ [Future]: Have you verified the updated revision
- We are not sure if this nixpkgs revision from unstable branch has passed in its CI
```
```sh
nixpkgs
  branch: nixpkgs-unstable
  description: Nix Packages collection
  homepage: 
  owner: NixOS
  repo: nixpkgs
  rev: 639d4f17218568afd6494dbd807bebb2beb9d6b3
  sha256: 04lvyqiv58g6w65r8b4jyfja3qsh2ckkv54a21zlmi0k34qnhrm6
  type: tarball
  url: https://github.com/NixOS/nixpkgs/archive/639d4f17218568afd6494dbd807bebb2beb9d6b3.tar.gz
  url_template: https://github.com/<owner>/<repo>/archive/<rev>.tar.gz
```

```diff
@@ Approach 1: Step 6: Back to our original nix file & Dockerfile @@

# Refer: https://github.com/teamniteo/nix-docker-base
! Advised to update the Dockerfile FROM statement with the nixpkgs version used locally

# nix-shell -p niv
# niv update nixpkgs
# channel=$(jq -r .nixpkgs.branch nix/sources.json)
# rev=$(jq -r .nixpkgs.rev nix/sources.json)
# sed -i "s#FROM.*AS build#FROM niteo/nixpkgs-$channel:$rev AS build#g" Dockerfile
```

```sh
tree
.
├── Dockerfile
├── default.nix
└── nix
    ├── sources.json
    └── sources.nix

2 directories, 4 files
```

```nix
# This is a Nix file named default.nix
let
  # pkgs = import <nixpkgs> {}; # 👈 Original
  pkgs = (import nix/sources.nix).nixpkgs; # 🎉
in {
  myEnv = pkgs.buildEnv {
    name = "env";
    paths = with pkgs; [
      curl # 👈 either built from source or its prebuilt binary is fetched
      cacert # 👈 either built from source or its prebuilt binary is fetched
    ];
  };
}
```

```Dockerfile
# FROM niteo/nixpkgs-nixos-22.11:ea96b4af6148114421fda90df33cf236ff5ecf1d AS build # 👈 Original
FROM niteo/nixpkgs-nixpkgs-unstable:639d4f17218568afd6494dbd807bebb2beb9d6b3 AS build

# same as original
```

```diff
! docker build . -t tryme:latest-1

- ERROR [internal] load metadata for docker.io/niteo/nixpkgs-nixpkgs-unstable:639d4f17218568afd6494dbd807bebb2beb9d6b3      2.2s
- > [internal] load metadata for docker.io/niteo/nixpkgs-nixpkgs-unstable:639d4f17218568afd6494dbd807bebb2beb9d6b3:
- failed to solve with frontend dockerfile.v0: 
-  failed to create LLB definition: pull access denied, repository does not exist or may require authorization: 
-  server message: insufficient_scope: authorization failed
```

```diff
@@ Approach 1: Step 7: Most likely niteo does not have a base image with above combination @@

# We shall create a base image with above combination
# Follow the steps shown below:

@@ Approach 1: Steps 7.1: Work with nix-docker-base code base @@

# git clone git@github.com:teamniteo/nix-docker-base.git
# cd nix-docker-base
# nix-shell -p niv 
# niv show
# niv init # It asked to run 'niv init'
# git status
# niv show
# niv modify nixpkgs -a branch=nixpkgs-unstable
# niv update nixpkgs
# niv show
```

```diff
@@ Approach 1: Steps 7.2: Build the base image @@

! https://github.com/teamniteo/nix-docker-base/blob/master/.github/workflows/push.yml
# REGISTRY_USER=amitd nix-shell --run 'scripts/image-update test "$PWD" nixos-unstable  16'
```

```sh
Package ‘glibc-2.37-8’ in /nix/store/rxk626qrhsg0xlddbhb0vc05547vlyb3-nixpkgs-src/pkgs/development/libraries/glibc/default.nix:166 is not available on the requested hostPlatform:
         hostPlatform.config = "aarch64-apple-darwin"
         package.meta.platforms = [
           "aarch64-linux"
           "armv5tel-linux"
           "armv6l-linux"
           "armv7a-linux"
           "armv7l-linux"
           "i686-linux"
           "m68k-linux"
           "microblaze-linux"
           "microblazeel-linux"
           "mipsel-linux"
           "mips64el-linux"
           "powerpc64-linux"
           "powerpc64le-linux"
           "riscv32-linux"
           "riscv64-linux"
           "s390-linux"
           "s390x-linux"
           "x86_64-linux"
         ]
         package.meta.badPlatforms = [ ]
       , refusing to evaluate.
```

```diff
@@ Approach 1: Steps 7.3: @@

# I was running above on my Mac
# Let us redo the steps on a Linux machine

# git clone  https://github.com/teamniteo/nix-docker-base.git
# cd nix-docker-base
# nix-shell -p niv 
# niv init
# git status
# niv update nixpkgs
```
```diff
- FATAL: Cannot get latest revision for branch 'nixos-unstable' (NixOS/nixpkgs)
- The request failed: Response {responseStatus = Status {statusCode = 403, statusMessage = "rate limit exceeded"}
```

```diff
@@ Approach 1: Steps 7.4: Authenticate to do away with GH rate exceeded error @@

# Generate a Personal Account Token at GitHub from GitHub UI
# Save the token in mytoken.txt
# [optional] gh auth login --with-token < mytoken.txt
# GITHUB_TOKEN=$(cat mytoken.txt) niv update nixpkgs # 🔥
# niv show
```

```diff
@@ Approach 1: Steps 7.5: Try Again: Build the base image @@

# exit # exits nix shell
# REGISTRY_USER=amitd nix-shell --run 'scripts/image-update test "$PWD" nixos-unstable  16' # 🔥
! This might take time. No pre built binaries / caches for unstable release
```
```sh
Cooking the image...
Finished.
Image built successfully
Testing image..
Running tests for /nix/store/g38pgn5sjs9v80qkkzsrb5g6vr5d0c3k-docker-image-nixpkgs.tar.gz..
Loading built image into docker..
❌ open /nix/store/g38pgn5sjs9v80qkkzsrb5g6vr5d0c3k-docker-image-nixpkgs.tar.gz: no such file or directory
Failed to load the built image into docker
Image tests failed
```

```diff
@@ Approach 1: Steps 7.6: Wait! Above tar file is available @@

! ll /nix/store/g38pgn5sjs9v80qkkzsrb5g6vr5d0c3k-docker-image-nixpkgs.tar.gz
```
```sh
-r--r--r-- 1 root root 126629663 Jan  1  1970 /nix/store/g38pgn5sjs9v80qkkzsrb5g6vr5d0c3k-docker-image-nixpkgs.tar.gz
```

```diff
@@ Steps 7.7: Load the tar to docker @@

- Note: We will deal with above error later
! docker load < /nix/store/g38pgn5sjs9v80qkkzsrb5g6vr5d0c3k-docker-image-nixpkgs.tar.gz
# docker images # ✅
```
```
REPOSITORY                  TAG                                        IMAGE ID       CREATED         SIZE
nixpkgs                     g38pgn5sjs9v80qkkzsrb5g6vr5d0c3k           3ba87715ee0b   6 minutes ago   390MB
```

```diff
@@ Approach 1: Steps 7.7: Retry Step 6 @@

# Following is the Dockerfile with updated FROM statement
```
```Dockerfile
FROM nixpkgs:g38pgn5sjs9v80qkkzsrb5g6vr5d0c3k AS build

# Rest all remain same
```
```diff
- Step 3/7 : RUN   nix-env -f src -iA myEnv --option filter-syscalls false   && export-profile /dist
- ---> Running in 0fde15823a86
- error: attribute 'buildEnv' missing
-       at /root/src/default.nix:7:11:
-            6|   inherit pkgs;
-            7|   myEnv = pkgs.buildEnv {
-             |           ^
-            8|     name = "env";
```

```diff
@@ Approach 1: Steps 7.8: Fix niv imports @@
```
```nix
# This is a Nix file named default.nix
{ sources ? import nix/sources.nix }: # import
let
  # pkgs = import <nixpkgs> {}; # 👈 Original
  pkgs = import sources.nixpkgs { overlays = [] ; config = {}; }; # use
in {
  myEnv = pkgs.buildEnv {
    name = "env";
    paths = with pkgs; [
      curl # 👈 either built from source or its prebuilt binary is fetched
      cacert # 👈 either built from source or its prebuilt binary is fetched
    ];
  };
}
```
```diff
# docker build . -t tryme:2
```
```sh
docker images
REPOSITORY                  TAG                                        IMAGE ID       CREATED          SIZE
tryme                       2                                          d7b9cfbf3bb5   7 seconds ago    44.2MB
<none>                      <none>                                     f60e95b89486   10 seconds ago   666MB
<none>                      <none>                                     8cf30a1f122f   6 minutes ago    390MB
<none>                      <none>                                     c082bb8cf7f3   8 minutes ago    390MB
<none>                      <none>                                     77fb5c12ff25   9 minutes ago    390MB
<none>                      <none>                                     6fb26132c6ed   2 hours ago      390MB
<none>                      <none>                                     06167f3ef5b4   2 hours ago      390MB
<none>                      <none>                                     b1282b330c3c   2 hours ago      390MB
nixpkgs                     g38pgn5sjs9v80qkkzsrb5g6vr5d0c3k           3ba87715ee0b   3 hours ago      390MB
```

```diff
@@ Approach 1: Steps 7.9: Did it work? @@

# We shall build the result & run against scanners
# nix build -f default.nix
# nix run github:tiiuae/sbomnix#vulnxscan -- ./result
```
```sh
INFO     Generating SBOM for target '/nix/store/bi9p0hwyxqc8qwx2viscf9a5qf171iva-env'
INFO     Loading runtime dependencies referenced by '/nix/store/bi9p0hwyxqc8qwx2viscf9a5qf171iva-env'
INFO     Using SBOM '/tmp/vulnxscan_8zu1e2t_.json'
INFO     Running vulnix scan
INFO     Running grype scan
INFO     Running OSV scan
INFO     Querying vulnerabilities
INFO     Console report

Potential vulnerabilities impacting 'result' or some of its runtime dependencies:

| vuln_id        | url                                             | package   | version   |  grype  |  osv  |  vulnix  |  sum  |
|----------------+-------------------------------------------------+-----------+-----------+---------+-------+----------+-------|
| CVE-2023-27534 | https://nvd.nist.gov/vuln/detail/CVE-2023-27534 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2023-27533 | https://nvd.nist.gov/vuln/detail/CVE-2023-27533 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2023-23916 | https://nvd.nist.gov/vuln/detail/CVE-2023-23916 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2023-0466  | https://nvd.nist.gov/vuln/detail/CVE-2023-0466  | openssl   | 1.1.1k    |    1    |   0   |    1     |   2   |
| CVE-2023-0465  | https://nvd.nist.gov/vuln/detail/CVE-2023-0465  | openssl   | 1.1.1k    |    1    |   0   |    1     |   2   |
| CVE-2023-0464  | https://nvd.nist.gov/vuln/detail/CVE-2023-0464  | openssl   | 1.1.1k    |    1    |   0   |    1     |   2   |
| CVE-2023-0286  | https://nvd.nist.gov/vuln/detail/CVE-2023-0286  | openssl   | 1.1.1k    |    1    |   0   |    1     |   2   |
| CVE-2023-0215  | https://nvd.nist.gov/vuln/detail/CVE-2023-0215  | openssl   | 1.1.1k    |    1    |   0   |    1     |   2   |
| CVE-2022-43552 | https://nvd.nist.gov/vuln/detail/CVE-2022-43552 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2022-37434 | https://nvd.nist.gov/vuln/detail/CVE-2022-37434 | zlib      | 1.2.11    |    0    |   0   |    1     |   1   |
| CVE-2022-35252 | https://nvd.nist.gov/vuln/detail/CVE-2022-35252 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2022-32221 | https://nvd.nist.gov/vuln/detail/CVE-2022-32221 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2022-32208 | https://nvd.nist.gov/vuln/detail/CVE-2022-32208 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2022-32207 | https://nvd.nist.gov/vuln/detail/CVE-2022-32207 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2022-32206 | https://nvd.nist.gov/vuln/detail/CVE-2022-32206 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2022-32205 | https://nvd.nist.gov/vuln/detail/CVE-2022-32205 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2022-27782 | https://nvd.nist.gov/vuln/detail/CVE-2022-27782 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2022-27781 | https://nvd.nist.gov/vuln/detail/CVE-2022-27781 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2022-27776 | https://nvd.nist.gov/vuln/detail/CVE-2022-27776 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2022-27775 | https://nvd.nist.gov/vuln/detail/CVE-2022-27775 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2022-27774 | https://nvd.nist.gov/vuln/detail/CVE-2022-27774 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2022-23219 | https://nvd.nist.gov/vuln/detail/CVE-2022-23219 | glibc     | 2.32-46   |    0    |   0   |    1     |   1   |
| CVE-2022-23218 | https://nvd.nist.gov/vuln/detail/CVE-2022-23218 | glibc     | 2.32-46   |    0    |   0   |    1     |   1   |
| CVE-2022-22576 | https://nvd.nist.gov/vuln/detail/CVE-2022-22576 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2022-4450  | https://nvd.nist.gov/vuln/detail/CVE-2022-4450  | openssl   | 1.1.1k    |    1    |   0   |    1     |   2   |
| CVE-2022-4304  | https://nvd.nist.gov/vuln/detail/CVE-2022-4304  | openssl   | 1.1.1k    |    1    |   0   |    1     |   2   |
| CVE-2022-2097  | https://nvd.nist.gov/vuln/detail/CVE-2022-2097  | openssl   | 1.1.1k    |    1    |   0   |    1     |   2   |
| CVE-2022-2068  | https://nvd.nist.gov/vuln/detail/CVE-2022-2068  | openssl   | 1.1.1k    |    1    |   0   |    1     |   2   |
| CVE-2022-1292  | https://nvd.nist.gov/vuln/detail/CVE-2022-1292  | openssl   | 1.1.1k    |    1    |   0   |    1     |   2   |
| CVE-2022-0778  | https://nvd.nist.gov/vuln/detail/CVE-2022-0778  | openssl   | 1.1.1k    |    1    |   0   |    1     |   2   |
| CVE-2021-38604 | https://nvd.nist.gov/vuln/detail/CVE-2021-38604 | glibc     | 2.32-46   |    0    |   0   |    1     |   1   |
| CVE-2021-27645 | https://nvd.nist.gov/vuln/detail/CVE-2021-27645 | glibc     | 2.32-46   |    0    |   0   |    1     |   1   |
| CVE-2021-22947 | https://nvd.nist.gov/vuln/detail/CVE-2021-22947 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2021-22946 | https://nvd.nist.gov/vuln/detail/CVE-2021-22946 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2021-22926 | https://nvd.nist.gov/vuln/detail/CVE-2021-22926 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2021-22925 | https://nvd.nist.gov/vuln/detail/CVE-2021-22925 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2021-22924 | https://nvd.nist.gov/vuln/detail/CVE-2021-22924 | curl      | 7.76.1    |    0    |   1   |    0     |   1   |
| CVE-2021-22923 | https://nvd.nist.gov/vuln/detail/CVE-2021-22923 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2021-22922 | https://nvd.nist.gov/vuln/detail/CVE-2021-22922 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2021-22901 | https://nvd.nist.gov/vuln/detail/CVE-2021-22901 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2021-22898 | https://nvd.nist.gov/vuln/detail/CVE-2021-22898 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2021-22897 | https://nvd.nist.gov/vuln/detail/CVE-2021-22897 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2021-4160  | https://nvd.nist.gov/vuln/detail/CVE-2021-4160  | openssl   | 1.1.1k    |    1    |   0   |    1     |   2   |
| CVE-2021-3712  | https://nvd.nist.gov/vuln/detail/CVE-2021-3712  | openssl   | 1.1.1k    |    1    |   1   |    1     |   3   |
| CVE-2021-3711  | https://nvd.nist.gov/vuln/detail/CVE-2021-3711  | openssl   | 1.1.1k    |    1    |   1   |    1     |   3   |
| CVE-2019-18276 | https://nvd.nist.gov/vuln/detail/CVE-2019-18276 | bash      | 4.4-p23   |    0    |   0   |    1     |   1   |
| CVE-2019-17498 | https://nvd.nist.gov/vuln/detail/CVE-2019-17498 | libssh2   | 1.9.0     |    1    |   1   |    0     |   2   |
| CVE-2018-25032 | https://nvd.nist.gov/vuln/detail/CVE-2018-25032 | zlib      | 1.2.11    |    0    |   0   |    1     |   1   |
| CVE-2018-16395 | https://nvd.nist.gov/vuln/detail/CVE-2018-16395 | openssl   | 1.1.1k    |    0    |   0   |    1     |   1   |

INFO     Wrote: vulns.csv
```

```diff
@@ Approach 1: Steps 7.10: Lets Wrap: Above is something I dont understand @@

- WE SHALL CONTINUE WITH THIS APPROACH LATER ONCE I UNDERSTAND MORE ON NIX
! I SHOULD NOT HAVE INCLUDED NIV & DOCKERFILE AT SUCH AN EARLY STAGE
```
