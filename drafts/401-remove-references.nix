# refer: https://jade.fyi/blog/optimizing-nix-docker/

pkgs.stdenv.mkDerivation {
    # ...
    nativeBuildInputs = with pkgs; [ removeReferencesTo ];
    postInstall = with pkgs; ''
        remove-references-to -t ${badPkg1} -t ${badPkg2} $out/bin/your-program
    '';
}
