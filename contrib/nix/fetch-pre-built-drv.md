## Nix can fetch pre-built derivations
Which is already built

## Session 1
- refer - https://myme.no/posts/2020-01-26-nixos-for-development.html
- Nix is a source distribution & a build tool
- derivation must state all 
  - its build dependencies
  - & runtime dependencies
- these dependencies are Nix expressions to other derivations
- trusted cache source - cache.nixos.org
- 