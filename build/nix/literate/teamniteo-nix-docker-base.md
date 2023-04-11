
#### Motivation
- Building Container Images Should Be Simple
- Looks Similar to the Packaging Work of Distros
- Nix / Guix vs. Dockerfile & Traditional Distros

#### Start with a Nix file (default.nix)
```nix
let
  pkgs = import <nixpkgs> {};
in {
  myEnv = pkgs.buildEnv {
    name = "env";
    paths = with pkgs; [
      curl
      cacert
    ];
  };
}
```

```json
nix build -f default.nix
```

#### Learn Nix By Introspecting
```json
nix build -f default.nix --print-out-paths
```

```
/nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env
```

```json
nix path-info /nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env -rSh
```
```
/nix/store/y78s8i569g5w04pnili1z7bkg73gqgbl-libunistring-1.0  	   1.7M
/nix/store/s99my0m4dcxi75m03m4qdr0hvlip3590-libidn2-2.3.2     	   2.0M
/nix/store/yzjgl0h6a3qh1mby405428f16xww37h0-glibc-2.35-224    	  30.8M
/nix/store/04c0b1rmi9r6k9sl69a4gw3mhp3b5q2n-zlib-1.2.13       	  31.0M
/nix/store/a5y81wgjr79zylwr4cg85a8axgg1x56a-keyutils-1.6.3-lib	  30.9M
/nix/store/pj1hnyxhcsw1krmhnbb9rjvqssbzliw8-bash-5.2-p15      	  32.4M
/nix/store/5x3yh3mn6lqhjshbn7l5rjj8kcavk0qw-libkrb5-1.20.1    	  34.7M
/nix/store/773pradjpvxgxgs0mcklisx8ly6k1r4f-openssl-3.0.7     	  37.0M
/nix/store/bwdrs69xi81q1b445j1jm0ncwyxabi21-nghttp2-1.51.0-lib	  31.1M
/nix/store/nf1xgi7gyxww3bbw83svpankvl3y5hbh-libssh2-1.10.0    	  37.4M
/nix/store/sq78g74zs4sj7n1j5709g9c2pmffx1y8-gcc-11.3.0-lib    	  38.3M
/nix/store/q22rqwl4z3dl06nb8rrki7j6zmpq0040-zstd-1.5.2        	  39.4M
/nix/store/xkz1bbszzvlz832rjsyzs24ir91rppiz-brotli-1.0.9-lib  	  32.6M
/nix/store/24aw9ykmz7hgkwvwf3fq2bv2ilivsm8c-curl-7.87.0       	  52.5M
/nix/store/22jzbbwy648x7r9hil77j478fkq9jggs-curl-7.87.0-bin   	  52.7M
/nix/store/ciyjhvyfmn6djqkmhiclj258wlffz55y-nss-cacert-3.86   	 475.7K
/nix/store/cpp401nyj579zd7cpp5l5fs0c25r134g-curl-7.87.0-man   	  59.6K
/nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env               	  53.2M
```

```sh
nix why-depends /nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env/ /nix/store/sq78g74zs4sj7n1j5709g9c2pmffx1y8-gcc-11.3.0-lib
/nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env
└───/nix/store/22jzbbwy648x7r9hil77j478fkq9jggs-curl-7.87.0-bin
    └───/nix/store/24aw9ykmz7hgkwvwf3fq2bv2ilivsm8c-curl-7.87.0
        └───/nix/store/q22rqwl4z3dl06nb8rrki7j6zmpq0040-zstd-1.5.2
            └───/nix/store/sq78g74zs4sj7n1j5709g9c2pmffx1y8-gcc-11.3.0-lib
```

```sh
nix why-depends /nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env/ /nix/store/cpp401nyj579zd7cpp5l5fs0c25r134g-curl-7.87.0-man
/nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env
└───/nix/store/cpp401nyj579zd7cpp5l5fs0c25r134g-curl-7.87.0-man
```

```sh
du -hacL /nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env/
192K	/nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env/bin/curl
196K	/nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env/bin
60K	/nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env/share/man/man1/curl.1.gz
4.0K	/nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env/share/man/man1/curl-config.1.gz
68K	/nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env/share/man/man1
72K	/nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env/share/man
76K	/nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env/share
476K	/nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env/etc/ssl/certs/ca-bundle.crt
480K	/nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env/etc/ssl/certs
484K	/nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env/etc/ssl
488K	/nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env/etc
764K	/nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env/
764K	total
```

#### Marrying Nix with Dockerfile
```Dockerfile
# refer: https://hub.docker.com/r/niteo/nixpkgs-nixos-22.11/tags
FROM niteo/nixpkgs-nixos-22.11:ea96b4af6148114421fda90df33cf236ff5ecf1d AS build

# Import the project source
COPY default.nix default.nix

RUN \
  # Install the program to propagate to the final image
  nix-env -f default.nix -iA myEnv --show-trace \
  # Exports a root directory structure containing all dependencies
  # installed with nix-env under /run/profile
  && export-profile /dist

# Second Docker stage, we start with a completely empty image
FROM scratch

# Copy the /dist root folder from the previous stage into this one
COPY --from=build /dist /

# Set PATH so Nix binaries can be found
ENV PATH=/run/profile/bin
ENV NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt
```

```json
docker build . -t tryme
```

```sh
 => ERROR [build 3/3] RUN   nix-env -f default.nix -iA myEnv --show-trace   && export-profile /dist                          13.1s
------                                                                                                                             
 > [build 3/3] RUN   nix-env -f default.nix -iA myEnv --show-trace   && export-profile /dist:                                      
#7 0.804 installing 'env'                                                                                                          
#7 4.654 these 2 derivations will be built:                                                                                        
#7 4.656   /nix/store/imf2qzrzs0qggbabsn3f5mr3wa5jxhkh-builder.pl.drv                                                              
#7 4.656   /nix/store/k1rhrji3ha5zfhb15q21ki5fds9gr58h-env.drv                                                                     
#7 4.660 these 12 paths will be fetched (10.44 MiB download, 68.78 MiB unpacked):
#7 4.660   /nix/store/526xlkd8f2q5vbdy68rnv4x5d0wzml8w-diffutils-3.8
#7 4.660   /nix/store/576iqyz893c8zg0qy92is04cgcjanqky-file-5.43
#7 4.660   /nix/store/6s9h7vcjxhh76kaa6plickgik9c7rpqj-curl-7.86.0-man
#7 4.660   /nix/store/8dj94g330sk2q5kvji3jy0fpcj5m0kii-stdenv-linux
#7 4.660   /nix/store/8p49h8m12hx1qjxgw98vrx17a6hxcn2z-findutils-4.9.0
#7 4.660   /nix/store/gjyskq701gwzpin34r3rqlcaqif7v3l6-patch-2.7.6
#7 4.660   /nix/store/hnwgz78qripqnnnprar3lzmp7ymkv90x-gnumake-4.3
#7 4.660   /nix/store/hybxi0dm46sd8cf2xw6nhsdy858qlvyf-ed-1.18
#7 4.660   /nix/store/qbbh33w8jwr1pb6vxp2aplcsdlj6hvvk-patchelf-0.15.0
#7 4.661   /nix/store/qs14qs0x86ibndw0j5mwf1v46jxn56ld-gawk-5.1.1
#7 4.661   /nix/store/xdd67g9ps5aripg044v6y4j1qsli76fh-curl-7.86.0-bin
#7 4.661   /nix/store/yxd2rlvzh1n01j1f86zcxlj8xr20kwh5-perl-5.36.0
#7 4.728 copying path '/nix/store/6s9h7vcjxhh76kaa6plickgik9c7rpqj-curl-7.86.0-man' from 'https://cache.nixos.org'...
#7 4.899 copying path '/nix/store/xdd67g9ps5aripg044v6y4j1qsli76fh-curl-7.86.0-bin' from 'https://cache.nixos.org'...
#7 5.017 copying path '/nix/store/526xlkd8f2q5vbdy68rnv4x5d0wzml8w-diffutils-3.8' from 'https://cache.nixos.org'...
#7 5.283 copying path '/nix/store/hybxi0dm46sd8cf2xw6nhsdy858qlvyf-ed-1.18' from 'https://cache.nixos.org'...
#7 5.660 copying path '/nix/store/576iqyz893c8zg0qy92is04cgcjanqky-file-5.43' from 'https://cache.nixos.org'...
#7 6.300 copying path '/nix/store/8p49h8m12hx1qjxgw98vrx17a6hxcn2z-findutils-4.9.0' from 'https://cache.nixos.org'...
#7 6.567 copying path '/nix/store/qs14qs0x86ibndw0j5mwf1v46jxn56ld-gawk-5.1.1' from 'https://cache.nixos.org'...
#7 6.983 copying path '/nix/store/hnwgz78qripqnnnprar3lzmp7ymkv90x-gnumake-4.3' from 'https://cache.nixos.org'...
#7 7.213 copying path '/nix/store/gjyskq701gwzpin34r3rqlcaqif7v3l6-patch-2.7.6' from 'https://cache.nixos.org'...
#7 7.335 copying path '/nix/store/qbbh33w8jwr1pb6vxp2aplcsdlj6hvvk-patchelf-0.15.0' from 'https://cache.nixos.org'...
#7 7.487 copying path '/nix/store/yxd2rlvzh1n01j1f86zcxlj8xr20kwh5-perl-5.36.0' from 'https://cache.nixos.org'...
#7 12.83 copying path '/nix/store/8dj94g330sk2q5kvji3jy0fpcj5m0kii-stdenv-linux' from 'https://cache.nixos.org'...
#7 12.99 error: unable to load seccomp BPF program: Invalid argument
#7 12.99 
#7 12.99        … while setting up the build environment
------
executor failed running [/bin/sh -c nix-env -f default.nix -iA myEnv --show-trace   && export-profile /dist]: exit code: 1
```

#### Search for the Fix
```json
https://github.com/30block/sweet-home/commit/5e4ab948f43acd69c94af5c5676f983ca991683d
```

#### Apply the Fix
```Dockerfile
FROM niteo/nixpkgs-nixos-22.11:ea96b4af6148114421fda90df33cf236ff5ecf1d AS build

# Import the project source
COPY default.nix default.nix

RUN \
  # Install the program to propagate to the final image
  nix-env -f default.nix -iA myEnv --option filter-syscalls false \
  # Exports a root directory structure containing all dependencies
  # installed with nix-env under /run/profile
  && export-profile /dist

# Second Docker stage, we start with a completely empty image
FROM scratch

# Copy the /dist root folder from the previous stage into this one
COPY --from=build /dist /

# Set PATH so Nix binaries can be found
ENV PATH=/run/profile/bin
ENV NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt
```

```sh
docker images
REPOSITORY                 TAG        IMAGE ID       CREATED          SIZE
tryme                      latest     574751459789   16 minutes ago   55.5MB
```

#### Whats in the Image?
```Dockerfile
FROM niteo/nixpkgs-nixos-22.11:ea96b4af6148114421fda90df33cf236ff5ecf1d AS build

# Import the project source
COPY default.nix default.nix

RUN \
  # Install the program to propagate to the final image
  nix-env -f default.nix -iA myEnv \
  # Exports a root directory structure containing all dependencies
  # installed with nix-env under /run/profile
  && export-profile /dist


RUN \
  # 🔥 This will provide us the SIZE wrt each FILE & FOLDER inside /dist
  du -hacL /dist

# Second Docker stage, we start with a completely empty image
FROM scratch

# Copy the /dist root folder from the previous stage into this one
COPY --from=build /dist /

# Set PATH so Nix binaries can be found
ENV PATH=/run/profile/bin
ENV NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt
```

#### Whats inside /dist (which is inside image)?
```sh
Step 4/8 : RUN   ls -ltra /dist
 ---> Running in e4def598a0d6
total 20
drwxr-xr-x 3 root root 4096 Apr 11 11:55 run
drwxr-xr-x 3 root root 4096 Apr 11 11:55 nix
dr-xr-xr-x 3 root root 4096 Apr 11 11:55 etc
drwxr-xr-x 5 root root 4096 Apr 11 11:55 .
drwxr-xr-x 1 root root 4096 Apr 11 11:55 ..
```


##### Thank You
```yaml
- https://github.com/teamniteo/nix-docker-base
```
