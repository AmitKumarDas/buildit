## Motivation
What's the quickest way to learn what versions are supported for a given pkg

## Is python available as a NixOs package?
```shell
nix-shell -p python-38
error: undefined variable 'python-38'

       at «string»:1:107:

            1| {...}@args: with import <nixpkgs> args; (pkgs.runCommandCC or pkgs.runCommand) "shell" { buildInputs = [ (python-38) ]; } ""
             |                                                                                                           ^
(use '--show-trace' to show detailed location information)
```

```shell
nix-repl 
zsh: command not found: nix-repl
```

```shell
nix repl '<nixpkgs>'
warning: future versions of Nix will require using `--file` to load a file
Welcome to Nix 2.11.1. Type :? for help.

Loading installable ''...
Added 17645 variables.
nix-repl> 
```

### TAB to the rescue
```shell
nix-repl> python<TAB>
```

```shell
:q
```

```shell
nix-shell -p python38
```

## Reference
- https://monospacedmonologues.com/2022/06/throwaway-development-environments-with-nix/
