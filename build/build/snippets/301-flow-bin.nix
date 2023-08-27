# refer: https://zimbatm.com/notes/nix-packaging-the-heretic-way
# notes: 
# - generally applicable and should work for other languages as well
# - it’s less reproducible
# - anything changes in the build script, there are no incremental build layers like in Docker

You could split the build into different phases though, and that’s what we’ll be seeing next.

{ nixpkgs ? import <nixpkgs> { } }:
let
  version = "0.105.1";
in
nixpkgs.runCommand "flow-bin-${version}"
{
  # Disable the Nix build sandbox for this specific build.
  # This means the build can freely talk to the Internet.
  __noChroot = true;

  # Add all the build time dependencies
  nativeBuildInputs = [
    # Automatically patchelf all installed binaries
    nixpkgs.autoPatchelfHook
  ];

  # Add all the runtime dependencies
  buildInputs = [
    nixpkgs.nodejs
  ];
}
	# This part is a bit like a Dockerfile, without the apt-get installs.
  ''
    # Nix sets the HOME to something that doesn't exist by default.
	  # npm needs a user HOME.
    export HOME=$(mktemp -d)

    # Install the package directly from the Internet
    npm install flow-bin@${version}

    # Fix all the shebang scripts in the node_modules folder.
    patchShebangs .

    # Copy the node_modules and friends
    mkdir -p $out/share
    cp -r . $out/share/$name

    # Add a symlink to the binary
    mkdir $out/bin
    ln -s $out/share/$name/node_modules/.bin/flow $out/bin/flow
  ''
  
