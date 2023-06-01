### Getting Started & Local Development
```diff
@@ Step 0 - Clean Up @@

# nix-collect-garbage
```

```diff
@@ Step 1: Understand Nix packages required for local development @@
```

```sh
nix-env -qP --available git yarn nodejs
```

```diff
@@ Step 2: Prepare the environment for local development @@
```

```nix
# file: shell.nix

# Configures a shell environment that builds required 
# local packages to run Backstage
let 
  pkgs = import <nixpkgs> {};
in pkgs.stdenv.mkDerivation {
  name = "backstage-dev-shell";

  buildInputs = with pkgs; [ git yarn nodejs ];
}
```

```sh
$ nix-shell
[nix-shell:~/work/nix/jun-backstage]$
[nix-shell:~/work/nix/jun-backstage]$ exit
```


### References
```yaml
- https://backstage.io/docs/overview/architecture-overview/
- https://backstage.io/docs/architecture-decisions/
```
