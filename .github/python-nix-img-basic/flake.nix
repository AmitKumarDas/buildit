{
  description = "A simple flake to build a container image to be used as the base image to ship python projects";
  inputs = {
    # Unstable channels (nixos-unstable, nixpkgs-unstable) correspond to the main development branch
    # (master) of Nixpkgs, delivering the latest tested updates on a rolling basis
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs }: rec {

    system = "x86_64-linux";

    # refer - https://zimbatm.com/notes/1000-instances-of-nixpkgs
    pkgs = nixpkgs.legacyPackages.${system};
    pythonEnv = pkgs.python;

    pythonImage = pkgs.dockerTools.buildImage {
        name = "python-nix";

        # Similar to ADD contents/ / in a Dockerfile
        # Copied to a new layer in the resulting image
        #
        # refer - https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/buildenv/default.nix
        copyToRoot = pkgs.buildEnv { # Creates a tree of symlinks to the specified path
          name = "py-env";
          paths = [ pythonEnv ]; # Packages
          pathsToLink = [ "/bin" ]; # Paths (relative to above paths element) to symlink
        };

        # Specify the configuration of this container that will be started off the built image
        config = {
          Cmd = [ "${pkgs.python}/bin/python" ];
        };
    };

    # We can use pythonEnv as a build result to introspect this result on host itself
    # Note that pythonEnv result is a symlink to python binary which gets built by Nix
    # Refer - ./../workflows/python-nix-img-basic.yaml
    packages.x86_64-linux.python-env = pythonEnv;
    packages.x86_64-linux.python-img = pythonImage;

    # Must provide attribute 'packages.x86_64-linux.default' or 'defaultPackage.x86_64-linux'
    packages.x86_64-linux.default = self.packages.x86_64-linux.python-img;
  };
}
