### Unpack Trivial Builders
```yaml
- https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/trivial-builders/default.nix
```

### Learn Usage
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

### Nix 101
```nix
matches = builtins.match "/bin/([^/]+)" destination;       # --- REGEX
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

### The Origins - Unpack runCommandWith 🙇‍♀️
```nix
runCommandWith =
  let
    # prevent infinite recursion for the default stdenv value
    defaultStdenv = stdenv;
  in
  {
  # which stdenv to use, defaults to a stdenv with a C compiler, pkgs.stdenv
    stdenv ? defaultStdenv
  # whether to build this derivation locally instead of substituting
  , runLocal ? false
  # extra arguments to pass to stdenv.mkDerivation
  , derivationArgs ? {}
  # name of the resulting derivation
  , name
  # TODO(@Artturin): enable strictDeps always
  }: buildCommand:                              # 🥤🥤🥤 buildCommand ~ Bash Commands
  stdenv.mkDerivation ({                        # --- This is a DERIVATION
    enableParallelBuilding = true;              # 🤔🤔🤔 WHAT?
    inherit buildCommand name;
    passAsFile = [ "buildCommand" ]             # --- "text" is another option
      ++ (derivationArgs.passAsFile or []);     # 🤔🤔🤔 Pass Args as FILE?
  }
  // lib.optionalAttrs (! derivationArgs?meta) {
    pos = let args = builtins.attrNames derivationArgs; in    # 🧐🧐🧐 Fetch ARGS' KEYS?
      if builtins.length args > 0
      then builtins.unsafeGetAttrPos (builtins.head args) derivationArgs
      else null;
  }
  // (lib.optionalAttrs runLocal {
        preferLocalBuild = true;
        allowSubstitutes = false;
     })
  // builtins.removeAttrs derivationArgs [ "passAsFile" ]); # 🧐🧐🧐 WHAT?
```

### Unpack writeTextFile - Learn This To Create Your Own 🙇‍♀️🙇‍♀️🙇‍♀️
```nix
writeTextFile =
  { name # the name of the derivation
  , text
  , executable ? false # run chmod +x ?
  , destination ? ""   # relative path appended to $out eg "/bin/foo"
  , checkPhase ? ""    # syntax checks, e.g. for scripts
  , meta ? { }
  , allowSubstitutes ? false
  , preferLocalBuild ? true     # 👈👈👈
  }:
  let
    matches = builtins.match "/bin/([^/]+)" destination;
  in
  runCommand name                            # 📚📚📚 This is a DERIVATION
    { inherit text executable checkPhase allowSubstitutes preferLocalBuild;
      passAsFile = [ "text" ];
      meta = lib.optionalAttrs (executable && matches != null) {
        mainProgram = lib.head matches;
      } // meta;
    }
    ''
      target=$out${lib.escapeShellArg destination}
      mkdir -p "$(dirname "$target")"

      if [ -e "$textPath" ]; then
        mv "$textPath" "$target"
      else
        echo -n "$text" > "$target"        # 💡💡💡 Aliter: DOWNLOAD YOUR OWN binaries
      fi

      if [ -n "$executable" ]; then
        chmod +x "$target"                 # 💡💡💡 Aliter: Make the DOWNLOADS as EXECUTABLES
      fi

      eval "$checkPhase"
    '';
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
        ${stdenv.shellDryRun} "$target"                  # --- WHAT'S target? # --- Search this doc
        # use shellcheck which does not include docs
        # pandoc takes long to build                     # 🎖️🎖️🎖️🎖️ IGNORE docs via Static EXE
        # and documentation isn't needed for in nixpkgs usage   # 🎖️🎖️🎖️ shellcheck for free # LINTER
        ${lib.getExe (haskell.lib.compose.justStaticExecutables shellcheck.unwrapped)} "$target"
        runHook postCheck                                # --- BEST Practice
      ''
      else checkPhase;
  };
```




