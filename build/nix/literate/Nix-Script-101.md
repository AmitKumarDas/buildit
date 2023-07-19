#### A Dev Env Composed of Script & Nix Pkgs
```yaml
- refer: https://github.com/tweag/nix_bazel_codelab/blob/main/shell.nix
- refer: https://github.com/tweag/nix_bazel_codelab/blob/main/bin/update-doclinks.sh
- TIL: Folder structure for .nix files & scripts
```

```sh
- Following is shell.nix file
```
```nix
{ pkgs ? import ./nix/nixpkgs { } }:

let
  # ./bin/lab is a regular script with shebang set to #!/bin/sh
  lab-script = pkgs.writeShellScriptBin "lab" (builtins.readFile ./bin/lab);
in
with pkgs;

mkShell {
  # DOUBT: Why is nix passed as an enviornment dependency?
  # DOUBT: buildInputs vs packages # When to use What?
  packages = [ lab-script bazel_4 buildifier buildozer nix ];
}
```

```sh
# Following is update-doclinks.sh file
```
```nix
#! /usr/bin/env nix-shell
#! nix-shell -i bash ../shell.nix                 # Does this replace shell hooks? # Is it UX friendly?

# DOUBT: Does above shebangs force script EXEcution inside the nix shell ENVironment?

# This script updates the links to Bazel's docs in the README.md file
# to directly link to the version that is specified in .bazeliskrc

set -EeuCo pipefail

declare -a BAZEL_VERSION

mapfile -n 1 -t BAZEL_VERSION < <( sed -ne 's/USE_BAZEL_VERSION=//p ; T ; q' .bazeliskrc )

echo "linking to Bazel docs version ${BAZEL_VERSION[0]}"

sed -i -Ee "s,(https://docs.bazel.build/versions/)([^/]*)/,\1${BAZEL_VERSION[0]}/,g" README.md
```
