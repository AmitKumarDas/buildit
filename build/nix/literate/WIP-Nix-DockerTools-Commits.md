## 🍭 Motivation 🍭
- Learn Nix
- Focus on learning Nix to build container images
- Learn from Commit History i.e. https://github.com/NixOS/nixpkgs/commit/{insert-commit-number}

## Jan 13, 2016 - 4a4561ce244c0cea1cb07fd02f176b11f094f570

### WHAT

```diff
@@ contents @@

# Is a DERIVATION
# Gets copied in the new layer of the resulting image
# Same as ADD contents/ / in a Dockerfile
```

```diff
@@ runAsRoot @@

# A bash script 
# Will RUN as ROOT in the overlayed environment
# Overlay ENV == Base Image Layers + the contents Derivation + New Resulting Layer
# Same as RUN in a Dockerfile
# Requires KVM device to be available
```

```diff
@@ config @@

# Docker Image Specification v1.0.0
# After the new layer has been created, its closure is copied to the layer itself
# Closure i.e. Dependencies == contents + config + runAsRoot
# ONLY new Dependencies that are NOT in the EXISTING LAYERS will be copied
```

```diff
@@ ONLY ONE NEW SINGLE LAYER @@

# Result: ONLY ONE NEW SINGLE LAYER will be produced and added to the resulting image
```

```diff
@@ Note: Inspect the Image @@

# Using buildArgs 🧐 🧐
```

```diff
@@ shadowSetup @@

# A HELPER
# Sets up BASE FILES for managing USERS and GROUPS, iff files don't exist
# Suitable for use in runAsRoot
```

```diff
@@ Note: Base files like /etc/passwd or /etc/login.defs @@

# Needed for shadow-utils to manipulate users and groups
```

### HOW / SHOW / SYNTAX

```nix
buildImage {
  name = "shadow-basic";

  runAsRoot = ''
    #!${stdenv.shell}
    ${shadowSetup}
    groupadd -r redis
    useradd -r -g redis redis
    mkdir /data
    chown redis:redis /data
  '';
}
```

### SPECIAL / pull.nix / Pull Image as a Tar File / 🥤
```nix
{ stdenv, lib, curl, jshon, python, runCommand }:

# Inspired and simplified version of fetchurl.
# For simplicity we only support sha256.

# Currently only registry v1 is supported, compatible with Docker Hub.

{ imageName, imageTag ? "latest", imageId ? null
, sha256, name ? "${imageName}-${imageTag}"
, indexUrl ? "https://index.docker.io"
, registryUrl ? "https://registry-1.docker.io"
, registryVersion ? "v1"
, curlOpts ? "" }:

let layer = stdenv.mkDerivation {
  inherit name imageName imageTag imageId
          indexUrl registryUrl registryVersion curlOpts;

  builder = ./pull.sh; # 🧐 WHAT IS THIS
  detjson = ./detjson.py; # 🧐 WHAT IS THIS

  buildInputs = [ curl jshon python ];

  outputHashAlgo = "sha256";
  outputHash = sha256; # 🧐 HOW IS THIS DIFFERENT THAN THE LINE ABOVE
  outputHashMode = "recursive";

  impureEnvVars = [
    # We borrow these environment variables from the caller to allow
    # easy proxy configuration.  This is IMPURE, but a Fixed-Output
    # Derivation like fetchurl is allowed to do so since its result is
    # by definition pure.
    "http_proxy" "https_proxy" "ftp_proxy" "all_proxy" "no_proxy"

    # This variable allows the user to pass ADDITIONAL OPTIONS to curl
    "NIX_CURL_FLAGS"

    # This variable allows OVERRIDING the timeout for connecting to
    # the hashed mirrors.
    "NIX_CONNECT_TIMEOUT"
  ];

  # Doing the download on a remote machine just duplicates network
  # traffic, so don't do that. # 🧐 HOW IS THIS POSSIBLE?
  preferLocalBuild = true;
};

in runCommand "${name}.tar.gz" {} ''
  tar -C ${layer} -czf $out .
''
```
