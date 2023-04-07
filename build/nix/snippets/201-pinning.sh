# refer: https://dimitrije.website/posts/2023-03-04-nix-ocaml.html

nix-env -iA nixpkgs.niv

mkdir repo && cd repo
git init
niv init && niv update nixpkgs -b 22.11

# niv will pin this to tip of main branch
# https://github.com/dimitrijer/nixfiles
niv add dimitrijer/nixfiles -b main
