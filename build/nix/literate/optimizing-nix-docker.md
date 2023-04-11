### Motivation
```yaml
- why: Use above link to build minimal container image
- refer: https://jade.fyi/blog/optimizing-nix-docker/
```

#### A sample nix file that results into a container image
```nix
{
  nixpkgs ? import <nixpkgs> { }
}:
  let
      dockerEntrypoint = nixpkgs.writeScriptBin "entrypoint.sh" ''
        #!${nixpkgs.runtimeShell}
        echo $out
      '';
  in nixpkgs.dockerTools.buildImage {
    name = "literate";
    tag = "0";

    # everything in this is *copied* to the root of the image
    contents = [
      dockerEntrypoint
      nixpkgs.coreutils
      nixpkgs.runtimeShellPackage
    ];

    # run unprivileged with the current directory as the root of the image
    extraCommands = ''
      #!${nixpkgs.runtimeShell}
      mkdir -p data
    '';

    # Docker settings
    config = {
      Cmd = [ "entrypoint.sh" ];
      WorkingDir = "/data";
      ExposedPorts = {
        "3000" = {};
      };
      Volumes = {
        "/data" = {};
      };
    };
  }
```

```json
nix build -f default.nix
```

```json
trace: 
  warning: 
    in docker image literate: The contents parameter is deprecated. 
    Change to copyToRoot if the contents are designed to be copied to the root filesystem, 
    such as when you use `buildEnv` or similar between contents and your packages. 
    Use copyToRoot = buildEnv { ... }; or similar if you intend to add packages to /bin
```

```json
docker load < result
docker images
```

```json
REPOSITORY   TAG       IMAGE ID       CREATED        SIZE
literate     0         3ce442e9c9b8   53 years ago   47.1MB
```

#### Detour: How to introspect the built image
```yaml
- refer: 
```

```nix

```

