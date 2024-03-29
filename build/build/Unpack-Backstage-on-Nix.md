### Getting Started & Local Development
```diff
@@ Step 0 - Clean Up @@

# nix-collect-garbage
```

```diff
@@ Step 1: Understand Nix Packages Required for Local Development @@
```

```sh
nix-env -qP --available git yarn nodejs
```

```diff
@@ Step 2: Prepare Backstage Environment for Local Development @@
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


### Re-Imagined
```yaml
- https://aws.amazon.com/blogs/opensource/how-traveloka-uses-backstage-as-an-api-developer-portal-for-amazon-api-gateway/
```

### Others
```yaml
- https://backstage.io/docs/overview/architecture-overview/
- https://backstage.io/docs/architecture-decisions/
```
