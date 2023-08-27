### Baby Steps to Build & Use Packages
```sh
# GHC && the package
nix-shell -p "haskellPackages.ghcWithPackages (pkgs: with pkgs; [hscolour])"
```

```sh
# No GHC
nix-shell -p 'haskell.lib.justStaticExecutables haskellPackages.hscolour' \
  --run 'HsColour --version'
```
