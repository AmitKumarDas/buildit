### Motivation
```diff
@@ Hands on run of commands, snippets found at: @@
# https://github.com/NixOS/nixpkgs/issues/9682
# https://medium.com/@MrJamesFisher/nix-by-example-a0063a1a4c55
# https://matrix.ai/blog/developing-with-nix
# https://news.ycombinator.com/item?id=30918962
```

### Hands On
```diff
@@ nix-env -qaP vs. nix-env -qa @@
+ nix-env -qaP curl
- nix-env -qa curl

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

! ❌ nix-env -qaP -A haskellPackages Cabal
```

```diff
@@ Nested Let In @@
! Probably not needed. Use builtins instead

# default.nix
let
  _nixpkgs = import <nixpkgs> { };
in
{ nixpkgs ? (import _nixpkgs.fetchFromGitHub { owner = "NixOS"; repo = "nixpkgs"; rev = ...; sha256 = ...; })
}:

let
  pkgs = if nixpkgs == null then _nixpkgs else nixpkgs;
in
  pkgs.stdenv.mkDerivation {
    # ...
  }
```

```diff
@@ Pinning & Overrides @@
# https://gist.github.com/jb55/6e93156ca7fe90a36bb08df0408446a3
```

```diff
@@ Learn Nix @@
@@ Nix 1 Pager @@
# https://medium.com/@MrJamesFisher/nix-by-example-a0063a1a4c55
```

```diff
@@ Patch OpenSSL & Use in nginx @@

let
  mypatch = pkgs.fetchpatch {
    url = "https://example.com/bugfix-for-openssl.patch";
    sha256 = "...";
  };

  openssl = pkgs.openssl.overrideAttrs (old: {
    # add build flags
    configureFlags = old.configureFlags ++ [ "--enable-foo" ];

    # add dependencies
    buildInputs = old.buildInputs ++ [ pkgs.foo ];

    # add patches
    patches = old.patches ++ [ mypatch ];
  });
in
nginx.override { inherit openssl; }
```
