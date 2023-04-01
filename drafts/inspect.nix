nix-repl> nixpkgs.stdenv.mkDerivation {
            name = "inspect";
            unpackPhase = "true";

            buildPhase = ''
              set -x
              ls -la .
              ls -la /
              env
              set +x
            '';

            installPhase = "touch $out";
          }
«derivation /nix/store/vdyp9cxs0li87app03vm8zbxmq0lhw5l-inspect.drv»
