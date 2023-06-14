### Motivation
- When building software is your passion
- If you think, buiding old & new software without toil is critical
- Software builds needs a focussed approach, a champion team, etc.
- Building a career on software builds
- My Awesome Nix Collections
- This is my way of writing a book on Nix

### Train Yourself
These are a set of hands-on activities that should help you achieve above goals

### Chapters

```yaml
- Basic Series:
  - https://nixos.wiki/wiki/Development_environment_with_nix-shell
  - https://www.tweag.io/blog/2022-09-01-unit-test-your-nix-code/ 
    - # import & inherit # {}: let in
    - # UNIT TESTING
    - # nix eval --impure --expr
  - https://av.tib.eu/media/50716 
    - # ci.nix, shell.nix, pkgs.nix # FOLDER structure
    - # OVERRIDE
  - https://av.tib.eu/media/39625 
    - # PINNING nixpkgs
    - # PATCHES is easy to maintain than a FORK
  - https://av.tib.eu/media/39618 
    - # FROM mkDerivation TO mkShell
    - # Run against nix-shell WITHOUT stepping inside via --run
    - # Not PURE # Not COMPOSABLE
    - # nativeBuildInputs vs propagatedBuildInputs vs buildInputs
    - # mkYarnPackage # builtins.filterSource # lib.cleanSource # removes symlinks
```

```yaml
- Unpack Series - https://github.com/nlewo/nix2container
- https://www.youtube.com/watch?v=-hsxXBabdX0&t=4361s
  - layers + config + manifest
```

```yaml
- JVM Series:
  - https://av.tib.eu/media/50716 # scala
- Unpack Series:
  - https://github.com/ipetkov/crane
  - https://github.com/nikstur/bombon
- Nix Discussions: 
  - https://discourse.nixos.org/t/generating-software-bill-of-materials-from-derivation/14089
  - https://discourse.nixos.org/t/vulnix-new-maintainer-needed/27209
  - https://discourse.nixos.org/t/introducing-crane-composable-and-cacheable-builds-with-cargo/17275
- Build K8s:
  - https://github.com/kubernetes/enhancements/ + /keps/sig-api-machinery/4052-generic-controlplane/README.md
    - blob/06979b018697c346f537512984f32df7867fdb66
```
