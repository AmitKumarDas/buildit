## We Want To Pin Always

## Takeaways
- The package repository nixpkgs is based on the concept of channels
- Channels are basically branches of development in the git repository

- The Nix way of locking down dependencies is to pin the nixpkgs versions
- In essence this is to use a version of nixpkgs from a specific commit, a snapshot
- This ensures that building the Nix derivation will always result in the same output
- Different derivations may also use different versions of nixpkgs 
- To upgrade one or more dependencies change the snapshot of nixpkgs to a newer version


- Nix 2.0 introduces new builtins:
  - fetchTarball
  - fetchGit
- which make it possible to fetch a specific version of nixpkgs without depending on an existing one


## CMDs

- Will list the channels from which Nix downloads the packages
  - `nix-channel --list`

- Get Rev & Ref of a git branch
  - `git ls-remote https://github.com/nixos/nixpkgs nixos-unstable`
  - You get something similar to following
    - 872fceeed60ae6b7766cc0a4cd5bf5901b9098ec	refs/heads/nixos-unstable
  - Note that this will not remain same & will change as more commits get in 

- Get SHA of a remote tar
  - `nix-prefetch-url --unpack <url>`
  - where url = https://github.com/nixos/nixpkgs/archive/ca2ba44cab47767c8127d1c8633e2b581644eb8f.tar.gz
  - This gives us the sha256

- Calculate current version & hash of a branch by using nix-prefetch-git
  - nix-shell -p nix-prefetch-git
  - nix-prefetch-git https://github.com/nixos/nixpkgs.git refs/heads/nixos-unstable
  - _or_
  - nix-prefetch-git https://github.com/nixos/nixpkgs.git refs/heads/nixos-unstable > nixpkgs-version.json
  - where nix-prefetch-git is a package
  - You get an output similar to below:
  - Notice clone like logic ! Do read the internals of this package ! 🥸 
```shell
Initialized empty Git repository in /private/tmp/git-checkout-tmp-SacjSXLp/nixpkgs/.git/
remote: Enumerating objects: 53959, done.
remote: Counting objects: 100% (53959/53959), done.
remote: Compressing objects: 100% (34365/34365), done.
remote: Total 53959 (delta 2087), reused 50429 (delta 1931), pack-reused 0
Receiving objects: 100% (53959/53959), 38.55 MiB | 2.69 MiB/s, done.
Resolving deltas: 100% (2087/2087), done.
From https://github.com/nixos/nixpkgs
 * branch              nixos-unstable -> FETCH_HEAD
 * [new branch]        nixos-unstable -> origin/nixos-unstable
Updating files: 100% (32634/32634), done.
Switched to a new branch 'fetchgit'
removing `.git'...

git revision is 872fceeed60ae6b7766cc0a4cd5bf5901b9098ec
path is /nix/store/2bv7d6bnk7cn4ja495lnf1mdz2lyra52-nixpkgs
git human-readable version is -- none --
Commit date is 2022-11-09 08:03:51 -0300
hash is 1fhv0lfj7khfr0fvwbpay3vq3v7br86qq01yyl0qxls8nsq08y0c
{
  "url": "https://github.com/nixos/nixpkgs.git",
  "rev": "872fceeed60ae6b7766cc0a4cd5bf5901b9098ec",
  "date": "2022-11-09T08:03:51-03:00",
  "path": "/nix/store/2bv7d6bnk7cn4ja495lnf1mdz2lyra52-nixpkgs",
  "sha256": "1fhv0lfj7khfr0fvwbpay3vq3v7br86qq01yyl0qxls8nsq08y0c",
  "fetchLFS": false,
  "fetchSubmodules": false,
  "deepClone": false,
  "leaveDotGit": false
}
```


## Nix 2.0 Onwards
```nix
import (builtins.fetchTarball {
  # Descriptive name to make the store path easier to identify
  name = "nixos-unstable-2018-09-12";
  # Commit hash for nixos-unstable as of 2018-09-12
  url = "https://github.com/nixos/nixpkgs/archive/ca2ba44cab47767c8127d1c8633e2b581644eb8f.tar.gz";
  # Hash obtained using `nix-prefetch-url --unpack <url>`
  sha256 = "1jg7g6cfpw8qvma0y19kwyp549k1qyf11a5sg6hvn6awvmkny47v";
}) {}
```

```nix
import (builtins.fetchGit {
  # Descriptive name to make the store path easier to identify
  name = "nixos-unstable-2018-09-12";
  url = "https://github.com/nixos/nixpkgs/";
  # Commit hash for nixos-unstable as of 2018-09-12
  # `git ls-remote https://github.com/nixos/nixpkgs nixos-unstable`
  ref = "refs/heads/nixos-unstable";
  rev = "ca2ba44cab47767c8127d1c8633e2b581644eb8f";
}) {}
```

## Before Nix 2.0
### Use the host's Nixpkgs as a springboard to fetch and import a **specific, pinned version** of Nixpkgs
```nix
pkgs = let
  hostPkgs = import <nixpkgs> {};
  pinnedPkgs = hostPkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    # nixos-unstable as of 2017-11-13T08:53:10-00:00
    rev = "ac355040656de04f59406ba2380a96f4124ebdad";
    sha256 = "0frhc7mnx88sird6ipp6578k5badibsl0jfa22ab9w6qrb88j825";
  };
in import pinnedPkgs {}
```

- Alternate style
  - nix-shell -p nix-prefetch-git
  - [nix-shell:~]$ nix-prefetch-git https://github.com/nixos/nixpkgs.git refs/heads/nixos-unstable > nixpkgs-version.json
  - Use above file to specify the version of Nixpkgs

```nix
pkgs = let
   hostPkgs = import <nixpkgs> {};
   pinnedVersion = hostPkgs.lib.importJSON ./nixpkgs-version.json;
   pinnedPkgs = hostPkgs.fetchFromGitHub {
     owner = "NixOS";
     repo = "nixpkgs";
     inherit (pinnedVersion) rev sha256;
   };
 in import pinnedPkgs {};
```

### This can also be instead used to pull nixpkgs from an internal fork of Nixpkgs, with your own changes on top
- You can apply extra patches to the pinned version of Nixpkgs
- For perhaps PRs that are not yet merged, or private internal changes that you need
- If you take this route, probably best to move the following in to its own file that you then import

```nix
pkgs = let
   hostPkgs = import <nixpkgs> {};
   pinnedVersion = hostPkgs.lib.importJSON ./nixpkgs-version.json;
   pinnedPkgs = hostPkgs.fetchFromGitHub {
     owner = "NixOS";
     repo = "nixpkgs";
     inherit (pinnedVersion) rev sha256;
   };
 
   patches = [
     ./patches/0001-my-nixpkgs-change.patch
   ];
 
   patchedPkgs = hostPkgs.runCommand "nixpkgs-${pinnedVersion.rev}"
     {
       inherit pinnedPkgs;
       inherit patches;
     }
     ''
       cp -r $pinnedPkgs $out
       chmod -R +w $out
       for p in $patches; do
         echo "Applying patch $p";
         patch -d $out -p1 < "$p";
       done
     '';
 in import patchedPkgs {};
```

## References
- https://myme.no/posts/2020-01-26-nixos-for-development.html
- https://nixos.wiki/wiki/FAQ/Pinning_Nixpkgs
