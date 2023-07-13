
### Writing a Container Entrypoint Shell Script
```yaml
- https://github.com/mirkolenz/grpc-proxy/blob/main/default.nix
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
    if [ $# -eq 0 ]; then
      ${coreutils}/bin/echo "Provide these: PROXY_PORT, BACKEND_PORT." >&2    # coreutils for echo
      exit 1
    fi

    PROXY_OUTDIR=$(${coreutils}/bin/mktemp --directory)                       # coreutils for tmp dir
    PROXY_ENVOY_CONFIG="$PROXY_OUTDIR/envoy.yaml"

    ${coreutils}/bin/env --ignore-environment \                               # coreutils for env
      ${builtins.toString (lib.mapAttrsToList (key: val: "${key}=${val}") env)} \
      "$@" \
      ${lib.getExe gomplate} \                                                # TIL: getExe
      --config ${./gomplate.yaml} \
      --file ${./envoy.yaml} \
      --out "$PROXY_ENVOY_CONFIG"

    ${lib.getExe envoy} -c "$PROXY_ENVOY_CONFIG"                              # Q: What is this envoy?
  '';
}
```
