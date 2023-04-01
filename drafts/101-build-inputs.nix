# refer: https://scrive.github.io/nix-workshop/04-derivations/05-standard-derivation.html
# run: nix-build /nix/store/in40c5fl13ziqzds3wfg2ag7ax2xmq5l-greet-alice.drv
# run: cat /nix/store/kp32rzq63barqa55q3mf761gsggi2bq6-greet-alice
# run: nix show-derivation $drv
# run: cat /nix/store/9krlzvny65gdc8s7kpb6lkx8cd02c25b-default-builder.sh
# run: nix-shell $drv --run 'cat $stdenv/setup'

nix-repl> nixpkgs.stdenv.mkDerivation {
            name = "greet-alice";
            buildInputs = [ greet ];

            unpackPhase = "true";
            installPhase = "greet Alice > $out";
          }
«derivation /nix/store/in40c5fl13ziqzds3wfg2ag7ax2xmq5l-greet-alice.drv»
