### Credits
```yaml
- https://all-dressed-programming.com/posts/nix-yarn/
- https://gitlab.com/all-dressed-programming/yarn-nix-example
```

### Motivation
```yaml
- I have No idea on Yarn or Node
- This writeup is an attempt to learn the fundamentals
- I am only interested in Build parts
- I want to use Nix to build yarn based projects
```

### Step 0 - Traditional Build
```diff
@@ What @@ 
# yarn-nix-example is a node/yarn project
# Builds a Static Website using Parcel

# - yarn install      - FETCH all dependencies       - CREATE a node_modules directory
# - yarn build        - defined in package.json      - Delegates to parcel i.e. parcel build

@@ How @@
# Parcel COMPILES typescript assets into a STANDALONE javascript file
```

### Step 1 - Nix Build
```diff
@@ How @@
# 1/ Yarn       - is replaced with yarn2nix
# 2/ Parcel     - is still used i.e. delegated by Yarn to compile typescript

@@ How @@
@@ mkYarnPackage @@
# Creates the node_modules directory located at libexec/{package-name}/node_modules

@@ mkDerivation @@
# Build logic will be to symlink the previously built node_module and call yarn build

@@ Refer @@
# https://github.com/NixOS/nixpkgs/
# - pkgs/development/tools/yarn2nix-moretea/yarn2nix/default.nix
```

### Step 2 - Flake: The build Recipe
```nix
{
  description = "Example of a project that integrates nix flake with yarn.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        node-modules = pkgs.mkYarnPackage {
          name = "node-modules";
          src = ./.;
        };
        frontend = pkgs.stdenv.mkDerivation {
          name = "frontend";
          src = ./.;
          buildInputs = [pkgs.yarn node-modules];
          buildPhase = ''
            ln -s ${node-modules}/libexec/yarn-nix-example/node_modules node_modules
            ${pkgs.yarn}/bin/yarn build
          '';
          installPhase =  ''
          mkdir $out
          mv dist $out/lib
          '';

        };
      in 
        {
          packages = {
            node-modules = node-modules;
            default = frontend;
          };
        }
    );
}
```

### Step 3 - Run
```
@@ Running from inside the cloned repo @@
# nix build .#node-modules

@@ Run without cloning the repo @@
# nix build gitlab:/all-dressed-programming/yarn-nix-example
```

### Advanced - Deep Dive yarn2nix Source
```diff

```
