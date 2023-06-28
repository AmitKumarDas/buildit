### Nix Go 101

#### `Take 1`
```nix
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

  src = fetchFromGitHub {
    owner = "amitkumardas";
    repo = "mygoproj";
    rev = "refs/tags/v${version}";
    hash = "";
  };

  # Depends on go.mod/go.sum
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
