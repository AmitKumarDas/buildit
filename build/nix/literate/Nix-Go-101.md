### Nix Go 101
```yaml
- refer: https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/go/package.nix
- refer: https://github.com/NixOS/nixpkgs/tree/master/pkgs/development/compilers/go
```

#### `A Dummy Project`
```nix
# File: default.nix
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

#### `If Source Code is in a Private GitLab Then Try Below`
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
