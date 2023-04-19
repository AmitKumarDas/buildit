### Nix Research
```diff
@@ FELLOW: BLOGS: READ: LEARN: EXPERIENCES: RESEARCH: @@
! https://jade.fyi/ # Read the Nix parts
! https://arxiv.org/pdf/2206.14606v1.pdf # Building a Secure Software Supply Chain with GNU Guix
! https://github.com/bureado/awesome-software-supply-chain-security

@@ Follow the PRs @@
+ https://github.com/NixOS/nixpkgs/commits?author=LeSuisse
```

### Quote / Unquote
```diff
@@ Wolfi builds all packages directly from source @@ 
! https://www.chainguard.dev/unchained/building-the-first-memory-safe-distro-wolfi

# Allowing us to fix vulnerabilities 
# Apply customizations that improve the supply chain security posture 
# From the compilers to the language package managers

@@ Enabling memory safe TLS via Rustls and memory safe HTTP via Hyper in curl @@
+ Wolfi packages Rustls and makes it available as the default backend in libcurl
```
```diff
@@ Wolfi uses @@
+ Fortify source level 3
+ Position independent executables (PIE)
+ Stack-smashing protection (SSP)
+ Immediate symbol binding at runtime (-Wl,-z,now)
+ Read-only relocations (-Wl,-z,relro)
+ Control flow enforcement (CET) [x86_64 only]
```

```diff
@@ Nix expressions are pure function @@
! https://nixos.wiki/wiki/Nix_package_manager

# Takes dependencies as arguments
# Produce derivation specifying a reproducible build environment for the package

@@ Nix stores the results of the build in unique addresses @@
! These are specified by a HASH of the complete dependency tree

@@ Thus creating an immutable package store that allows for: @@
# Atomic Upgrades
# Rollbacks
# Concurrent installation of different versions of a package
# Eliminating dependency hell
```

```diff
@@ Inventory & Legally Clear @@

# Because you will need to INVENTORY and LEGALLY CLEAR everything inside your container
# It is imperative to understand the components and their specific SOURCES that make up the base OS
```
```diff
@@ Scenario @@
# 1/ If you use distroless/static 
# 2/ However you build static binaries on alpine that are linked against musl libc
# 3/ You're actually distributing alpine bits

! There are numerous issues with statically linking glibc
```

```diff
@@ Are your package repositories constantly moving targets? @@

- Do your package releases disappear as soon as newer ones are available
```

#### In The Wild
```diff
@@ Multi Output Derivations @@
# https://discourse.nixos.org/t/how-can-i-install-curl-with-its-zsh-completion-script/5902
```

#### Getting Started
```yaml
- :l <nixpkgs> 
  - # load nixpkgs # run this after nix repl # do it everytime you nix repl

- <nixpkgs> 
  - # its a path # ls <PATH> to view what's inside # same as the github contents of NixOS/nixpkgs
  - # alternativey: 1/ git checkout NixOS/nixpkgs 2/ nix-repl 3/ :l .

- diskutil apfs list # check Nix volumes

- /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh # Nix Daemon? # Nix AWARE
  - To get started using Nix, 
  - run `. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh`

- /etc/nix/nix.conf # Nix Configuration
- Create APFS volume `Nix Store` for Nix on `disk3` # add it to `/etc/fstab` mounting on `/nix`

- ls -lah /nix/store # check your nix store # GBs of data?
- nix-collect-garbage
```

#### Dive In
```yaml
- https://dimitrije.website/posts/2023-03-04-nix-ocaml.html

- Nix packages and all their dependencies are not in your PATH, or LD_LIBRARY_PATH
- They do not interfere with the rest of your system in any way

- PINNING:
  - Version of bash in 22.11 is pinned to 5.1-p16
  - 21.05 had slightly more dated bash-5.1-p4
  - nixpks-unstable currently has bleeding edge bash-5.2-p15

- niv:
  - Doesn’t care about channels
  - It records commit hash of the tip of specified channel at time of niv init execution
  - You can update pinned commit hash to latest tip
  - Even change the channel you are pinning with niv update nixpkgs -b <branch>
  
- niv:
  - sources.json: contains commit hashes and SHA-256 checksums of all Nix sources
  - sources.nix: Nix expressions used to reference Nix derivations specified in Nix sources
```

```yaml
- CONTENTS vs CONTAINER SIZE: 🔥
- refer: https://jade.fyi/blog/optimizing-nix-docker/

- 1:
  - Put ${pkgs.bash}/bin/bash in a build script and it will just work
  - It will pull in the dependency as expected
- 2:
  - If present in buildInputs or nativeBuildInputs, it goes in the PATH and gets known to build tools
  - If store paths end up in the outputs of the build, then they show up as RUNTIME dependencies

- TIP:
  - Just REFERENCE things in build scripts or otherwise, they will work
  - If in contents, they get rsynced to the root of the output image
  - If they are also in the closure due to references in build scripts or otherwise, then DUPLICATED
  - Removing from contents && let INTERPOLATION in build scripts ~ save 50% on image size 🔥
- TIP:
  - How to remove the references if I know some paths are not needed?
  - cmd: nix why-depends
  - If buildImage: contents of the image is available at passthru.layer on the buildImage derivation
  - After finding the bad package, use nix why-depends to get the exact cause path
  - cmd: nix why-depends $(nix-build docker.nix -A passthru.layer) /nix/store/xxxxxxx-bad # 🔥
- TIP:
  - look at the dependency tree or graph of a store path that has an unexpected subtree
  - cmd: nix-store --query --tree ./result
  - cmd: nix-store --query --tree ./result | dot -Tsvg -o deps.svg # look at deps.svg in an image viewer
- FIX: TIP:
  - Put the offending package in disallowedReferences on your problem derivation
  - refer : https://nixos.org/manual/nix/stable/#sec-advanced-attributes
  - Nix throws an error on next build about references that should not be there, and where they are
  - Remove these in a post-install script using nixpkgs.removeReferencesTo
    - put it in nativeBuildInputs as usual
```

```yaml
- https://jade.fyi/nixcon2022/
  - # theory # thesis # fellow
  - # runtime dependencies in Nix == grep for the hash part of any inputs of a derivation
  
- CFP: Talk:
  - Other systems: require explicit specification of runtime dependencies # if forget then boom
  - Nix has the opposite problem: it's easy to accidentally create runtime dependencies
  - Since any reference to the build inputs in the outputs can create one
  - Also container image with several passwd, group, timezone, cacerts, config stuff makes image bulky

- Size vs. Nix: # i.e. runtime dependencies
  - A package is mentioned in the 'buildInputs' of your derivation
  - Or store path i.e. $out is mentioned in 'buildInputs'

  - verify: # 1
  - cmd: nix path-info -rsSh nixpkgs#hello
  - # -recursively, with -sizes, and closure -Sizes, in -human readable form

  - verify: # 2
  - cmd: nix-store --query --graph

  - verify: # 3
  - cmd: ls -lah $(readlink result)
```

```yaml
- Nix && Docker:
  - https://jade.fyi/nixcon2022/

- cmd: ls -lah $(readlink result)

- https://github.com/lf-/actual-server/tree/flake # SLIM # MINIMAL # CONTAINER # SIZE
- https://github.com/lf-/actual-server/blob/flake/flake.nix#L40-L51
  
- FIX: # NODEJS
  - nixpkgs ships a version of NodeJS that does not include Python or npm, called nodejs-slim
  - The app is there twice because of a symlink
  - nix why-depends -a --precise 🔥

- FIX:
  - Put the package you want to exclude in 
  - disallowedRequisites or disallowedReferences # Nix failS the build if it appears again
```

```yaml
- nix show-derivation nixpkgs#hello # SBOM?
```

```yaml
- https://jade.fyi/blog/nix-evaluation-blocking/
  - # evaluate # build # issues with evaluation # concurrency # parallel
  - # import from derivation # IFD # 🤨
```

```yaml
- https://github.com/nix-community/fenix # overlay # library # toolchains

- https://blogs.vmware.com/opensource/2022/07/14/what-makes-a-build-reproducible-part-2/
  - repeatable build + rebuildable build + binary reproducible build
```

```yaml
- CMD: nix-build -E 'with import <nixpkgs> { }; runCommand "foo" { } "echo bar > $out"'
- # Build a Nix Expression given on the command line 🔥
- # cat ./result # bar
 
- CMD: nix-build https://github.com/NixOS/nixpkgs/archive/master.tar.gz -A hello
- # Build GNU Hello from LATEST REVISION of the MASTER branch of Nixpkgs 🔥
```

```yaml
- https://github.com/3noch/nix-bundle-exe 
- # EXPERIMENT # CONTAINER # LITERATE # DEEP DIVE # HANDS-ON

- Nix derivation to bundle Mach-O (macOS) and ELF (Linux) executables into a:
  - Relocatable Directory Structure 🔥

- Given a Nix package containing executables:
  - This derivation will produce a package with those SAME executables
  - But with all their SHARED libraries copied into a NEW directory structure 
  - And RECONFIGURED to work without any dependency on Nix

- CMD: nix-build -E 'with import <nixpkgs> {}; callPackage ./. {} nginx'
- verify:
  - ls /nix/store/7ghlz954brx6pf9ag2y92cs02jsn1qrp-bundle-nginx-1.22.1
  - ls -ltra /nix/store/7ghlz954brx6pf9ag2y92cs02jsn1qrp-bundle-nginx-1.22.1/lib/ 
    - # contains .so libraries # run / shared dependencies 
    - # contains symlinks
  - du -h /nix/store/7ghlz954brx6pf9ag2y92cs02jsn1qrp-bundle-nginx-1.22.1 # SIZE
```

```yaml
- https://blog.replit.com/nix_dynamic_version # workshop # learn
  - # pname vs name # git clone # src = ./. # runCommand # mkDerivation # nativeBuildInputs
  - # fetchGit # copyPathToStore # .git folder
```

```yaml
- Introspecting nginx: # shared libraries # runtime dependencies
  - nix-build -A nginx '<nixpkgs>'
  - file /nix/store/6djsv964zpb426dkjz9qmb678bmr9igb-nginx-1.22.1/bin/nginx
  - objdump -p /nix/store/6djsv964zpb426dkjz9qmb678bmr9igb-nginx-1.22.1/bin/nginx | grep /nix/store # Mac
  - otool -L /nix/store/6djsv964zpb426dkjz9qmb678bmr9igb-nginx-1.22.1/bin/nginx # Mac
  - ldd /nix/store/f8w3484r4va451m2jfhw547pldxfwi5j-nginx-1.22.1/bin/nginx # Linux
```

```yaml
- https://github.com/the-nix-way/nix-docker-examples/blob/main/go/flake.nix
  - # buildGoModule # override # super # CGO_ENABLED # GOOS # GOARCH 
  - # overlay # buildEnv # gitignoreSource # subPackages # Entrypoint # ExposedPorts
```

```yaml
- https://github.com/the-nix-way/nix-docker-examples/blob/main/script/flake.nix
  - # entrypoint.sh # copyToRoot # buildEnv # writeScriptBin # target architecture i.e. target system
  - # readFile # substituteAll as templating 🔥 # shell # bash # container
```

```yaml
- CMD:
  - nix-build -A nginx '<nixpkgs>'
    - # /nix/store/f8w3484r4va451m2jfhw547pldxfwi5j-nginx-1.22.1

  - nix path-info -Sh /nix/store/f8w3484r4va451m2jfhw547pldxfwi5j-nginx-1.22.1
    - # /nix/store/f8w3484r4va451m2jfhw547pldxfwi5j-nginx-1.22.1	 114.6M

  - nix path-info -rs /nix/store/f8w3484r4va451m2jfhw547pldxfwi5j-nginx-1.22.1 
    - # size # dependencies

  - nix path-info -rs /nix/store/f8w3484r4va451m2jfhw547pldxfwi5j-nginx-1.22.1 | sort -rnk2

  - nix-store -qR /nix/store/f8w3484r4va451m2jfhw547pldxfwi5j-nginx-1.22.1
    - # show runtime dependencies 
    - # closure of the output path that contains nginx

  - ❌ nix-store -qR $(nix-store -qd /nix/store/f8w3484r4va451m2jfhw547pldxfwi5j-nginx-1.22.1)
    - # show build-time  dependencies # closure of the derivation (-qd)

  - ❌ nix-store -q --tree $(nix-store -qd /nix/store/f8w3484r4va451m2jfhw547pldxfwi5j-nginx-1.22.1) 
    - # show build-time dependencies as a tree
```

```yaml
- nix why-depends /nix/store/f8w3484r4va451m2jfhw547pldxfwi5j-nginx-1.22.1 /nix/store/sq78g74zs4sj7n1j5709g9c2pmffx1y8-gcc-11.3.0-lib 
  - # dependencies # debug # troubleshoot
```

```yaml
- https://github.com/nikstur/bombon 
- # SBOM # fellow # workshop # CFP
```

```yaml
- https://www.nmattia.com/posts/2019-01-15-easy-peasy-nix-versions/ 
  - # folder structure
  - # auto update # version # revision
```

```yaml
- https://www.nmattia.com/posts/2022-12-18-lockfile-trick-package-npm-project-with-nix/
  - # CFP # FELLOW # WORKSHOP # DEEP DIVE # EXPERIMENT 🔥
  - # Build a nix derivation by parsing lockfile
```

```yaml
- https://www.nmattia.com/posts/2019-10-08-runtime-dependencies/
  - Give us the store paths of runtime dependencies
  - Give us the derivation attributes of all the buildtime dependencies

- nix-build -A nginx '<nixpkgs>' # size
  - nix path-info -rSh /nix/store/f8w3484r4va451m2jfhw547pldxfwi5j-nginx-1.22.1
```

```yaml
- 🔬 https://github.com/google/go-containerregistry/blob/main/cmd/crane/cmd/mutate.go
  - # entrypoint # cmd # user # working dir # crane # programmatic

- 🔬 😍 https://gist.github.com/ahmetb/430baa4e8bb0b0f78abb1c34934cd0b6
  - # go # layer # programmatic # nginx app
```

```yaml
- # DEBUG # DEPENDENCIES
  - nix-instantiate --eval --expr 'with import <nixpkgs> {}; stdenv.shell'
  - nix-instantiate --eval --expr 'with import <nixpkgs> {}; dockerTools.shadowSetup'  | jq -r .
```

```yaml
- IS NOT REPRODUCIBLE
  - src = ./.;
  - import  <nixpkgs>  {}
```

```yaml
- https://github.com/mzabani/codd/blob/master/nix/docker/codd-exe.nix 
  - # shadowSetup adds a dependency on `shadow`, which I guess pulls in glibc
  - # shadowSetup # addgroup # adduser
  - # runAsRoot # kvm # overlay # glibc
  - # rm -rf /nix/store/*-glibc-* /nix/store/*-bash-* /nix/store/*-ncurses-* # minimal
```

```yaml
- # KVM # NO KVM # OVERLAY # CONTAINER # WORKSHOP # DEEP DIVE
- https://github.com/mzabani/codd/tree/master/nix/docker
- 🔬 😍 https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/docker/default.nix
```

```yaml
- # extraCommand # root # fakeRootCommands
- https://discourse.nixos.org/t/how-to-run-chown-for-docker-image-built-with-streamlayeredimage-or-buildlayeredimage/11977 
- https://github.com/NixOS/nixpkgs/pull/116749
  - # symlinkJoin # postBuild # tar # pkgs.pkgsStatic.busybox # $stdenv/setup
```

```yaml
- 🔬🔥 https://github.com/NixOS/nixpkgs/pull/122608 # fellow # research # layers # caching
- https://github.com/NixOS/nixpkgs/issues/48462 # layers # fellow
- https://github.com/NixOS/nixpkgs/issues/48462 # passwd # root # group # user # container
- https://github.com/NixOS/nixpkgs/issues/48462 # env # coreutils # container # symlink
- https://github.com/NixOS/nixpkgs/pull/108416 # layered image # symlink 
  - # pkgs/build-support/docker/stream_layered_image.py
- https://github.com/NixOS/nixpkgs/issues/94636 # 2x image size # containers
- UID of the user is NOT KNOWN at BUILD time:
  - Using chown to set the user for the directories and files is no option
  - However PRIMARY GROUP for the USER used, is always ROOT (of GID 0) 🎯
- Dockerfile & nonroot user settings
    - RUN chown -R 1001:0 /var/log/nginx # primary group i.e. root i.e. 0 is owner to the folder
    - RUN chmod -R g+w /var/log/nginx # primary group has write permissions to the folder
    - # hence non root user will have these permissions
    - # Also make sure that you change any TCP ports to a value higher than 1024
    - # If you’re running NGINX, change the port number
    - # E.g. use port 8080 for the container, instead of the default port 80
    - # Use a Load Balancing service to forward traffic from port 80 to port 8080 on the container
    - USER 1001 # make sure that it doesn’t run as root
- When you don’t specify the USER command in the Dockerfile, the container will run as ROOT user
- A semi random user in turn may cause file permissions issues
  - Since this user might not have sufficient access to the files that it needs (eg. /var/log or /etc)
- Adding __noChroot = true on a derivation, it turns off the sandbox selectively for that derivation 
  - # autoPatchelfHook # nativeBuildInputs # buildInputs
- nix show-derivation $drv # look into the build recipe # debug # deep dive
  - nix-shell $drv --run 'cat $stdenv/setup'
- https://scrive.github.io/nix-workshop/index.html # workshop # RTFM # manual # guide # learn # getting started
- https://github.com/NixOS/nixpkgs/tree/master/pkgs/build-support # fellow # internals # experiment
- nix repl && :l <nixpkgs>
  - nix-repl> pkgsCross.aarch64-multiplatform.cmake # build platform
  - nix-repl> pkgsCross.aarch64-multiplatform.buildPackages.cmake # host platform
  - nix-repl> cmake # host platform
- buildInputs: runtime ~ shared dependencies ~ targets host platform ~ target architecture
- nativeBuildInputs: build dependencies ~ cross compile ~ targets build platform ~ build architecture
  - # MNEMONIC: build given extra ceremony
- nativeBuildInputs: determines what packages are compiled natively when cross compiling # 🤨
  - Everything else in buildInputs is cross compiled # fellow # 🤯
- crossEnvHook is called for buildInputs and envHook is called for nativeBuildInputs
- Sometime in python you need to list same dependencies as a nativeBuildInputs and as a buildInput
  - # If the package needs to run python during build and will link against it
- nix-prefetch-git --url https://github.com/fwbuilder/fwbuilder --rev "v6.0.0-rc1" # checksum # hash
- aliter: # checksum # hash
  - git clone git@github.com:fwbuilder/fwbuilder.git /tmp/fwbuilder
  - mv /tmp/fwbuilder/.git /tmp/. && nix hash-path /tmp/fwbuilder
- https://github.com/tazjin/nixery/blob/master/builder/builder.go # shell # architecture # meta packages
- https://gist.github.com/CMCDragonkai/9b65cbb1989913555c203f4fa9c23374 # runtime # build time dependencies # shell script
- convert nix file to json # builtins.toJSON
- config.Env = ["SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"]; # buildImage # buildLayeredImage
- https://github.com/utdemir/nix-tree # browse dependency graph of nix derivation
- https://discourse.nixos.org/t/kvm-is-required-error-building-a-docker-image-using-runasroot/22923/17 
  - # runAsRoot to runCommand # containers
- runCommand is a short wrapper around stdenvNoCC.mkDerivation # when you want something small
- https://shopify.engineering/what-is-nix # shorts # tips
- https://github.com/cachix/devenv # fellow # deep dive
- https://github.com/nlewo/nix2container/blob/b008fe329ffb59b67bf9e7b08ede6ee792f2741a/examples/openbar.nix#L1 # permissions # copyToRoot
- pkgs.dockerTools provides some helpers to set up an environment with the necessary files
  - # http://ryantm.github.io/nixpkgs/builders/images/dockertools/#ssec-pkgs-dockerTools-helpers
  - # usrBinEnv # binSh # caCertificates # fakeNss
- warning: in docker image nginx: The contents parameter is deprecated. 
  - Change to copyToRoot if the contents are designed to be copied to the root filesystem
  - Such as when you use `buildEnv` or similar between contents and your packages
  - Use copyToRoot = buildEnv { ... }; or similar if you intend to add packages to /bin
- error: Package ‘aarch64-unknown-linux-gnu-cctools-port-973.0.1’ in 
  - /nix/store/qr9awx73k8wv6y6j8sl0w3gkd3c8xv09-source/pkgs/os-specific/darwin/cctools/port.nix:186 
  - is marked as broken, refusing to evaluate
- https://nix.dev/tutorials/cross-compilation # cross compilation # fellow # 😍
- pkgs = import <nixpkgs> {}: # COMPILE on BUILD platform
  - The build platform is implied in pkgs = import <nixpkgs> {} to be the current system
  - It produces a build environment pkgs.stdenv with all dependencies present to compile on the build platform
- pkgs.pkgsCross. : # compile on build platform to RUN on HOST platform
  - APPLIES the appropriate HOST platform CONFIGURATION to all the packages
  - pkgs.pkgsCross.<host>.hello will compile hello on the build platform to run on the <host> platform
- Access packages targeted to the host platform - Approach 1: # 🤨
  - pkgs = (import <nixpkgs> {}).pkgsCross.aarch64-multiplatform;
- Access packages targeted to the host platform - Approach 2:
  - pkgs = import <nixpkgs> { crossSystem = { config = "aarch64-unknown-linux-gnu"; }; }; # 🧐
- Access packages targeted to the host platform - Approach 3: # hello specific
  - nix-build '<nixpkgs>' -A hello --arg crossSystem '{ config = "aarch64-unknown-linux-gnu"; }'
  - nix-build '<nixpkgs>' -A pkgsCross.aarch64-multiplatform.hello
- https://nix.dev/tutorials/cross-compilation # nativeBuildInputs vs buildInputs
- nix-repl> pkgsCross.aarch64-multiplatform.stdenv.hostPlatform.config # "aarch64-unknown-linux-gnu"
- nix-repl> pkgs.stdenv.targetPlatform # cross compile # architecture
  - # pkgs.stdenv.targetPlatform # pkgs.stdenv.buildPlatform
  - # pkgs.buildPlatform.config # pkgs.targetPlatform.config # pkgs.hostPlatform.config
  - # system is an abbreviation of the format [cpu]-[os]
  - # config is an abbreviation of the form [cpu]-[vendor]-[os] or [cpu]-[vendor]-[os]-[abi] # LLVM triple
- Use pkgsCross.platform instead of pkgs to cross compile
  - # nix-build '<nixpkgs>' -A pkgsCross.raspberryPi.openssl
- https://nixos.wiki/wiki/Cross_Compiling # basics # aarch64 # raspberryPi # overlay # override
- https://tmp.bearblog.dev/minimal-containers-using-nix/ # nginx # error
- https://github.com/reproducible-containers/buildkit-nix/blob/master/examples/nginx-flake/flake.nix # nginx
- https://github.com/reproducible-containers/buildkit-nix/blob/master/examples/nginx/default.nix # nginx
- https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/docker/examples.nix # nginx
- https://github.com/flyingcircusio/vulnix # CVE # Scanner # Python # NVD # NIST # patch
- https://discourse.nixos.org/t/the-future-of-the-vulnerability-roundups/22424 # SBOM # CVE
- https://www.bekk.christmas/post/2021/16/dotfiles-with-nix-and-home-manager # home manager
- https://www.bekk.christmas/post/2021/13/deterministic-systems-with-nix # quote # cfp # ppt
- https://hoverbear.org/blog/a-flake-for-your-crate/ # rust # basics to advanced # quote
- https://github.com/LnL7/nix-docker # base image # from scratch # final image on Dockerfile
- https://lewo.abesis.fr/posts/nix-build-container-image/ # faster dockerTools.buildImage
- https://github.com/LnL7/nix-darwin # nix modules for darwin # experiments # fellow
- https://github.com/mozilla/nixpkgs-mozilla # nix overlay
- https://github.com/nix-community/fenix # rust toolchain
- https://github.com/tfc/nix_cmake_example # c++ # python # nix
- https://bmcgee.ie/posts/2022/11/getting-nixos-to-keep-a-secret/ # sops
- https://determinate.systems/posts/nuenv # experiment # deep dive
- https://earthly.dev/blog/what-is-nix/ # CFP # Idea # Quote Un-Quote # Learn # cfp # ppt
- https://www.youtube.com/watch?v=pfIDYQ36X0k # Building Production Containers with Nix
- https://www.youtube.com/playlist?list=PLRGI9KQ3_HP_OFRG6R-p4iFgMSK1t5BHs # Nixology # Shopify # Learn
- https://blog.replit.com/nix # LSP # Language
- https://github.com/nix-community/nixpkgs-swh # send nixpkgs tarballs to software heritage
- https://github.com/nlewo/gremnix # browse reference graph of nix store paths
- https://github.com/nlewo/nix2container # archive less nix to container image implementation
- nix-repl> runCommand "nameOfRecipeOrDrv" { } " echo hello > $out "
  - # gives <<derivation /nix/store/xxxxxx...xxxxxx-nameOfRecipeOrDrv.drv>>
- nix-repl> :b runCommand "nameOfRecipeOrDrv" { } " echo hello > $out " # builds the derivation
- nix-repl> :b runCommand "nameOfRecipeOrDrv" { } " ${firefox}/bin/firefox --version > $out " 
  - # builds firefox from source, then outputs the resulting binary version to $out file, all inside the sandbox
- :e pkgs.dockerTools.buildImage # opens the file containing this function
  - # same as # :e dockerTools.buildImage # pkgs. is optional in repl
- https://github.com/nix-community/docker-nixpkgs # containers
- https://github.com/teamniteo/nix-docker-base # containers
- readlink .nix-profile # get the actual path from the symlink
- https://www.youtube.com/watch?v=KaIRpx11qrc # how shopify uses nix
- cmakeFlags = pkgs.lib.remove "SOME-EXISTING-FLAG" old.cmakeFlags;
- nix build nixpkgs#nixStatic # statically compile nix # send the binary to another VM
- nix-repl> python3.withPackages (p: [ p.numpy ]) # 🥶 Why simple braces? # Why not { p: [ p.numpy ] }
  - # Above gives the derivation # i.e. EVALUATION
  - nix-repl> :b python3.withPackages (p: [ p.numpy] ) # :b builds the derivation # REALISATION
- pkgs = nixpkgs.legacyPackages.x86_64-linux;
- inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05"; # a flake # 🥶 Why nixos?
- https://www.youtube.com/watch?v=0uixRE8xlbY # flake.nix vs Dockerfile
- nix eval -f some.nix some-attr # where some.nix i.e. expression results into a attribute set that has some-attr
- pkgs.redis.overrideAttrs # each nix pkg has this function # hook into the build derivation
- build minimal redis image using nix # https://youtu.be/WP_oAmV6C2U?t=3764 
  - # static binary with musl # remove systemd # remove extra binaries # postInstall
- if cache helps then use buildLayeredImage # each layer may contain 1 package # based on popularity
- list vs attribute set
  - [ "my string" 1.10 20] # heterogenous list # no commas or semicolons
  - { A = B; C = D; } # attribute set # many semicolons
- "${pkgs.redis}" # builds redis # REALISATION # "/nix/store/im23hh5xvnb411sl2rhhajq46i8d6df2-redis-7.0.10"
- pkgs.redis # is the drv # «derivation /nix/store/8rqdahhnnw156d9kkbzmagc6xxz28rw8-redis-7.0.10.drv»
  - # so .nix files deals with drvs # i.e. instructions to build the package
  - # process of getting from nix language to derivation is called EVALUATION
  - # to build i.e. from derivation to installed pkg is called REALISATION
  - # REALISATION is # go online # fetch # check sha # check dependencies # build in a sandbox
- everything in nix is attribute set:
  - pkgs = import <nixpkgs> {} # pkgs becomes an attribute set # <nixpkgs> is path to nixos/nixpkgs repo
  - [ pkgs.redis ] # same as # with pkgs; [ redis ] # 🥶 another instance of semicolon
- builtins.getEnv "PATH" # "/Users/amitd2/.nix-profile/bin:/nix/var/nix/profiles/default/bin"
- add = a: b: a + b # add 1 4 # arguments suffixed with :
- add = { a,  b ? 2 }: a + b # default value # attribute set is an argument # add { a = 4; }
- { A = { B = 1; }; } # equals { A.B = 1; } # a nested attribute set in nix
- rec { A = 1, B = A; } # attributes split by commas # end with semicolon upon assignment # refer recursively
  - # 🥶 WHY: comma after assignment & not a semicolon
  - # { A = B ; C = D; } # nix attribute set separated by semicolons
- B = let me = 1; in { A = me; } # me is available in the scope after in i.e. the attribute set after in 
  - # MNEMONIC: LET me scope IN
  - inherit (B) A; # ~ A = B.A; # extract the expression output as an aliased assignment
  - inherit name; # ~ name = name; # scope in the name variable # name is not within any attribute set
- https://www.youtube.com/watch?v=WP_oAmV6C2U # Nix builds Docker images better than docker build
- mkDerivation # make build && make install
- x = python3.withPackages (p: [ p.numpy ]) # x. tab 
  - # x.outPath is the path that Nix asks for # nix will not build if someone has that path
- https://checkoway.net/musings/nix/ # on mac # one pager
- https://nix-tutorial.gitlabpages.inria.fr/nix-tutorial/index.html # read world # guide # basics # advanced # precise # scientific experiments
- https://github.com/Mic92/nixos-shell # vs LIMA
- cross compile in debian # install qemu, binfmt-support, qemu-user-static & a lot of other steps
- nix build nixpkgs#pkgCross. # tab & see all the cross compilation architectures possible
- nix build nixpkgs#pkgCross.riscv64.hello - L --rebuild # ignore cache & compile from source again
  - file ./result/bin/hello # ELF # dynamic executable # stripped # GNU/Linux # glibc # ld-linux- # binfmt
  - # nix spawns QEMU in user mode; runs the binary; gets the result in stdout # binary format registration
  - # binfmt.emulatedSystems
  - # you dont have to configure QEMU or WINE

- https://github.com/nix-community/naersk # build rust crates in Nix
- https://scvalex.net/posts/68/ # build containers with Nix & Gitlab CI
- https://www.youtube.com/watch?app=desktop&v=6Le0IbPRzOE # What Nix Can Do # Docker Can't
  - # LTS on Nix # LTS Build Overlay # CFP
```
