
#### `Preparation in Nix before Writing the Script`
```nix
{
  lib,
  writeShellScriptBin,
  buildah,
  images,
  name ? "",
  names ? [],
  branch ? "",
  latest ? (builtins.elem branch ["main" "master"]),
  version ? "",
  sourceProtocol ? "docker-archive:",
  targetProtocol ? "docker://",
  format ? "v2s2",
  extraTags ? [],
  ...
}: let             # TIL: One 'let' Rules them All         # TIL: Preparations
  cleanVersion = lib.removePrefix "v" version;
  versionComponents = lib.splitString "." cleanVersion;
  manifestName = "flocken";
  allNames = names ++ (lib.optional (name != "") name);
  allTags =
    extraTags
    ++ (lib.optional (branch != "") branch)
    ++ (lib.optional latest "latest")
    ++ (lib.optional (cleanVersion != "") cleanVersion)
    ++ (lib.optionals (cleanVersion != "" && !lib.hasInfix "-" cleanVersion) [
      (lib.concatStringsSep "." (lib.sublist 0 2 versionComponents))
      (builtins.elemAt versionComponents 0)
    ]);
in
  assert (lib.assertMsg (builtins.length allNames > 0) "At least one name");
  assert (lib.assertMsg (builtins.length allTags > 0) "At least one tag");
    writeShellScriptBin "docker-manifest" ''
      set -x # echo on
      if ${lib.getExe buildah} manifest exists "${manifestName}"; then     # TIL: Invoke the Binary
        ${lib.getExe buildah} manifest rm "${manifestName}"
      fi
      ${lib.getExe buildah} manifest create "${manifestName}"
      for IMAGE in ${builtins.toString images}; do                          # Use Shell Loops With Nix Funcs
        ${lib.getExe buildah} manifest add "${manifestName}" "${sourceProtocol}$IMAGE"
      done
      for NAME in ${builtins.toString allNames}; do                         # TIL: Awk, Sed, etc. Not Needed
        for TAG in ${builtins.toString allTags}; do
          ${lib.getExe buildah} manifest push --all --format ${format} "${manifestName}" "${targetProtocol}$NAME:$TAG"
        done
      done
    ''
```

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
