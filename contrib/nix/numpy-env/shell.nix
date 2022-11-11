{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  name = "my-numpy-env";

  buildInputs = [
    (pkgs.python3.withPackages (ps: [
      ps.numpy
    ]))
  ];
}