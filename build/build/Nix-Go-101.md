### Handy Commands
```sh
nix-env -qaP golang
error: selector 'golang' matches no derivations, maybe you meant:
       golangci-lint
       golangci-lint-langserver
```

```sh
nix-env -qaP go
nixpkgs.go_1_18  go-1.18.10
nixpkgs.go       go-1.19.4
nixpkgs.go_1_20  go-1.20rc3
```

### Discover & Usage
```yaml
- https://lazamar.co.uk/nix-versions/?channel=nixpkgs-unstable&package=go
- https://github.com/NixOS/nixpkgs/tree/master/pkgs/development/compilers/go
- https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/go/package.nix
```

### Go Comptability
```yaml
- refer: https://go.dev/blog/compat
- tool: List of each package’s exported API in files separate from the actual packages
- testing: Above are used as GOLDEN files
```

### Go Dependencies
```yaml
- dependency: https://go.dev/doc/modules/managing-dependencies
```

### Go & K8s
```yaml
- https://github.com/kubernetes/community/pull/7474/files
- PRs to mitigate last set of fires for go1.21 bump
  - [fix] https://github.com/kubernetes/kubernetes/pull/119027
  - [1.25 cherry-pick] https://github.com/kubernetes/kubernetes/pull/120034
  - [1.26 cherry-pick] https://github.com/kubernetes/kubernetes/pull/120035
  - [1.27 cherry-pick] https://github.com/kubernetes/kubernetes/pull/120036
  - [1.28 cherry-pick] https://github.com/kubernetes/kubernetes/pull/120037
```

### Shoutouts 🙇‍♀️
```yaml
- https://github.com/hairyhenderson/gomplate/blob/main/Makefile
```

### Utility: OS & Arch
```yaml
- GOOS ?= $(shell $(GO) version | sed 's/^.*\ \([a-z0-9]*\)\/\([a-z0-9]*\)/\1/')
  - go version | sed 's/^.*\ \([a-z0-9]*\)\/\([a-z0-9]*\)/\1/' # darwin
- GOARCH ?= $(shell $(GO) version | sed 's/^.*\ \([a-z0-9]*\)\/\([a-z0-9]*\)/\2/')
  - go version | sed 's/^.*\ \([a-z0-9]*\)\/\([a-z0-9]*\)/\2/' # amd64
- go version # go version go1.19 darwin/amd64
- GOOS = stdenv.targetPlatform.parsed.kernel.name;
- GOARCH = goarch stdenv.targetPlatform;
- GOBUILDOS = stdenv.buildPlatform.parsed.kernel.name;
- GOBUILDARCH = goarch stdenv.buildPlatform;
```

### Dummy Project
```nix
# File: default.nix

# Run:
# Step 1: nix-build
# Step 2: ls -ltr
# Step 3: ls -ltr result/bin
# Step 4: ldd result/bin/<name-of-binary>            # Verify if the binary is static or dynamic

{
  pkgs ? import <nixpkgs> { }
}:
with pkgs;

let
  inherit (pkgs) buildGoModule lib;
in
buildGoModule rec {
  name = "my-go-project";                  # pname does not work for custom derivation
  version = "0.3.4";

  src = fetchFromGitHub {                  # private gitlab needs more configuration
    owner = "amitkumardas";
    repo = "mygoproj";
    rev = "refs/tags/v${version}";
    hash = "";
  };

  # Set this to "" if you do not know the hash
  # You will know the value when the build results in hash mismatch error
  vendorHash = "";

  # -s	disable symbol table
  # -w	disable DWARF generation
  ldflags = [
    "-w"
    "-s"
  ];

  meta = with lib; {
    description = "Put the project details";
    homepage = "https://github.com/amitkumardas/mygoproj";
    changelog = "https://github.com/amitkumardas/mygoproj/releases/tag/v${version}";
    license = licenses.mpl20;
    mainProgram = "mygoproj";
    maintainers = with maintainers; [ amitd ];
  };
}
```

```nix
# File: shell.nix

# Run:
# Step 1: nix-shell
# Step 2: which name-of-cli
# Step 3: echo $PATH             # to understand how nix-shell has setup PATH

{ pkgs ? import <nixpkgs> { } }:

let 
  ctl = import ./default.nix { inherit pkgs; };
in pkgs.mkShell {
  buildInputs = [ ctl ];
}
```

### subPackages
```nix
buildGoModule rec {
  name = "";
  version = "";
  src = fetchFromGitHub {};

  subPackages = [ "cmd/mycli" ];
}
```

### shell.nix + tarball + pin + src + pkgs
```yaml
- refer: https://github.com/xtruder/go-testparrot/blob/master/shell.nix
```

```nix
{ src ? builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-20.09.tar.gz",
  pkgs ? import src {}
}:

pkgs.mkShell {
  buildInputs = with pkgs; [
    go_1_15
    gopls
    delve
    go-outline
  ];

  hardeningDisable = [ "all" ];

  GO111MODULE = "on";
}
```

### pin + tarball + commit
```nix
let
  pkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/976fa3369d722e76f37c77493d99829540d43845.tar.gz";
  }) {};

  myPkg = pkgs.go;
in
...
```

### pin + git + unstable branch + commit
```nix
let
  pkgs = import (builtins.fetchGit {
    # Descriptive name to make the store path easier to identify                
      name = "my-old-revision";                                                 
      url = "https://github.com/NixOS/nixpkgs/";                       
      ref = "refs/heads/nixpkgs-unstable";                     
      rev = "976fa3369d722e76f37c77493d99829540d43845";                                           
  }) {};                                                                           

  myPkg = pkgs.go;
in
...
```
