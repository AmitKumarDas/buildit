#### Experiments
```yaml
- cmd: nix run github:nlewo/nix2container#examples.nginx.copyToDockerDaemon
- aliter: nix run .#examples.nginx.copyToDockerDaemon
- aliter: nix build .#examples.nginx # gives the json file # docker manifest?
```
