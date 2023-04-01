# refer: https://zimbatm.com/notes/nix-packaging-the-heretic-way

# Fill these arguments how you like
{ nixpkgs ? import <nixpkgs> { }
, nix-filter # an instance of https://github.com/numtide/nix-filter
}:
let self = 
{
  # Pick the version of nodejs to use
  nodejs = nixpkgs.nodejs_18-x;

  # Build the node_modules separately, from package.json and package-lock.json.
  #
  # Use __noChroot = true trick to avoid having to re-compute the vendorSha256 every time.
  node_modules = nixpkgs.stdenv.mkDerivation {
    name = "node_modules";

    src = nix-filter {
      root = ./.;
      include = [
        ./package.json
        ./package-lock.json
      ];
    };

    # HACK: break the nix sandbox so we can fetch the dependencies. This
    # requires Nix to have `sandbox = relaxed` in its config.
    __noChroot = true;

    configurePhase = ''
      # NPM writes cache directories etc to $HOME.
      export HOME=$TMP
    '';

    buildInputs = [ self.nodejs ];

    # Pull all the dependencies
    buildPhase = ''
      ${self.nodejs}/bin/npm ci
    '';

    # NOTE[z]: The folder *must* be called "node_modules". Don't ask me why.
    #          That's why the content is not directly added to $out.
    installPhase = ''
      mkdir $out
      mv node_modules $out/node_modules
    '';
  };

  # And finally build the frontend in its own derivation
  my-frontend = nixpkgs.stdenv.mkDerivation {
    name = "my-frontend";
    # Use the current folder as the input, without node_modules
    src = nix-filter {
      root = ./.;
      exclude = [
        ./.next
        ./node_modules
      ];
    };

    nativeBuildInputs = [ self.nodejs ];

    buildPhase = "npm run build";

    configurePhase = ''
      # Get the node_modules from its own derivation
      ln -sf ${self.node_modules}/node_modules node_modules
      export HOME=$TMP
    '';

    # TODO: move to different derivation
    doCheck = true;
    checkPhase = ''
      npm run test
    '';

    # This is specific to nextjs. Typically you would copy ./dist to $out or
    # something like that.
    installPhase = ''
      # Use the standalone nextjs version
      mv .next/standalone $out

      # Copy non-generated static files
      cp -R public $out/public

      # Also copy generated static files
      mv .next/static $out/.next/static

      # Re-link the node_modules
      rm $out/node_modules
      mv node_modules $out/node_modules

      # Wrap the script
      cat <<ENTRYPOINT > $out/entrypoint
      #!${nixpkgs.stdenv.shell}
      exec "$(type -p node)" "$out/server.js" "$$@"
      ENTRYPOINT
      chmod +x $out/entrypoint
    '';
  };
}; in self
