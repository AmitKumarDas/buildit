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

### Nix Go 101
```yaml
- refer: https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/go/package.nix
- refer: https://github.com/NixOS/nixpkgs/tree/master/pkgs/development/compilers/go
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

### Private GitLab
```nix
# File: default.nix
# Note: Most of the content remain same as in 'A Dummy Project'

  # Note: Commented for private GitLab repos
  #src = fetchFromGitLab {
    #owner = "gitlab.eng.myorg.com";
    #repo = "shepp";
    #rev = "3577441be0d95514eaa1a931a2dc15497dd7b5d2";
    #hash = "";
  #};

  # Note: Following is used instead of above
  src = fetchGit {
    url = "ssh://git@gitlab.eng.myorg.com/shepp";
    rev = "3577441be0d95514eaa1a931a2dc15497dd7b5d2";
    ref = "main";
  };

  # If above ssh:// has issues then try https://
  src = fetchGit {
    url = "https://gitlab.eng.myorg.com/shepp/shepp.git";
    rev = "3577441be0d95514eaa1a931a2dc15497dd7b5d2";
    ref = "main";
  };
```

### symlinkJoin
```nix
# File: https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/etcd/3.5.nix
# Note: Above location will become stale once 3.5 is EOL
# Note: Following is just a snippet. I.e. It will not build

let
  version = "3.5.9";

  src = fetchFromGitHub {
    ...
  };

  CGO_ENABLED = 0;

  meta = with lib; {
    ...
  };

  etcdserver = buildGoModule rec {
    inherit CGO_ENABLED meta src version;

    modRoot = "./server";

    preInstall = ''
      mv $GOPATH/bin/{server,etcd}
    '';

    # We set the GitSHA to `GitNotFound` to match official build scripts when
    # git is unavailable. This is to avoid doing a full Git Checkout of etcd.
    # User facing version numbers are still available in the binary, just not
    # the sha it was built from.
    ldflags = [ "-X go.etcd.io/etcd/api/v3/version.GitSHA=GitNotFound" ];
  };

  etcdutl = buildGoModule rec {
    pname = "etcdutl";

    inherit CGO_ENABLED meta src version;

    modRoot = "./etcdutl";
  };

  etcdctl = buildGoModule rec {
    pname = "etcdctl";

    inherit CGO_ENABLED meta src version;

    modRoot = "./etcdctl";
  };
in

# Title:   symlinkJoin
# What:    Puts MANY DERivations into the SAME DIRectory
# How:     Creates a NEW derivation and ADDs SYMlinks to each of the PAThs listed
symlinkJoin {
  name = "etcd-${version}";

  inherit meta version;

  passthru = {
    inherit etcdserver etcdutl etcdctl;
    tests = { inherit (nixosTests) etcd etcd-cluster; };
  };

  paths = [
    etcdserver
    etcdutl
    etcdctl
  ];
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

### WIP: buildGoModule with Specific Version
```yaml
- https://github.com/cachix/devenv/blob/main/src/modules/languages/go.nix
```

### Dummy shell.nix
```yaml
- https://github.com/xtruder/go-testparrot/blob/master/shell.nix
```

```nix
{ src ? builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-20.09.tar.gz",
  pkgs ? import src {}}:

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
