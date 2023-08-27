#### Shoutout
- https://github.com/nmattia/niv

#### A JSON becomes a Schema
```yaml
- WHERE: https://github.com/nmattia/niv/blob/master/examples/cpp-libosmium/nix/sources.json
- WHAT: May not be statically defined!
- BACKEND: https://github.com/nmattia/niv/blob/master/examples/cpp-libosmium/nix/sources.nix 
```

#### Few Nix Utils
```yaml
- if builtins.hasAttr "nixpkgs" sources then sources.nixpkgs
- abort '' ''
- hasNixpkgsPath = (builtins.tryEval <nixpkgs>).success;
```

#### A Sample Function - Fetch
```nix
fetch = pkgs: name: spec:                            # fetch is the fn name # pkgs name & spec are fn args

  if ! builtins.hasAttr "type" spec then             # Note: Nix is dynamic # Needs error handling
    abort "ERROR: niv spec ${name} does not have a 'type' attribute"
  else if spec.type == "file" then fetch_file pkgs spec               # function fetch_file is invoked
  else if spec.type == "tarball" then fetch_tarball pkgs spec         # pkgs & spec are arguments to function
  else if spec.type == "git" then fetch_git spec
  else if spec.type == "builtin-tarball" then fetch_builtin-tarball spec
  else if spec.type == "builtin-url" then fetch_builtin-url spec
  else
    abort "ERROR: niv spec ${name} has unknown type ${builtins.toJSON spec.type}";   # WHY was toJSON used?
```
```nix
spec // { outPath = fetch config.pkgs name spec; }    # fetch is invoked with all its args
```
