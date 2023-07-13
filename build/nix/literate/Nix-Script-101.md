
#### `Writing a Container Entrypoint Shell Script`
```yaml
- shoutout: https://github.com/mirkolenz/grpc-proxy/blob/main/default.nix
```

```nix
{
  lib,
  writeShellApplication,
  env,
  coreutils,
  gomplate,
  envoy,
  ...
}:
writeShellApplication {
  name = "entrypoint";
  text = ''
    if [ $# -eq 0 ]; then   # coreutils for echo
      ${coreutils}/bin/echo "Provide these: PROXY_PORT, BACKEND_PORT." >&2
      exit 1
    fi

    PROXY_OUTDIR=$(${coreutils}/bin/mktemp --directory)             # coreutils for tmp dir
    PROXY_ENVOY_CONFIG="$PROXY_OUTDIR/envoy.yaml"

    ${coreutils}/bin/env --ignore-environment \                     # coreutils for env
      ${builtins.toString (lib.mapAttrsToList (key: val: "${key}=${val}") env)} \
      "$@" \
      ${lib.getExe gomplate} \                                      # TIL: getExe
      --config ${./gomplate.yaml} \
      --file ${./envoy.yaml} \
      --out "$PROXY_ENVOY_CONFIG"

    ${lib.getExe envoy} -c "$PROXY_ENVOY_CONFIG"                    # Q: What is this envoy?
  '';
}
```

```yaml
- Invokes above .nix via callPackage
```
```nix
{
  lib,
  dockerTools,
  callPackage,
  ...
}: let
  entrypoint =
    callPackage ./.
    {
      env = rec {
        PROXY_HOST = "0.0.0.0";
        ADMIN_HOST = PROXY_HOST;
        BACKEND_HOST = "host.docker.internal";
      };
    };
in
  dockerTools.buildLayeredImage {
    name = "grpc-proxy";
    tag = "latest";
    created = "now";                # Q: Is this reproducibility? consistency?
    extraCommands = ''
      mkdir -p tmp                  # Why? # TIL: Is mkdir not required in base image?
    '';
    config = {                                   # TIL: lib can be used here
      entrypoint = [(lib.getExe entrypoint)];    # TIL: getExe to script
      cmd = [];
    };
  }
```
