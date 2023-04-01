# refer: https://elatov.github.io/2022/01/building-a-nix-package/
# run: nix-build default.nix
# run: nix-build -E 'with import <nixpkgs> {}; callPackage ./default.nix {}'
# run: nix show-derivation /nix/store/03y8h6wim78853illk0ylj5v0sy8r5fc-hello-2.10
# run: tree -L 2 /nix/store/03y8h6wim78853illk0ylj5v0sy8r5fc-hello-2.10
# 

{ lib
, stdenv
, fetchurl
, testVersion
, hello
}:

stdenv.mkDerivation rec {
  pname = "hello";
  version = "2.10";

  src = fetchurl {
    url = "mirror://gnu/hello/${pname}-${version}.tar.gz";
    sha256 = "0ssi1wpaf7plaswqqjwigppsg5fyh99vdlb9kzl7c9lng89ndq1i";
  };

  doCheck = true;

  passthru.tests.version =
    testVersion { package = hello; };

  meta = with lib; {
    description = "A program that produces a familiar, friendly greeting";
    longDescription = ''
      GNU Hello is a program that prints "Hello, world!" when you run it.
      It is fully customizable.
    '';
    homepage = "https://www.gnu.org/software/hello/manual/";
    changelog = "https://git.savannah.gnu.org/cgit/hello.git/plain/NEWS?h=v${version}";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.eelco ];
    platforms = platforms.all;
  };
}
