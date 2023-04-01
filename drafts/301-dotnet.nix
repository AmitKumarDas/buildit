# refer: https://zimbatm.com/notes/nix-packaging-the-heretic-way

# Fill these arguments how you like
{ nixpkgs ? import <nixpkgs> { } # an instance of nixpkgs
, nix-filter # an instance of https://github.com/numtide/nix-filter
}:
let self = 
{
  # The .NET packages we want to use
  dotnet-sdk = nixpkgs.dotnetCorePackages.sdk_6_0;
  dotnet-runtime = nixpkgs.dotnetCorePackages.aspnetcore_6_0;

  # Fetch all the dependencies in one derivation with __noChroot = true
  nugetDeps = nixpkgs.stdenv.mkDerivation {
    name = "nuget-deps";

    # HACK: break the nix sandbox so we can fetch the dependencies. This
    # requires Nix to have `sandbox = relaxed` in its config.
    __noChroot = true;

    # Only rebuild if the project metadata has changed
    src = nix-filter {
      root = ./.;
      include = [
        (nix-filter.isDirectory)
        (nix-filter.matchExt "csproj")
        (nix-filter.matchExt "slnf")
        (nix-filter.matchExt "sln")
      ];
    };

    nativeBuildInputs = [
      nixpkgs.cacert
      self.dotnet-sdk
    ];

    # Avoid telemetry
    configurePhase = ''
      export DOTNET_NOLOGO=1
      export DOTNET_CLI_TELEMETRY_OPTOUT=1
    '';

    projectFile = "my-api.slnf";

    # Pull all the dependencies for the project
    buildPhase = ''
      for project in $projectFile; do
        dotnet restore "$project" \
          -p:ContinuousIntegrationBuild=true \
          -p:Deterministic=true \
          --packages "$out"
      done
    '';

    installPhase = ":";
  };

  # Build the project itself
  my-api = nixpkgs.buildDotnetModule {
    pname = "my-api";
    version = "0";

    src = nix-filter {
      root = ./.;
      exclude = [
        # Filter out C# build folders
        (nix-filter.matchName "bin")
        (nix-filter.matchName "logs")
        (nix-filter.matchName "obj")
        (nix-filter.matchName "pub")
        (nix-filter.matchName ".vs")
      ];
    };

    projectFile = "my-api.slnf";

    # Replace the `nugetDeps = ./deps.nix` with the derivation.
    # This is only possible for nixpkgs that contains this PR:
    # https://github.com/NixOS/nixpkgs/pull/178446
    nugetDeps = self.nugetDeps;

    dotnet-sdk = self.dotnet-sdk;
    dotnet-runtime = self.dotnet-runtime;

    executables = [
      "MyAPI"
    ];
  };
}
