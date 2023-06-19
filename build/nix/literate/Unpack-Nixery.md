### What is Nixery
- A service that uses the Nix package manager to build container images (for runtimes such as Docker)
- Are served on-demand via the container registry protocols
- A demo instance is available at nixery.dev

### Usage
```diff
@@ docker pull nixery.dev/shell/git @@
```
```yaml
- You receive an image that was built ad-hoc containing a shell environment and git
```

### Few Code Snippets to Learn Nix & Nixery
```diff
@@ Import an Entire Folder Containing Several .nix Files @@
```
```nix
nixery-prepare-image = import ./prepare-image { inherit pkgs; };
```

```diff
@@ Nix Calling Nix @@
```
```nix
# default.nix
# uses load-pkgs.nix & prepare-image.nix

{ pkgs ? import <nixpkgs> { } }:

pkgs.writeShellScriptBin "nixery-prepare-image" ''
  exec ${pkgs.nix}/bin/nix-build \                   # Nix Calling Nix
    --show-trace \
    --no-out-link "$@" \
    --argstr loadPkgs ${./load-pkgs.nix} \           # This Wrapper script ensures correct PATH to the file
    ${./prepare-image.nix}                           # This Wrapper script ensures correct PATH to the file
''
```

### [TODO] Served on Demand via Container Registry Protocol
- https://github.com/opencontainers/distribution-spec/blob/master/spec.md

### Extras
```diff
@@ What is the Advantage of Nix to Create Container Images @@
```
```yaml
- Content Addressable nature of container image layers can be used to provide more EFFICIENT caching
- i.e. Caching based on layer content
- Instead of Dockerfile's way of caching based on layer creation Method
```

```diff
@@ Nixery has Further Improved Layering than Nix's buildLayeredImage @@
```
```yaml
- https://tazj.in/blog/nixery-layers
```
