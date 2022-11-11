## Can we use package managers like pip along with Nix 
- Nix doesn’t stop you from using package managers like pip and yarn 
- The downside is that Nix has no knowledge of what these tools are doing
- And so cannot ensure the same guarantees 
- It is possible to use these other tools to fetch or build the software we want
- Then inform Nix about the artifacts, which is then able to add these to the Nix store

- Tools that automatically **generate Nix expressions** from input are called **generators**
- The output of these generators are Nix expressions 
- Which can then be saved to file and evaluated by nix-build and nix-shell

- In the case of nixpkgs there are also **wrapper functions around generators**
- Which saves you from having to use the generators themselves
- One example of this is callCabal2nix used for building Haskell packages


## References
- refer - https://myme.no/posts/2020-01-26-nixos-for-development.html
