# REFER:
# - https://johns.codes/blog/rust-enviorment-and-docker-build-with-nix-flakes
# - https://github.com/numtide/flake-utils

# USAGE:
# - nix build .#hello # triggers the first line of outputs
# - nix build # triggers the defaultPackage line
{
  description = "A very basic flake";

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
    packages.x86_64-linux.default = self.packages.x86_64-linux.hello;
  };
}
