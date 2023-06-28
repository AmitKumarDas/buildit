### Nix Go 101
```yaml
- refer: https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/go/package.nix
```

#### `A Dummy Project`
```nix
# Name: default.nix

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
# Name: shell.nix
# Note: Execute this file using nix-shell

{ pkgs ? import <nixpkgs> { } }:

let 
  ctl = import ./default.nix { inherit pkgs; };
in pkgs.mkShell {
  buildInputs = [ ctl ];
}
```

#### `When Private GitLab`
```nix
# File: default.nix
# Note: Most of the content remain same as in 'A Dummy Project'

  # Note: This is commented
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
...
```
