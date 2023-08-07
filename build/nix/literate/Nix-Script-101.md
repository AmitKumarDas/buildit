### Pure + Reproducible + Linted + Folder/File Practices 🎖️🎖️🎖️
```yaml
- shoutout: https://www.ertt.ca/nix/shell-scripts/
- Developer Experience: bash script & nix are separate                  # --- IMP / CODE REVIEW
- #!/usr/bin/env bash                                                   # --- ORIGINAL
- #!/nix/store/1flh34xxg9q3fpc88xyp2qynxpkfg8py-bash-4.4-p23/bin/bash   # --- REPLACEMENT
- uses writeScriptBin instead of writeShellScriptBin                    # --- IMP / CODE REVIEW
```
```bash
#!/usr/bin/env bash
DATE=$(ddate +'the %e of %B%, %Y')     # ------- SHEBANG that developers are used to
cowsay Hello, world! Today is $DATE.   # ------- dependencies are used like they are already available
```
```nix
my-src = builtins.readFile ./simple-script.sh;                   # ------- READ FILE from builtins
my-script = (pkgs.writeScriptBin my-name my-src).overrideAttrs(old: { # -- OVERRIDE ATTRS
  buildCommand = "${old.buildCommand}\n patchShebangs $out";     # ------- APPEND buildCommand with patchShebangs
});
```

### Pure Yet Reproducible & Auto Linted Shell Scripts 🎖️🎖️🎖️
```yaml
- shoutout: https://www.ertt.ca/nix/shell-scripts/ 🙇‍♀️
- pkgs.writeShellScriptBin LINTS the script for you 🍭🍭🍭
- pkgs.writeShellScriptBin PREPENDS the script with shebang 🍭🍭🍭
- pkgs.writeScriptBin DOESNT do above 🍭🍭🍭
- Pure script implies package the original script as-is
- Pure script is possible via:
  - 1/ symlinkJoin (a nix function) # --------------------- REPLACEMENT to stdenv.mkDerivation
  - 2/ wrapProgram (a shell script)
```
```nix
let
  pkgs = import nixpkgs {};
  my-name = "my-pure-script";
  my-script = pkgs.writeShellScriptBin my-name ''         # DERIVATION for our SCRIPT
    DATE=$(ddate +'the %e of %B%, %Y')
    cowsay Hello, world! Today is $DATE.
  '';
  my-buildInputs = with pkgs; [ cowsay ddate ];
in pkgs.symlinkJoin {                                      # A DERIVATION combining MULTIPLE PKGS into ONE PKG
  name = my-name;
  paths = [ my-script ] ++ my-buildInputs;                 # GLUED TOGETHER to PATH # RUNTIME DEPENDENCY
  buildInputs = [ pkgs.makeWrapper ];                      # BUILDTIME DEPENDENCY
  postBuild = "wrapProgram $out/bin/${my-name} --prefix PATH : $out/bin";  # APPEND $out/bin to PATH # PREPEND???
};
```
```yaml
- run: nix build
- run: ls -ltra result/bin
  - # Following are due to wrapProgram
  - my-script                                              # ----------------- Users CALL this
  - .my-script-wrapped -> /nix/store/xxxxxxxxx-my-script/bin/my-script  # ---- ACTUAL SCRIPT CONTENTS
- FLOW from my-script to .my-script-wrapped to the REPRODUCIBLE my-script at /nix/store path
- result/bin/my-script has the MAGIC SMALL SCRIPT
  - 1/ It UPDATES the PATH, as we’ve INSTRUCTED
  - 2/ Then REPLACES ITSELF (exec) with .my-script-wrapped
```

### Bad vs Good Nix Scripting & Verified
```yaml
- https://www.sam.today/blog/creating-a-super-simple-derivation-learning-nix-pt-3
```
#### Bad
```nix
# DO NOT USE THIS; this is a BAD example
with import <nixpkgs> {};

let
  # We just specify the derivation the same way as before
  #
  # This script is un-predictable outside of nix-shell:
  # - MISSING DEPENDENCIES
  # - POLLUTES ENVIRONMENT
  # - NOT REPRODUCIBLE
  simplePackage = pkgs.writeShellScriptBin "whatIsMyIp" ''
    curl http://httpbin.org/get | jq --raw-output .origin
  '';
in
stdenv.mkDerivation rec {
  name = "test-environment";

  # Then we add curl & jq to the list of buildInputs for the shell
  # So curl and jq will be added to the PATH inside the shell
  buildInputs = [ simplePackage pkgs.jq pkgs.curl ];
}
```

#### Good
```nix
with import <nixpkgs> {};

let
  # The ${...} is for STRING INTERPOLATION
  # The '' quotes are used for MULTI-LINE STRINGS
  # whatIsMyIp is the name of the generated script
  simplePackage = pkgs.writeShellScriptBin "whatIsMyIp" ''
    ${pkgs.curl}/bin/curl http://httpbin.org/get \
      | ${pkgs.jq}/bin/jq --raw-output .origin
  '';
in
stdenv.mkDerivation rec {
  name = "test-environment";

  buildInputs = [ simplePackage ];
}
```
#### Verify 🔬
```sh
$ nix-shell test.nix
$ [nix-shell:~]$ cat $(which whatIsMyIp)
#!/nix/store/hqi64wjn83nw4mnf9a5z9r4vmpl72j3r-bash-4.4-p12/bin/bash
/nix/store/pkc7g36m95jymw3ga2i7pwrykcfs78il-curl-7.57.0-bin/bin/curl http://httpbin.org/get \
  | /nix/store/znqn0z505i0bm1aiz2jaj1ki7z4ck1sv-jq-1.5/bin/jq --raw-output .origin
```
#### Lessons Learnt 🍭
```yaml
- All the binaries referenced in this script are ABSOLUTE paths
- Hence script DOESN'T rely on PATH environment variable
- Script can be run ANYWHERE but is IMPURE since Nix is MIXED
```

### A Dev Env Composed of Script & Nix Pkgs
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
  # ----------- ./bin/lab is a REGULAR SCRIPT with SHEBANG set to #!/bin/sh -----------
  lab-script = pkgs.writeShellScriptBin "lab" (builtins.readFile ./bin/lab);
in
with pkgs;

mkShell {
  # DOUBT: Why is nix passed as an enviornment dependency?
  # DOUBT: buildInputs vs packages # When to use What?
  packages = [ lab-script bazel_4 buildifier buildozer nix ];
}
```

### Script Embedding shell.nix 🍭
```nix
#! /usr/bin/env nix-shell
#! nix-shell -i bash ../shell.nix

# --------- Does THIS REPLACE the NEED for shell HOOKS? ---------
# --------- Is THIS UX FRIENDLY?                        ---------

# This script updates the links to Bazel's docs in the README.md file
# to directly link to the version that is specified in .bazeliskrc

set -EeuCo pipefail

declare -a BAZEL_VERSION

mapfile -n 1 -t BAZEL_VERSION < <( sed -ne 's/USE_BAZEL_VERSION=//p ; T ; q' .bazeliskrc )

echo "linking to Bazel docs version ${BAZEL_VERSION[0]}"

sed -i -Ee "s,(https://docs.bazel.build/versions/)([^/]*)/,\1${BAZEL_VERSION[0]}/,g" README.md
```
