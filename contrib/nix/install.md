- My System
```shell
uname -a
Darwin amitd2-a01.vmware.com 21.6.0 Darwin Kernel Version 21.6.0: Thu Sep 29 20:13:56 PDT 2022; root:xnu-8020.240.7~1/RELEASE_ARM64_T6000 arm64
```

##Install
- Single User Install
- refer - https://nixos.org/manual/nix/stable/installation/installing-binary.html
```shell
sh <(curl -L https://nixos.org/nix/install) --no-daemon

Error: --no-daemon installs are no-longer supported on Darwin/macOS!
```
- Multi User Install
- refer - https://nixos.org/manual/nix/stable/installation/installing-binary.html
- sh <(curl -L https://nixos.org/nix/install) --daemon
```shell
Welcome to the Multi-User Nix Installation

This installation tool will set up your computer with the Nix package
manager. This will happen in a few stages:

1. Make sure your computer doesn't already have Nix. If it does, I
   will show you instructions on how to clean up your old install.

2. Show you what I am going to install and where. Then I will ask
   if you are ready to continue.

3. Create the system users and groups that the Nix daemon uses to run
   builds.

4. Perform the basic installation of the Nix files daemon.

5. Configure your shell to import special Nix Profile files, so you
   can use Nix.

6. Start the Nix daemon.
```
```shell
I will:

 - make sure your computer doesn't already have Nix files
   (if it does, I will tell you how to clean them up.)
 - create local users (see the list above for the users I'll make)
 - create a local group (nixbld)
 - install Nix in to /nix
 - create a configuration file in /etc/nix
 - set up the "default profile" by creating some Nix-related files in
   /var/root
 - back up /etc/bashrc to /etc/bashrc.backup-before-nix
 - update /etc/bashrc to include some Nix configuration
 - back up /etc/zshrc to /etc/zshrc.backup-before-nix
 - update /etc/zshrc to include some Nix configuration
 - back up /etc/bash.bashrc to /etc/bash.bashrc.backup-before-nix
 - update /etc/bash.bashrc to include some Nix configuration
 - create a Nix volume and a LaunchDaemon to mount it
 - create a LaunchDaemon (at /Library/LaunchDaemons/org.nixos.nix-daemon.plist) for nix-daemon
```
```shell
I am executing:

    $ sudo echo

to demonstrate how our sudo prompts look


This might look scary, but everything can be undone by running just a
few commands. I used to ask you to confirm each time sudo ran, but it
was too many times. Instead, I'll just ask you this one time:

Can I use sudo?
[y/n] y
```
```shell
Before I try to install, I'll check for signs Nix already is or has
been installed on this system.

---- Nix config report ---------------------------------------------------------
        Temp Dir:	/var/folders/8_/4tm010dx43b54nn8_0bn181w0000gn/T/tmp.zITn0Pef
        Nix Root:	/nix
     Build Users:	32
  Build Group ID:	30000
Build Group Name:	nixbld

build users:
    Username:	UID
     _nixbld1:	301
     _nixbld2:	302
     _nixbld3:	303
     _nixbld4:	304
     _nixbld5:	305
     _nixbld6:	306
     _nixbld7:	307
     _nixbld8:	308
     _nixbld9:	309
     _nixbld10:	310
     _nixbld11:	311
     _nixbld12:	312
     _nixbld13:	313
     _nixbld14:	314
     _nixbld15:	315
     _nixbld16:	316
     _nixbld17:	317
     _nixbld18:	318
     _nixbld19:	319
     _nixbld20:	320
     _nixbld21:	321
     _nixbld22:	322
     _nixbld23:	323
     _nixbld24:	324
     _nixbld25:	325
     _nixbld26:	326
     _nixbld27:	327
     _nixbld28:	328
     _nixbld29:	329
     _nixbld30:	330
     _nixbld31:	331
     _nixbld32:	332
```
```shell
---- Preparing a Nix volume ----------------------------------------------------
    Nix traditionally stores its data in the root directory /nix, but
    macOS now (starting in 10.15 Catalina) has a read-only root directory.
    To support Nix, I will create a volume and configure macOS to mount it
    at /nix.

~~> Configuring /etc/synthetic.conf to make a mount-point at /nix

---- sudo execution ------------------------------------------------------------
I am executing:

    $ sudo /usr/bin/ex -u NONE -n /etc/synthetic.conf

to add Nix to /etc/synthetic.conf
```
```shell
I am executing:

    $ sudo chmod -R ugo-w /nix/store/

to make the new store non-writable at /nix/store

      Alright! We have our first nix at /nix/store/dmk5m3nlqp1awaqrp1f06qhhkh3l102n-nix-2.11.1
```
```shell
I am executing:

    $ sudo /nix/store/dmk5m3nlqp1awaqrp1f06qhhkh3l102n-nix-2.11.1/bin/nix-store --load-db

to load data for the first time in to the Nix Database

warning: $HOME ('/Users/amitd2') is not owned by you, falling back to the one defined in the 'passwd' file ('/var/root')
      Just finished getting the nix database ready.

~~> Setting up shell profiles: /etc/bashrc /etc/profile.d/nix.sh /etc/zshrc /etc/bash.bashrc /etc/zsh/zshrc
```
```shell
I am executing:

    $ sudo cp /etc/bashrc /etc/bashrc.backup-before-nix

to back up your current /etc/bashrc to /etc/bashrc.backup-before-nix
```
```shell
I am executing:

    $ sudo tee -a /etc/bashrc

extend your /etc/bashrc with nix-daemon settings


# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix
```
```shell
I am executing:

    $ sudo cp /etc/zshrc /etc/zshrc.backup-before-nix

to back up your current /etc/zshrc to /etc/zshrc.backup-before-nix
```
```shell
I am executing:

    $ sudo tee -a /etc/zshrc

extend your /etc/zshrc with nix-daemon settings


# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix
```
```shell
I am executing:

    $ sudo cp /etc/bash.bashrc /etc/bash.bashrc.backup-before-nix

to back up your current /etc/bash.bashrc to /etc/bash.bashrc.backup-before-nix
```
```shell
I am executing:

    $ sudo tee -a /etc/bash.bashrc

extend your /etc/bash.bashrc with nix-daemon settings


# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix


~~> Setting up shell profiles for Fish with with conf.d/nix.fish inside /etc/fish /usr/local/etc/fish /opt/homebrew/etc/fish /opt/local/etc/fish

~~> Setting up the default profile
```
```shell
I am executing:

    $ sudo HOME=/var/root /nix/store/dmk5m3nlqp1awaqrp1f06qhhkh3l102n-nix-2.11.1/bin/nix-env -i /nix/store/dmk5m3nlqp1awaqrp1f06qhhkh3l102n-nix-2.11.1

to install a bootstrapping Nix in to the default profile

installing 'nix-2.11.1'
building '/nix/store/m2qh5gz2m9y8wjyag4i05gkhj5cy1shl-user-environment.drv'...
```
```shell
I am executing:

    $ sudo HOME=/var/root /nix/store/dmk5m3nlqp1awaqrp1f06qhhkh3l102n-nix-2.11.1/bin/nix-env -i /nix/store/2im4pw4pl5zsr6mjhwrjfcinrl9qljhy-nss-cacert-3.80

to install a bootstrapping SSL certificate just for Nix in to the default profile

installing 'nss-cacert-3.80'
building '/nix/store/myi6mchb69125y3vrs5s5paawswkqwlp-user-environment.drv'...
```
```shell
I am executing:

    $ sudo HOME=/var/root NIX_SSL_CERT_FILE=/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt /nix/store/dmk5m3nlqp1awaqrp1f06qhhkh3l102n-nix-2.11.1/bin/nix-channel --update nixpkgs

to update the default channel in the default profile
```
```shell
I am executing:

    $ sudo install -m 0664 /var/folders/8_/4tm010dx43b54nn8_0bn181w0000gn/T/tmp.zITn0Pef/nix.conf /etc/nix/nix.conf

to place the default nix daemon configuration (part 2)
```
```shell
I am executing:

    $ sudo /bin/cp -f /nix/var/nix/profiles/default/Library/LaunchDaemons/org.nixos.nix-daemon.plist /Library/LaunchDaemons/org.nixos.nix-daemon.plist

to set up the nix-daemon as a LaunchDaemon
```
```shell
I am executing:

    $ sudo launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist

to load the LaunchDaemon plist for nix-daemon
```
```shell
I am executing:

    $ sudo launchctl kickstart -k system/org.nixos.nix-daemon

to start the nix-daemon
```

## Usage
- Try it! Open a new terminal, and type:
```shell
$ nix-shell -p nix-info --run "nix-info -m"

...
- system: `"aarch64-darwin"`
 - host os: `Darwin 21.6.0, macOS 12.6.1`
 - multi-user?: `yes`
 - sandbox: `no`
 - version: `nix-env (Nix) 2.11.1`
 - channels(root): `"nixpkgs"`
 - nixpkgs: `/nix/var/nix/profiles/per-user/root/channels/nixpkgs`
```

## UnInstall
- https://nixos.org/manual/nix/stable/installation/installing-binary.html#uninstalling
