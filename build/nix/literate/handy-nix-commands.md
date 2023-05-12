### Motivation
- Most of the time I start searching for specific Nix commands to meet my build goals

### 🙇‍♀️ Shoutouts 🙇‍♀️
- https://github.com/mhwombat/nix-for-numbskulls

### 🥤 Takeaways 🥤

```diff
@@ build install & internet @@

# The build step runs in a PURE environment to ensure that builds are REPRODUCIBLE
# -- This means NO INTERNET ACCESS; indeed no access to any files outside the build directory
# -- During the build & install phases, the only commands available are those provided by the Nix stdenv
# -- And the EXTERNAL DEPENDENCIES identified in the INPUTS section of the flake
```

```diff
@@ What is available during the build and install phases? @@

@@ stdenv is availble that consists of: @@
# - The GNU C Compiler, configured with C and C++ support
# - GNU coreutils (contains a few dozen standard Unix commands) 💥
# - GNU findutils (contains find) 💥
# - GNU diffutils (contains diff, cmp) 💥
# - GNU sed
# - GNU grep
# - GNU awk
# - GNU tar
# - gzip, bzip2 and xz
# - GNU Make
# - Bash
# - The patch command
# - On Linux, stdenv also includes the patchelf utility

@@ following environment variables are variable: @@
# $name is the package name
# $src refers to the source directory
# $out is the PATH to the location in the Nix STORE where the package will be added
# $system is the system that the package is being built for
# $PWD and $TMP both point to a TEMPORARY BUILD DIRECTORIES
# $HOME and $PATH point to NONEXISTENT directories, so the build CANNOT RELY on them
```

```diff
@@ src = ./.; @@

# supplies the location of the source files, relative to flake.nix
```

```diff
@@ unpackPhase = "true"; @@

# When a flake is accessed for the first time
# -- The repository contents are fetched in the form of a tarball
# -- The unpackPhase variable indicates that we do want the tarball to be unpacked
```

```diff
@@ buildPhase = ":"; @@

# Above is a no-op or "do nothing" command
```

```diff
@@ flake-utils.lib.eachDefaultSystem (system: @@

# If we want the package to be available for multiple systems 
# -- e.g., “x86_64-linux”, “aarch64-linux”, “x86_64-darwin”, and “aarch64-darwin”
# -- We need to define the output for each of those systems

# Often the definitions are identical, apart from the name of the system
# -- The eachDefaultSystem function allows to write a single definition 
# -- Using a variable for the system name
# The function then iterates over all default systems to GENERATE the OUTPUTS for EACH one
```

```diff
@@ Flake References @@

# 1/ A Git repository: git+https://github.com/NixOS/patchelf
# 2/ A specific branch of a Git repository: git+https://github.com/NixOS/patchelf?ref=master
# 3/ A specific revision of a Git repository: 
# -- git+https://github.com/NixOS/patchelf?ref=master&rev=f34751b88bd07d7f44f5cd3200fb4122bf916c7e
# 4/ A tarball: https://github.com/NixOS/patchelf/archive/master.tar.gz
```

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

### TODO (Read these & put to Takeaways section)
- https://sandervanderburg.blogspot.com/2020/07/on-using-nix-and-docker-as-deployment.html
