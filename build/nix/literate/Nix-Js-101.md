#### Simple Yet Effective Derivation
```yaml
- shoutout: https://github.com/matejc/nix-helm/blob/master/src/utils.nix
- TIL: GitHub RAW, Single JS File, Need for UNPACK PHASE
- NOTE: Typical use of INSTALL PHASE
```
```nix
nix-beautify = stdenv.mkDerivation {
  name = "nix-beautify";
  src = fetchurl {
    url = "https://raw.githubusercontent.com/nixcloud/nix-beautify/5ea527d95aaae3a131882f9f5d5babfa28ddebd7/nix-beautify.js";
    sha256 = "05rmdql1vgn3ghx0mmh7v25s8c1rsd3541ipkn0ck1j282vzs9n2";
  };
  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out/bin
    echo "#!${nodejs}/bin/node" > $out/bin/nix-beautify
    cat $src >> $out/bin/nix-beautify
    chmod +x $out/bin/nix-beautify
  '';
};
```
