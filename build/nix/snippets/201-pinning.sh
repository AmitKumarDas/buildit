run: nix-env -iA nixpkgs.niv
mkdir repo && cd repo
git init
niv init && niv update nixpkgs -b 22.11
