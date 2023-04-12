
#### 🍭 Motivation
- Building Container Images Should Be Simple
- Nix (/ Guix) for Dependency Management
- Leverage Nix Community to Fix CVEs

#### 🏎️ Start with a Nix file (default.nix)
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

#### 🥸 Learn Nix By Introspecting
```json
nix build -f default.nix --print-out-paths
```
```
/nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env
```

##### 🏋️‍♀️ Size of the Built Environment
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

##### 🏋️‍♀️ Size of the Dependencies
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
/nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env               	  53.2M 👈 🧐
```

##### 😍 Tracing the Dependency
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

#### 💃 🕺 Marrying Nix with Dockerfile
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

#### 🚗 Search for the Fix / Strength of Community
```json
https://github.com/30block/sweet-home/commit/5e4ab948f43acd69c94af5c5676f983ca991683d
```

#### ✅ Apply the Fix 🙌
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
...
Linking /dist/run/profile to /nix/store/y9wc4ag3qykd5i4v0rf7m19hwayhc0vw-user-environment
Linking from /dist/etc to /nix/store/y9wc4ag3qykd5i4v0rf7m19hwayhc0vw-user-environment/etc
Copying all the profiles Nix dependencies to /dist
Finished Nix profile export to /dist
...
```

```sh
docker images
REPOSITORY                 TAG        IMAGE ID       CREATED          SIZE
tryme                      latest     574751459789   16 minutes ago   55.5MB
```

#### 📦 Whats in the Image?
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

```sh
Step 4/8 : RUN   du -hacL /dist
 ---> Running in 3540bdeccf00
192K	/dist/run/profile/bin/curl
196K	/dist/run/profile/bin
56K	/dist/run/profile/share/man/man1/curl.1.gz
4.0K	/dist/run/profile/share/man/man1/curl-config.1.gz
64K	/dist/run/profile/share/man/man1
68K	/dist/run/profile/share/man
72K	/dist/run/profile/share
4.0K	/dist/run/profile/manifest.nix
476K	/dist/run/profile/etc/ssl/certs/ca-bundle.crt
480K	/dist/run/profile/etc/ssl/certs
484K	/dist/run/profile/etc/ssl
488K	/dist/run/profile/etc
764K	/dist/run/profile
768K	/dist/run

...
# lots of /dist/nix/store/
4.0K	/dist/nix/store/y9wc4ag3qykd5i4v0rf7m19hwayhc0vw-user-environment
# lots of /dist/nix/store/
...

56M	/dist/nix/store
56M	/dist/nix
4.0K	/dist/etc/ssl/certs
8.0K	/dist/etc/ssl
12K	/dist/etc
57M	/dist
57M	total
```

#### 🧰 Whats inside /dist (which is inside image)?
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

#### 🕵️‍♀️ SBOM & CVEs 😍
##### 🏃‍♀️ Runtime
```json
nix run github:tiiuae/sbomnix#sbomnix -- result
```

```json
curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b .
```

```sh
./grype sbom.cdx.json
 ✔ Vulnerability DB        [updated]
 ✔ Scanning image...       [12 vulnerabilities]
   ├── 0 critical, 8 high, 4 medium, 0 low, 0 negligible
   └── 0 fixed
NAME     INSTALLED  FIXED-IN  TYPE            VULNERABILITY  SEVERITY 
openssl  3.0.7                UnknownPackage  CVE-2022-3996  High      
openssl  3.0.7                UnknownPackage  CVE-2022-4203  Medium    
openssl  3.0.7                UnknownPackage  CVE-2022-4304  Medium    
openssl  3.0.7                UnknownPackage  CVE-2022-4450  High      
openssl  3.0.7                UnknownPackage  CVE-2023-0215  High      
openssl  3.0.7                UnknownPackage  CVE-2023-0216  High      
openssl  3.0.7                UnknownPackage  CVE-2023-0217  High      
openssl  3.0.7                UnknownPackage  CVE-2023-0286  High      
openssl  3.0.7                UnknownPackage  CVE-2023-0401  High      
openssl  3.0.7                UnknownPackage  CVE-2023-0464  High      
openssl  3.0.7                UnknownPackage  CVE-2023-0465  Medium    
openssl  3.0.7                UnknownPackage  CVE-2023-0466  Medium
```

```json
nix run github:tiiuae/sbomnix#vulnxscan -- ./result
```

```sh
nix run github:tiiuae/sbomnix#vulnxscan -- ./result
INFO     Generating SBOM for target '/nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env'
INFO     Loading runtime dependencies referenced by '/nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env'
INFO     Using SBOM '/tmp/vulnxscan_7_zyoxrx.json'
INFO     Running vulnix scan
INFO     Running grype scan
INFO     Running OSV scan
INFO     Querying vulnerabilities
INFO     Console report

Potential vulnerabilities impacting 'result' or some of its runtime dependencies:

| vuln_id        | url                                             | package   | version   |  grype  |  osv  |  vulnix  |  sum  |
|----------------+-------------------------------------------------+-----------+-----------+---------+-------+----------+-------|
| CVE-2023-27534 | https://nvd.nist.gov/vuln/detail/CVE-2023-27534 | curl      | 7.87.0    |    0    |   0   |    1     |   1   |
| CVE-2023-27533 | https://nvd.nist.gov/vuln/detail/CVE-2023-27533 | curl      | 7.87.0    |    0    |   0   |    1     |   1   |
| CVE-2023-23916 | https://nvd.nist.gov/vuln/detail/CVE-2023-23916 | curl      | 7.87.0    |    0    |   0   |    1     |   1   |
| CVE-2023-23915 | https://nvd.nist.gov/vuln/detail/CVE-2023-23915 | curl      | 7.87.0    |    0    |   0   |    1     |   1   |
| CVE-2023-23914 | https://nvd.nist.gov/vuln/detail/CVE-2023-23914 | curl      | 7.87.0    |    0    |   0   |    1     |   1   |
| CVE-2023-0466  | https://nvd.nist.gov/vuln/detail/CVE-2023-0466  | openssl   | 3.0.7     |    1    |   0   |    1     |   2   |
| CVE-2023-0465  | https://nvd.nist.gov/vuln/detail/CVE-2023-0465  | openssl   | 3.0.7     |    1    |   0   |    1     |   2   |
| CVE-2023-0464  | https://nvd.nist.gov/vuln/detail/CVE-2023-0464  | openssl   | 3.0.7     |    1    |   0   |    1     |   2   |
| CVE-2023-0401  | https://nvd.nist.gov/vuln/detail/CVE-2023-0401  | openssl   | 3.0.7     |    1    |   0   |    1     |   2   |
| CVE-2023-0286  | https://nvd.nist.gov/vuln/detail/CVE-2023-0286  | openssl   | 3.0.7     |    1    |   0   |    1     |   2   |
| CVE-2023-0217  | https://nvd.nist.gov/vuln/detail/CVE-2023-0217  | openssl   | 3.0.7     |    1    |   0   |    1     |   2   |
| CVE-2023-0216  | https://nvd.nist.gov/vuln/detail/CVE-2023-0216  | openssl   | 3.0.7     |    1    |   0   |    1     |   2   |
| CVE-2023-0215  | https://nvd.nist.gov/vuln/detail/CVE-2023-0215  | openssl   | 3.0.7     |    1    |   0   |    1     |   2   |
| CVE-2022-4450  | https://nvd.nist.gov/vuln/detail/CVE-2022-4450  | openssl   | 3.0.7     |    1    |   0   |    1     |   2   |
| CVE-2022-4304  | https://nvd.nist.gov/vuln/detail/CVE-2022-4304  | openssl   | 3.0.7     |    1    |   0   |    1     |   2   |
| CVE-2022-4203  | https://nvd.nist.gov/vuln/detail/CVE-2022-4203  | openssl   | 3.0.7     |    1    |   0   |    1     |   2   |
| CVE-2022-3996  | https://nvd.nist.gov/vuln/detail/CVE-2022-3996  | openssl   | 3.0.7     |    1    |   0   |    0     |   1   |

INFO     Wrote: vulns.csv
```

##### 🛠️ Buildtime
```json
nix run github:tiiuae/sbomnix#vulnxscan -- ./result --buildtime
```

```sh
INFO     Generating SBOM for target '/nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env'
INFO     Loading runtime dependencies referenced by '/nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env'
INFO     Loading buildtime dependencies referenced by '/nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env'
INFO     Using SBOM '/tmp/vulnxscan_6h43te5t.json'
INFO     Running vulnix scan
INFO     Running grype scan
INFO     Running OSV scan
INFO     Querying vulnerabilities
INFO     Console report

Potential vulnerabilities impacting 'result' or some of its runtime or buildtime dependencies:

| vuln_id             | url                                               | package    | version          |  grype  |  osv  |  vulnix  |  sum  |
|---------------------+---------------------------------------------------+------------+------------------+---------+-------+----------+-------|
| GHSA-w596-4wvx-j9j6 | https://osv.dev/GHSA-w596-4wvx-j9j6               | py         | 1.11.0           |    0    |   1   |    0     |   1   |
| CVE-2023-27534      | https://nvd.nist.gov/vuln/detail/CVE-2023-27534   | curl       | 7.87.0           |    0    |   0   |    1     |   1   |
| CVE-2023-27533      | https://nvd.nist.gov/vuln/detail/CVE-2023-27533   | curl       | 7.87.0           |    0    |   0   |    1     |   1   |
| CVE-2023-23916      | https://nvd.nist.gov/vuln/detail/CVE-2023-23916   | curl       | 7.87.0           |    0    |   0   |    1     |   1   |
| CVE-2023-23915      | https://nvd.nist.gov/vuln/detail/CVE-2023-23915   | curl       | 7.87.0           |    0    |   0   |    1     |   1   |
| CVE-2023-23914      | https://nvd.nist.gov/vuln/detail/CVE-2023-23914   | curl       | 7.87.0           |    0    |   0   |    1     |   1   |
| CVE-2023-0466       | https://nvd.nist.gov/vuln/detail/CVE-2023-0466    | openssl    | 3.0.7            |    1    |   0   |    1     |   2   |
| CVE-2023-0465       | https://nvd.nist.gov/vuln/detail/CVE-2023-0465    | openssl    | 3.0.7            |    1    |   0   |    1     |   2   |
| CVE-2023-0464       | https://nvd.nist.gov/vuln/detail/CVE-2023-0464    | openssl    | 3.0.7            |    1    |   0   |    1     |   2   |
| CVE-2023-0401       | https://nvd.nist.gov/vuln/detail/CVE-2023-0401    | openssl    | 3.0.7            |    1    |   0   |    1     |   2   |
| CVE-2023-0286       | https://nvd.nist.gov/vuln/detail/CVE-2023-0286    | openssl    | 3.0.7            |    1    |   0   |    1     |   2   |
| CVE-2023-0217       | https://nvd.nist.gov/vuln/detail/CVE-2023-0217    | openssl    | 3.0.7            |    1    |   0   |    1     |   2   |
| CVE-2023-0216       | https://nvd.nist.gov/vuln/detail/CVE-2023-0216    | openssl    | 3.0.7            |    1    |   0   |    1     |   2   |
| CVE-2023-0215       | https://nvd.nist.gov/vuln/detail/CVE-2023-0215    | openssl    | 3.0.7            |    1    |   0   |    1     |   2   |
| CVE-2022-42969      | https://nvd.nist.gov/vuln/detail/CVE-2022-42969   | py         | 1.11.0           |    1    |   0   |    0     |   1   |
| PYSEC-2022-42969    | https://osv.dev/PYSEC-2022-42969                  | py         | 1.11.0           |    0    |   1   |    0     |   1   |
| CVE-2022-40898      | https://nvd.nist.gov/vuln/detail/CVE-2022-40898   | wheel      | 0.37.1-source    |    0    |   0   |    1     |   1   |
| CVE-2022-38533      | https://nvd.nist.gov/vuln/detail/CVE-2022-38533   | binutils   | 2.39             |    1    |   1   |    1     |   3   |
| CVE-2022-28321      | https://nvd.nist.gov/vuln/detail/CVE-2022-28321   | linux-pam  | 1.5.2            |    0    |   0   |    1     |   1   |
| CVE-2022-4904       | https://nvd.nist.gov/vuln/detail/CVE-2022-4904    | c-ares     | 1.18.1           |    1    |   0   |    0     |   1   |
| CVE-2022-4450       | https://nvd.nist.gov/vuln/detail/CVE-2022-4450    | openssl    | 3.0.7            |    1    |   0   |    1     |   2   |
| CVE-2022-4304       | https://nvd.nist.gov/vuln/detail/CVE-2022-4304    | openssl    | 3.0.7            |    1    |   0   |    1     |   2   |
| CVE-2022-4285       | https://nvd.nist.gov/vuln/detail/CVE-2022-4285    | binutils   | 2.39             |    0    |   0   |    1     |   1   |
| CVE-2022-4203       | https://nvd.nist.gov/vuln/detail/CVE-2022-4203    | openssl    | 3.0.7            |    1    |   0   |    1     |   2   |
| CVE-2022-3996       | https://nvd.nist.gov/vuln/detail/CVE-2022-3996    | openssl    | 3.0.7            |    1    |   0   |    0     |   1   |
| CVE-2022-1304       | https://nvd.nist.gov/vuln/detail/CVE-2022-1304    | e2fsprogs  | 1.46.5           |    1    |   0   |    0     |   1   |
| OSV-2022-1193       | https://osv.dev/OSV-2022-1193                     | libarchive | 3.6.2            |    0    |   1   |    0     |   1   |
| CVE-2022-0530       | https://nvd.nist.gov/vuln/detail/CVE-2022-0530    | unzip      | 6.0              |    0    |   1   |    1     |   2   |
| CVE-2022-0529       | https://nvd.nist.gov/vuln/detail/CVE-2022-0529    | unzip      | 6.0              |    0    |   1   |    1     |   2   |
| CVE-2021-35331      | https://nvd.nist.gov/vuln/detail/CVE-2021-35331   | tcl        | 8.6.11           |    1    |   0   |    1     |   2   |
| CVE-2021-4217       | https://nvd.nist.gov/vuln/detail/CVE-2021-4217    | unzip      | 6.0              |    0    |   1   |    1     |   2   |
| OSV-2021-777        | https://osv.dev/OSV-2021-777                      | libxml2    | 2.10.3           |    0    |   1   |    0     |   1   |
| CVE-2019-20633      | https://nvd.nist.gov/vuln/detail/CVE-2019-20633   | patch      | 2.7.6            |    1    |   0   |    1     |   2   |
| CVE-2019-14900      | https://nvd.nist.gov/vuln/detail/CVE-2019-14900   | fuse       | 3.11.0           |    0    |   0   |    1     |   1   |
| CVE-2019-14900      | https://nvd.nist.gov/vuln/detail/CVE-2019-14900   | fuse       | 2.9.9-closefrom- |    0    |   0   |    1     |   1   |
| CVE-2019-14900      | https://nvd.nist.gov/vuln/detail/CVE-2019-14900   | fuse       | 2.9.9            |    0    |   0   |    1     |   1   |
| CVE-2019-14860      | https://nvd.nist.gov/vuln/detail/CVE-2019-14860   | fuse       | 3.11.0           |    0    |   0   |    1     |   1   |
| CVE-2019-14860      | https://nvd.nist.gov/vuln/detail/CVE-2019-14860   | fuse       | 2.9.9-closefrom- |    0    |   0   |    1     |   1   |
| CVE-2019-14860      | https://nvd.nist.gov/vuln/detail/CVE-2019-14860   | fuse       | 2.9.9            |    0    |   0   |    1     |   1   |
| CVE-2019-13638      | https://nvd.nist.gov/vuln/detail/CVE-2019-13638   | patch      | 2.7.6            |    1    |   0   |    0     |   1   |
| CVE-2019-13636      | https://nvd.nist.gov/vuln/detail/CVE-2019-13636   | patch      | 2.7.6            |    1    |   0   |    0     |   1   |
| CVE-2019-6293       | https://nvd.nist.gov/vuln/detail/CVE-2019-6293    | flex       | 2.6.4            |    0    |   0   |    1     |   1   |
| CVE-2018-1000156    | https://nvd.nist.gov/vuln/detail/CVE-2018-1000156 | patch      | 2.7.6            |    1    |   0   |    0     |   1   |
| CVE-2018-1000097    | https://nvd.nist.gov/vuln/detail/CVE-2018-1000097 | sharutils  | 4.15.2           |    1    |   0   |    0     |   1   |
| CVE-2018-20969      | https://nvd.nist.gov/vuln/detail/CVE-2018-20969   | patch      | 2.7.6            |    1    |   0   |    0     |   1   |
| CVE-2018-6952       | https://nvd.nist.gov/vuln/detail/CVE-2018-6952    | patch      | 2.7.6            |    1    |   0   |    0     |   1   |
| CVE-2018-6951       | https://nvd.nist.gov/vuln/detail/CVE-2018-6951    | patch      | 2.7.6            |    1    |   0   |    0     |   1   |
| CVE-2016-2781       | https://nvd.nist.gov/vuln/detail/CVE-2016-2781    | coreutils  | 9.1              |    1    |   0   |    0     |   1   |

INFO     Wrote: vulns.csv
```

#### Fix the CVEs by Bumping The Distribution 🙏
```json
nix-env -qP --available openssl
```
```sh
nixpkgs.openssl_1_1     openssl-1.1.1s
nixpkgs.openssl         openssl-3.0.7
nixpkgs.openssl_3_0     openssl-3.0.7
nixpkgs.openssl_legacy  openssl-3.0.7
```

##### 😻 OpenSSL Fix is Available 
```json
https://github.com/NixOS/nixpkgs/commit/15cf84feea87949eb01b9b6e631246fe6991cd3a
```

```json
https://github.com/NixOS/nix/tags
```

##### Thank You
```yaml
- https://github.com/teamniteo/nix-docker-base
- 🔥 🧨 https://github.com/teamniteo/nix-docker-base/blob/master/scripts/export-profile
- 💎 https://github.com/teamniteo/nix-docker-base/tree/master/static-root-files/etc
```

##### Extras

```yaml
- . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh # source the profile
```

```yaml
- In order to construct a coherent user or system environment
- Nix symlinks entries of the Nix store into profiles
- These are the front-end by which Nix allows rollbacks
  - Since the store is immutable and previous versions of profiles are kept
  - Reverting to an earlier state is simply a matter of change the symlink to a previous profile
- To be more precise, Nix symlinks binaries into entries of the Nix store representing the user environments
- These user environments are then symlinked 
  - Into labeled profiles stored in /nix/var/nix/profiles 🔥
  - Which are in turn symlinked to the user's ~/.nix-profile 🔥
```
