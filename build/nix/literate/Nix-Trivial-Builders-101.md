### Unpack Trivial Builders
```yaml
- source: https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/trivial-builders/default.nix
- https://github.com/NixOS/nixpkgs/blob/dade7540afee3578f7a4b98a39af42052cbc4a85/pkgs/build-support/trivial-builders.nix
- extra: Learn through commit history
```

### Simple Invocations
```nix
# Produce a store path named 'name'
# The attributes in 'env' are added to the environment prior to running the command
runCommand "name" {envVariable = true;} ''echo hello > $out''
```

```nix
# runCommandCC uses the default stdenv, 'pkgs.stdenv'
runCommandCC "name" {} ''gcc -o myfile myfile.c; cp myfile $out'';
```

```nix
# Writes my-file to /nix/store/<STORE PATH>
writeTextFile {
  name = "my-file";
  text = ''
    Contents of File
  '';
}
```

```nix
# Writes EXECUTABLE my-file to /nix/store/<store path>/bin/my-file
writeTextFile {
  name = "my-file";
  text = ''
    Contents of File
  '';
  executable = true;
  destination = "/bin/my-file";    # ------- YOU SPECIFY /bin
}
```

### Unpack WriteTextFile
```nix
matches = builtins.match "/bin/([^/]+)" destination;       # ------ REGEX
```

```nix
meta = lib.optionalAttrs (executable && matches != null) { # --- CONDITION
  mainProgram = lib.head matches;                          # --- WHAT
} // meta;                                                 # --- MERGE RIGHT
```

```nix
target=$out${lib.escapeShellArg destination}               # --- PATH CONSTRUCTION
mkdir -p "$(dirname "$target")"                            # 🎖️🎖️🎖️ NESTED INTERPOLATIONS
```

### Bash Inside Nix
```nix
''
if [ -e "$textPath" ]; then                 # --- EXISTS?
  mv "$textPath" "$target"
else
  echo -n "$text" > "$target"
fi

if [ -n "$executable" ]; then               # --- NOT false
  chmod +x "$target"
fi
''
```

### Unpack WriteTextDir
```nix
writeTextDir "share/my-file"
  ''
  Contents of File
  '';
```
```nix
writeTextDir = path: text: writeTextFile {
  inherit text;
  name = builtins.baseNameOf path;           # -- 🎖️🎖️🎖️ NAME is DERIVED
  destination = "/${path}";
};
```

### Unpack writeShellScript / writeShellScriptBin
```nix
writeShellScript = name: text:
  writeTextFile {
    inherit name;
    executable = true;
    text = ''
      #!${runtimeShell}                # --- 🎖️🎖️🎖️ PREPENDS SHEBANG / INTERPRETER
      ${text}
      '';
    checkPhase = ''
      ${stdenv.shellDryRun} "$target"  # --- 🎖️🎖️ SYNTAX CHECK ONLY! NOT shellcheck!
    '';
  };
```

### Unpack writeShellApplication
```nix
writeShellApplication {                 # 💡💡💡 Incredible for TESTING
  name = "my-file";
  runtimeInputs = [ curl w3m ];         # --- 🥤🥤🥤 WOW! Is this still SANDBOXED build?
  text = ''
    curl -s 'https://nixos.org' | w3m -dump -T text/html # 💡💡💡 One off Bash Commands
   '';
}
```

```nix
writeShellApplication =
  { name
  , text
  , runtimeInputs ? [ ]
  , checkPhase ? null
  }:
  writeTextFile {
    inherit name;
    executable = true;
    destination = "/bin/${name}";
    allowSubstitutes = true;
    preferLocalBuild = false;
    text = ''
      #!${runtimeShell}                                # --- Interpreter / Shebang
      set -o errexit                                   # --- NICE
      set -o nounset
      set -o pipefail
    '' + lib.optionalString (runtimeInputs != [ ]) ''  # --- CONDITION

      export PATH="${lib.makeBinPath runtimeInputs}:$PATH"  # 🎖️🎖️🎖️ HOW NIX makes PATH to WORK
    '' + ''

      ${text}
    '';

    checkPhase =
      if checkPhase == null then ''
        runHook preCheck
        ${stdenv.shellDryRun} "$target"                  # --- WHAT'S target? # --- Syntax Check
        # use shellcheck which does not include docs
        # pandoc takes long to build                     # 🎖️🎖️🎖️🎖️ IGNORE docs via Static EXE
        # and documentation isn't needed for in nixpkgs usage   # 🎖️🎖️🎖️ shellcheck for free # LINTER
        ${lib.getExe (haskell.lib.compose.justStaticExecutables shellcheck.unwrapped)} "$target"
        runHook postCheck                                # --- BEST Practice
      ''
      else checkPhase;
  };
```




