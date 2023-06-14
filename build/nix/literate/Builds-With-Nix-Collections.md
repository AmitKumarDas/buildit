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
```

```yaml
- Unpack Series - https://github.com/nlewo/nix2container # Move to its Own Page
- https://www.youtube.com/watch?v=-hsxXBabdX0&t=4361s
  - 1/ A go program generates JSON files from a graph of store paths
  - At build time Nix uses go program to generate JSON files
  - 2/ go library generates layer tar streams from these JSON files
  - At runtime a modified Skopeo uses the go library to stream layers
```

```yaml
- JVM Series:
  - https://av.tib.eu/media/50716 # scala
- Unpack Series:
  - https://github.com/google/go-containerregistry/tree/main/cmd/crane
  - https://github.com/containers/skopeo
  - https://github.com/oras-project/oras
  - https://github.com/oras-project/oras-go
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
