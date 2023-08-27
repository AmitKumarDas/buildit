# refer: https://scrive.github.io/nix-workshop/04-derivations/05-standard-derivation.html
# run: cat $(nix-build /nix/store/5rgcvwndbc4525ypbb0r1vgqpbxgcy2g-env.drv)

nix-repl> nixpkgs.stdenv.mkDerivation {
            name = "env";
            unpackPhase = "true";
            installPhase = "env > $out";
          }
«derivation /nix/store/5rgcvwndbc4525ypbb0r1vgqpbxgcy2g-env.drv»
