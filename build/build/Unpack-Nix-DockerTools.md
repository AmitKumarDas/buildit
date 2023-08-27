## 🍭 Motivation 🍭
- Learn Nix
- Focus on learning Nix to build container images
- Learn from Commit History i.e. https://github.com/NixOS/nixpkgs/commit/{insert-commit-number}

### Commit References
- History for nixpkgs/pkgs/build-support/docker
- https://github.com/NixOS/nixpkgs/commit/4a4561ce244c0cea1cb07fd02f176b11f094f570

### WHAT

```diff
@@ contents ~ ADD @@
```
```sh
# A DERIVATION
# Gets COPIED in the new layer of the resulting image
# Same as ADD contents/ / in a Dockerfile
```

```diff
@@ runAsRoot ~ RUN @@
```
```sh
# A bash script 
# Will RUN as ROOT in the overlayed environment
# Overlay ENV == Base Image Layers + the contents Derivation + New Resulting Layer
# Same as RUN in a Dockerfile
# Requires KVM device to be available
```

```diff
@@ config ~ Specs @@
```
```sh
# Docker Image Specification v1.0.0
# After the new layer has been created, this spec's closure is copied to the layer itself
# Closure i.e. Dependencies == contents + config + runAsRoot
# ONLY new Dependencies that are NOT in the EXISTING LAYERS will be copied
```

```diff
@@ How to Inspect an Image using Nix? @@
```
```sh
# Using buildArgs
```

```diff
@@ shadowSetup @@
```
```sh
# Sets up BASE FILES for managing USERS and GROUPS, iff files don't exist
# Suitable for use in runAsRoot                               # TIP
```

```diff
@@ Note: Base files like /etc/passwd or /etc/login.defs @@
```
```sh
# Needed for shadow-utils to manipulate users and groups
```

### HOW

```diff
@@ Making of a Shell Script ~ stdenv.shell + coreutils @@
```
```nix
shellScript = text:
  writeScript "script.sh" ''
    #!${stdenv.shell}
    set -e
    export PATH=${coreutils}/bin:/bin             # cat, ls, rm, etc. # vs. Busybox # New PATH
    ${text}
  '';
```

```diff
@@ ShadowSetup @@
```

```nix
buildImage {
  name = "shadow-basic";

  runAsRoot = ''
    #!${stdenv.shell}                  # TIL
    ${shadowSetup}                     # TIL
    groupadd -r redis
    useradd -r -g redis redis
    mkdir /data
    chown redis:redis /data
  '';
}
```

```diff
@@ pull.nix ~ Pull Image as a Tar File @@
```

```nix
{ stdenv, lib, curl, jshon, python, runCommand }:         # First Set of Args

# Inspired and simplified version of fetchurl.
# For simplicity we only support sha256.

# Currently only registry v1 is supported, compatible with Docker Hub.

{ imageName, imageTag ? "latest", imageId ? null
, sha256, name ? "${imageName}-${imageTag}"
, indexUrl ? "https://index.docker.io"
, registryUrl ? "https://registry-1.docker.io"
, registryVersion ? "v1"
, curlOpts ? "" }:                                        # Second Set of Args

let layer = stdenv.mkDerivation {
  inherit name imageName imageTag imageId
          indexUrl registryUrl registryVersion curlOpts;

  builder = ./pull.sh;                                       # TIL
  detjson = ./detjson.py;                                    # TIL

  buildInputs = [ curl jshon python ];                       # USED at RUNTIME

  outputHashAlgo = "sha256";
  outputHash = sha256;                                       # 🧐 WHY
  outputHashMode = "recursive";

  impureEnvVars = [                                                        # TIL
    # We BORROW these ENV VARIABLES from the caller to allow
    # easy proxy configuration.
    # 
    # This is IMPURE, but a Fixed-Output Derivation like fetchurl
    # is allowed to do so since its RESULT IS by definition PURE.          # TIL # HOW
    "http_proxy" "https_proxy" "ftp_proxy" "all_proxy" "no_proxy"

    # This variable allows the user to pass ADDITIONAL OPTIONS to curl
    "NIX_CURL_FLAGS"

    # This variable allows OVERRIDING the timeout for connecting to
    # the hashed mirrors.
    "NIX_CONNECT_TIMEOUT"
  ];

  # Doing the download on a remote machine just duplicates network
  # traffic, so don't do that.                                             # 🧐 DOUBT
  preferLocalBuild = true;
};

in runCommand "${name}.tar.gz" {} ''                        # TIP: Desired State is Here
  tar -C ${layer} -czf $out .
''
```
