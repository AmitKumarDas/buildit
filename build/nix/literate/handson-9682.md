### Motivation
This article is a hands on run of commands present in https://github.com/NixOS/nixpkgs/issues/9682

### Hands On
```diff
@@ nix-env -qaP vs. nix-env -qa @@
+ nix-env -qaP curl
- nix-env -qa curl
```
```sh
# -P gives the details that can be used in .nix scripts
# nix-env -qaP curl
nixpkgs.curl            curl-7.87.0
nixpkgs.curlFull        curl-7.87.0
nixpkgs.curlHTTP3       curl-7.87.0
nixpkgs.curlMinimal     curl-7.87.0
nixpkgs.curlWithGnuTls  curl-7.87.0
```

```diff
@@ Being Specific @@
+ nix-env -f "<nixpkgs>" -qaP -A haskellPackages Cabal
- nix-env -f "<nixpkgs>" -qaP -A haskellPackages

@@ nix-env -qaP -A haskellPackages Cabal # IS WRONG @@
```


