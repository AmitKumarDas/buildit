### Motivation
- Most of the time I start searching for specific Nix commands to meet my build goals

### 🥤 Takeaways 🥤

```diff
@@ License Checks @@

# nix-env -qaA nixpkgs.vim --json | jq '."nixpkgs.vim".meta.license'
```
```diff
@@ fetch the source tarball and link it in the current directory @@

# nix-build '<nixpkgs>' -A vim.src
```
```diff
@@ Query Nix package versions & revision numbers @@

# https://lazamar.co.uk/nix-versions/
```
