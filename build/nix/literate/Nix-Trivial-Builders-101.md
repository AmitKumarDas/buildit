## Unpack Trivial Builders
```yaml
- https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/trivial-builders/default.nix
```

## Advanced 🏃‍♀️🏃‍♀️🏃‍♀️

### Learn symlinkJoin To Create Your Own 🙇‍♀️🙇‍♀️🙇‍♀️
```nix
symlinkJoin =
  args_@{ name                            # 🍭🍭🍭 ALIAS ALL ARGuments as args_
       , paths
       , preferLocalBuild ? true
       , allowSubstitutes ? false
       , postBuild ? ""
       , ...
       }:
  let
    args = removeAttrs args_ [ "name" "postBuild" ]      # --- CUSTOMISE ARGS: args_ to args
      // {
        inherit preferLocalBuild allowSubstitutes;
        passAsFile = [ "paths" ];                        # 🤔🤔 Does this set $pathsPath ?
      }; # pass the defaults
  in runCommand name args
    ''
      mkdir -p $out                                      # 💡💡💡 Pure Bash! mkdir is AVAILABLE!
      for i in $(cat $pathsPath); do                     # 🧐🧐 Is this related to passAsFile ?
        ${lndir}/bin/lndir -silent $i $out               # 💡💡💡 TIL: lndir is a utility
      done
      ${postBuild}
    '';
```

### Unpack writeShellApplication: 💎 Inside
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
      set -o errexit                                   # --- NICE! Automatic Addition
      set -o nounset
      set -o pipefail
    '' + lib.optionalString (runtimeInputs != [ ]) ''  # --- CONDITION

      # 👇👇👇 This is NOT equivalent of symlinkJoin 👇👇👇
      export PATH="${lib.makeBinPath runtimeInputs}:$PATH"  # 🎖️🎖️🎖️ THIS! NIX + PATH = DEVEX
    '' + ''

      ${text}
    '';

    checkPhase =
      if checkPhase == null then ''                      # 🫣🫣🫣 Reusing checkPhase
        runHook preCheck
        ${stdenv.shellDryRun} "$target"                  # --- WHAT'S target? # --- Search this doc
        # use shellcheck which does not include docs
        # pandoc takes long to build                     # 🎖️🎖️🎖️🎖️ IGNORE docs via Static EXE
        # and documentation isn't needed for in nixpkgs usage   # 🎖️🎖️🎖️ shellcheck for free # LINTER
        ${lib.getExe (haskell.lib.compose.justStaticExecutables shellcheck.unwrapped)} "$target"
        runHook postCheck                                # --- BEST Practice
      ''
      else checkPhase;                                   # --- existing checkPhase?
  };
```

#### Extra Conditions
```nix
checkPhase =
  # GHC (=> shellcheck) isn't supported on some platforms (such as risc-v)
  # but we still want to use writeShellApplication on those platforms
  let
    shellcheckSupported = lib.meta.availableOn stdenv.buildPlatform shellcheck.compiler; # 🎖️🎖️🎖️
    shellcheckCommand = lib.optionalString shellcheckSupported ''
      # use shellcheck which does not include docs
      # pandoc takes long to build and documentation isn't needed for just running the cli
      ${lib.getExe (haskell.lib.compose.justStaticExecutables shellcheck.unwrapped)} "$target"
    '';
  in
  if checkPhase == null then ''                 # --- The checkPhase defined OUTSIDE this block
    runHook preCheck
    ${stdenv.shellDryRun} "$target"
    ${shellcheckCommand}
    runHook postCheck
  ''
  else checkPhase;
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

## Basics 🚶‍♂️🚶‍♂️🚶‍♂️
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

### Teach Like I Am 5: symlinkJoin
```nix
# ADDS symlinks of hello and stack to CURRENT build and prints "links added"
symlinkJoin {
  name = "myexample";
  paths = [ pkgs.hello pkgs.stack ];
  postBuild = "echo links added";
}
```

```sh
    This creates a DERIVATION with a DIRECTORY structure like the following: 🎖️🎖️🎖️

    /nix/store/sglsr5g079a5235hy29da3mq3hv8sjmm-myexample
    |-- bin
    |   |-- hello -> /nix/store/qy93dp4a3rqyn2mz63fbxjg228hffwyw-hello-2.10/bin/hello
    |   `-- stack -> /nix/store/6lzdpxshx78281vy056lbk553ijsdr44-stack-2.1.3.1/bin/stack
```

```yaml
- symlinkJoin creates a SINGLE DERIVATION
- That appears to contain BINaries, LIBraries, DOCumentation, etc
- From MULTIPLE INPUT DERIVATIONS
```

### Teach Like I Am 5: linkFarm
```yaml
- linkFarm is used to create a SIMPLE? derivation with SYMLINKS to OTHER DERIVATIONS
- A derivation created with linkFarm is OFTEN USED in CI 💡💡💡
- As a EASY way to BUILD MULTIPLE DERIVATIONS at ONCE 🍭🍭🍭
- Dont BOTHER about $out/bin or $out/share
- Notice the resulting PATHS:
  - DOES NOT deal in BINARIES
```

```sh
# Symlinks hello and stack paths in store to current
# $out/hello-test and $out/foobar.
linkFarm "myexample" [
  { name = "hello-test"; path = pkgs.hello; }
  { name = "foobar"; path = pkgs.stack; }
]

This creates a derivation with a directory structure like the following:

/nix/store/qc5728m4sa344mbks99r3q05mymwm4rw-myexample
|-- foobar -> /nix/store/6lzdpxshx78281vy056lbk553ijsdr44-stack-2.1.3.1
`-- hello-test -> /nix/store/qy93dp4a3rqyn2mz63fbxjg228hffwyw-hello-2.10
```

