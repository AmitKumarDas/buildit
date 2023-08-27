# refer: https://jade.fyi/blog/optimizing-nix-docker/

{ }:
  let inherit (import ./default.nix {}) app nixpkgs;

      dockerEntrypoint = nixpkgs.writeScriptBin "entrypoint.sh" ''
        #!${nixpkgs.runtimeShell}
        exec ${app.out}/bin/myapp
      '';
  in nixpkgs.dockerTools.buildImage {
    name = "MyServer";
    tag = "latest";

    # everything in this is *copied* to the root of the image
    contents = [
      dockerEntrypoint
      nixpkgs.coreutils
      nixpkgs.runtimeShellPackage
    ];

    # run unprivileged with the current directory as the root of the image
    extraCommands = ''
      #!${nixpkgs.runtimeShell}
      mkdir -p data
    '';

    # Docker settings
    config = {
      Cmd = [ "entrypoint.sh" ];
      WorkingDir = "/data";
      ExposedPorts = {
        "3000" = {};
      };
      Volumes = {
        "/data" = {};
      };
    }
  }
