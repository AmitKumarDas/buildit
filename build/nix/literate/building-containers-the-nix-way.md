### Motivation
- Learn Nix
- Learn building container images using Nix
- Deep dive by reading the Nix commits targetting container images

### Learn from Commit History

```diff
@@ Origins - Jan 13, 2016 @@

# https://github.com/NixOS/nixpkgs/commit/4a4561ce244c0cea1cb07fd02f176b11f094f570

@@ WHAT @@
# 1/ contents is a derivation that gets copied in the new layer of the resulting image
# -- Is same as ADD contents/ / in a Dockerfile

# 2/ runAsRoot is a bash script that will run as root in the overlayed environment
# -- Where env == overlay of base image layers + previous contents derivation + new resulting layer
# -- Is same as RUN in a Dockerfile
# -- Using this parameter requires the kvm device to be available

# 3/ config ~ Docker Image Specification v1.0.0
# After the new layer has been created, its closure i.e.:
# -- contents + config + runAsRoot will be copied in the layer itself
# ONLY new dependencies that are NOT ALREADY in the EXISTING LAYERS will be copied 💥

@@ At the end, ONLY ONE NEW SINGLE LAYER will be produced and added to the resulting image @@

@@ How to Inspect the Image? @@
# Using buildArgs 🧐 🧐


```
