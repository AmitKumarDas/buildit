### Motivation
- Learn Nix
- Learn building container images using Nix
- Learn better by walking down the commit history Nix & Docker

### Learn from Commit History

```diff
@@ Jan 13, 2016 @@

# https://github.com/NixOS/nixpkgs/commit/4a4561ce244c0cea1cb07fd02f176b11f094f570

@@ WHAT @@
# contents is a derivation that gets copied in the new layer of the resulting image
# -- Is same as ADD contents/ / in a Dockerfile

# runAsRoot is a bash script that will run as root in the overlayed environment
# -- Where env == overlay of base image layers + previous contents derivation + new resulting layer
# -- Is same as RUN in a Dockerfile
# -- Using this parameter requires the kvm device to be available

```
