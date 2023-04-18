
### 🍭 Motivation
- Building Container Images Should Be Simple
- Nix for Automated Dependency Management
- Leverage Nix Community to Fix CVEs .. Fast

### 🏎️ We start by building a Nix Evironment
```diff
@@ with curl & ca certificates @@
```

```nix
# This is a Nix file named default.nix
let
  pkgs = import <nixpkgs> {};
in {
  myEnv = pkgs.buildEnv {
    name = "env";
    paths = with pkgs; [
      curl # 👈 either built from source or its prebuilt binary is fetched
      cacert # 👈 either built from source or its prebuilt binary is fetched
    ];
  };
}
```

```diff
+ nix build -f default.nix
```

### 🧐 What just happened?
```diff
! nix build -f default.nix --print-out-paths

# It oputputs the path of the environment that just got built
```
```
/nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env
```

### 🏋️‍♀️ Size of environment?
```diff
+ du -hacL /nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env/

! We find curl, ca-bundle, etc
```
```sh
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
764K	total 👈
```

### 🏋️‍♀️ Size of runtime dependencies?
```diff
+ nix path-info /nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env -rSh

@@ r -> recursive @@
@@ S -> Size of closure @@
@@ h -> Size in hunman readable format @@
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

```diff
! Hi.. I am from the future

@@ [Future]: Remember total size of runtime dependencies is 53.2M (look above) @@
```

### 🧨 Can we trace each dependency?
```diff
+ nix why-depends /nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env/ /nix/store/sq78g74zs4sj7n1j5709g9c2pmffx1y8-gcc-11.3.0-lib
```
```sh
/nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env
└───/nix/store/22jzbbwy648x7r9hil77j478fkq9jggs-curl-7.87.0-bin
    └───/nix/store/24aw9ykmz7hgkwvwf3fq2bv2ilivsm8c-curl-7.87.0
        └───/nix/store/q22rqwl4z3dl06nb8rrki7j6zmpq0040-zstd-1.5.2
            └───/nix/store/sq78g74zs4sj7n1j5709g9c2pmffx1y8-gcc-11.3.0-lib
```

```diff
+ nix why-depends /nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env/ /nix/store/cpp401nyj579zd7cpp5l5fs0c25r134g-curl-7.87.0-man
```
```sh
/nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env
└───/nix/store/cpp401nyj579zd7cpp5l5fs0c25r134g-curl-7.87.0-man
```

### 💃 🕺 Nix and Dockerfile
```diff
@@ Nix & Dockerfile for the greater good @@
```

```diff
! Hi.. I am from future

@@ [Future]: Remember below uses Nix 22.11 @@
```

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
  # Refer: https://github.com/teamniteo/nix-docker-base/blob/master/scripts/export-profile
  # Refer: Read extras section on this page
  # Note: Nix profile does the job of ldd & more
  && export-profile /dist

# Second Docker stage, we start with a completely empty image
FROM scratch

# Copy the /dist root folder from the previous stage into this one
COPY --from=build /dist /

# Set PATH so Nix binaries can be found
ENV PATH=/run/profile/bin
ENV NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt
```

```diff
+ docker build . -t tryme
```

```diff
- => ERROR [build 3/3] RUN   nix-env -f default.nix -iA myEnv --show-trace   && export-profile /dist                          13.1s
```
```sh
------                                                                                                                             
 > [build 3/3] RUN   nix-env -f default.nix -iA myEnv --show-trace   && export-profile /dist:                                      
#7 0.804 installing 'env'                                                                                                          
#7 4.654 these 2 derivations will be built:                                                                                        
#7 4.656   /nix/store/imf2qzrzs0qggbabsn3f5mr3wa5jxhkh-builder.pl.drv                                                              
#7 4.656   /nix/store/k1rhrji3ha5zfhb15q21ki5fds9gr58h-env.drv                                                                     
#7 4.660 these 12 paths will be fetched (10.44 MiB download, 68.78 MiB unpacked):
...
❌ #7 12.99 error: unable to load seccomp BPF program: Invalid argument ❌
#7 12.99 
#7 12.99        … while setting up the build environment
------
executor failed running [/bin/sh -c nix-env -f default.nix -iA myEnv --show-trace   && export-profile /dist]: exit code: 1
```

### 🚗 Search for the Fix
```diff
@@  Strength of Nix Community @@
```
```diff
! https://github.com/30block/sweet-home/commit/5e4ab948f43acd69c94af5c5676f983ca991683d
```

### ✅ Apply the Fix
```diff
@@ Fix is as simple as an additional option @@

! --option filter-syscalls false
```

```Dockerfile
FROM niteo/nixpkgs-nixos-22.11:ea96b4af6148114421fda90df33cf236ff5ecf1d AS build

# Import the project source
COPY default.nix default.nix

RUN \
  # Install the program to propagate to the final image
  # Fix is additional option as seen in 👇 line
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

```diff
+ docker build . -t tryme
```

```sh
...
Linking /dist/run/profile to /nix/store/y9wc4ag3qykd5i4v0rf7m19hwayhc0vw-user-environment
Linking from /dist/etc to /nix/store/y9wc4ag3qykd5i4v0rf7m19hwayhc0vw-user-environment/etc
Copying all the profiles Nix dependencies to /dist
Finished Nix profile export to /dist
...
```

```diff
+ docker images
```

```sh
REPOSITORY                 TAG        IMAGE ID       CREATED          SIZE
tryme                      latest     574751459789   16 minutes ago   55.5MB
```

```diff
@@ Nix knew above size ahead of time @@
```

### ✂️ Deconstruct Image Size
```diff
@@ Same as size of /dist @@

! du -hacL /dist
```

```Dockerfile
FROM niteo/nixpkgs-nixos-22.11:ea96b4af6148114421fda90df33cf236ff5ecf1d AS build

# same as original

RUN \
  # 🔥 This will provide us the SIZE wrt each FILE & FOLDER inside /dist
  du -hacL /dist

# Second Docker stage, we start with a completely empty image
FROM scratch

# same as original
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
57M	total 👈 🔥
```

### 🧰 Whats inside /dist?
```diff
@@  What is inside /dist thats formed in the image? @@

! ls -ltra /dist
```

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

### 🕵️‍♀️ Scan Nix Builds for CVEs via SBOM 😍
```diff
@@ Lets find CVEs due to RUNTIME dependencies @@

# Note: result is a symlink produced by Nix
# Note: nix build -f default.nix # produces result
```

```diff
# This gives us the SBOM
+ nix run github:tiiuae/sbomnix#sbomnix -- result
```

```diff
# This installs grype at current location
! curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b .
```

```diff
# This fetches CVEs from SBOM
+ ./grype sbom.cdx.json
```
```sh
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

```diff
@@ CVE Automation in Practice @@

! Generate SBOM & feed to scanners
! Get reports from multiple scanners
! None of these scanners need to be installed
! Note that sbomnix is not needed to be installed
! Each of these tools are management on the fly (by Nix)
! vulnix recognizes CVE patches if applied to Nix distribution
```

```diff
+ nix run github:tiiuae/sbomnix#vulnxscan -- ./result
```
```sh
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

```diff
@@ CVEs due to BUILDTIME dependencies @@

! This is easy in Nix (/ Guix)
! Since Nix knows the dependencies ahead of time (before build)
```

```diff
! nix run github:tiiuae/sbomnix#vulnxscan -- ./result --buildtime
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

### 🥤 How to fix the CVEs?
```diff
@@ Is it possible to fix CVEs by bumping Nix distribution? @@
```

```diff
@@ Available openssl packages in Nix 22.11 @@

+ nix-env -qP --available openssl
```
```sh
nixpkgs.openssl_1_1     openssl-1.1.1s
nixpkgs.openssl         openssl-3.0.7
nixpkgs.openssl_3_0     openssl-3.0.7
nixpkgs.openssl_legacy  openssl-3.0.7
```

### ❌ Approach 1: Use the OpenSSL Fix Available in Latest Nixpkgs

```diff
@@ Approach 1: Update Nix packages to unstable release @@

! This should hopefully include the OpenSSL fix
```

```diff
@@ References @@

# https://github.com/NixOS/nixpkgs/commit/15cf84feea87949eb01b9b6e631246fe6991cd3a # 👈 openssl: 3.0.7 -> 3.0.8
# https://github.com/nixos/nixpkgs/tree/nixos-unstable # 👈 unstable branch
# https://nix.dev/tutorials/towards-reproducibility-pinning-nixpkgs # 👍
# https://nixos.wiki/wiki/FAQ/Pinning_Nixpkgs

# This helps picking up a specific commit
! https://status.nixos.org/
```

```diff
@@ Approach 1: Step 1: Inspect the nixpkgs channel @@

# sudo nix-channel --list
! nixpkgs https://nixos.org/channels/nixpkgs-unstable
```

```diff
@@ Approach 1: Step 2: use niv for dependency management @@

# nix-shell -p niv --run "niv init"
# nix-shell -p niv
# niv show
```
```sh
nixpkgs
  branch: release-21.05
  description: Nix Packages collection
  homepage: 
  owner: NixOS
  repo: nixpkgs
  rev: 5f244caea76105b63d826911b2a1563d33ff1cdc
  sha256: 1xlgynfw9svy7nvh9nkxsxdzncv9hg99gbvbwv3gmrhmzc3sar75
  type: tarball
  url: https://github.com/NixOS/nixpkgs/archive/5f244caea76105b63d826911b2a1563d33ff1cdc.tar.gz
  url_template: https://github.com/<owner>/<repo>/archive/<rev>.tar.gz
```

```diff
@@ Approach 1: Step 3 @@

# niv update nixpkgs
# niv show
```
```sh
nixpkgs
  branch: release-21.05
  description: Nix Packages collection
  homepage: 
  owner: NixOS
  repo: nixpkgs
  rev: 022caabb5f2265ad4006c1fa5b1ebe69fb0c3faf
  sha256: 12q00nbd7fb812zchbcnmdg3pw45qhxm74hgpjmshc2dfmgkjh4n
  type: tarball
  url: https://github.com/NixOS/nixpkgs/archive/022caabb5f2265ad4006c1fa5b1ebe69fb0c3faf.tar.gz
  url_template: https://github.com/<owner>/<repo>/archive/<rev>.tar.gz
```

```diff
@@ Approach 1: Step 4 @@

# niv modify nixpkgs -a branch=nixpkgs-unstable
# niv show

# Following output shows that git details has not changed
# However, branch name has changed
```
```sh
nixpkgs
  branch: nixpkgs-unstable
  .. same as earlier ..
```

```diff
@@ Approach 1: Step 5: Do not forget to run update command for changes to take effect @@

! niv update nixpkgs
# niv show

@@ Hi.. I am from future @@
@@ [Future]: Have you verified the updated revision
- We are not sure if this nixpkgs revision from unstable branch has passed in its CI
```
```sh
nixpkgs
  branch: nixpkgs-unstable
  description: Nix Packages collection
  homepage: 
  owner: NixOS
  repo: nixpkgs
  rev: 639d4f17218568afd6494dbd807bebb2beb9d6b3
  sha256: 04lvyqiv58g6w65r8b4jyfja3qsh2ckkv54a21zlmi0k34qnhrm6
  type: tarball
  url: https://github.com/NixOS/nixpkgs/archive/639d4f17218568afd6494dbd807bebb2beb9d6b3.tar.gz
  url_template: https://github.com/<owner>/<repo>/archive/<rev>.tar.gz
```

```diff
@@ Approach 1: Step 6: Back to our original nix file & Dockerfile @@

# Refer: https://github.com/teamniteo/nix-docker-base
! Advised to update the Dockerfile FROM statement with the nixpkgs version used locally

# nix-shell -p niv
# niv update nixpkgs
# channel=$(jq -r .nixpkgs.branch nix/sources.json)
# rev=$(jq -r .nixpkgs.rev nix/sources.json)
# sed -i "s#FROM.*AS build#FROM niteo/nixpkgs-$channel:$rev AS build#g" Dockerfile
```

```sh
tree
.
├── Dockerfile
├── default.nix
└── nix
    ├── sources.json
    └── sources.nix

2 directories, 4 files
```

```nix
# This is a Nix file named default.nix
let
  # pkgs = import <nixpkgs> {}; # 👈 Original
  pkgs = (import nix/sources.nix).nixpkgs; # 🎉
in {
  myEnv = pkgs.buildEnv {
    name = "env";
    paths = with pkgs; [
      curl # 👈 either built from source or its prebuilt binary is fetched
      cacert # 👈 either built from source or its prebuilt binary is fetched
    ];
  };
}
```

```Dockerfile
# FROM niteo/nixpkgs-nixos-22.11:ea96b4af6148114421fda90df33cf236ff5ecf1d AS build # 👈 Original
FROM niteo/nixpkgs-nixpkgs-unstable:639d4f17218568afd6494dbd807bebb2beb9d6b3 AS build

# same as original
```

```diff
! docker build . -t tryme:latest-1

- ERROR [internal] load metadata for docker.io/niteo/nixpkgs-nixpkgs-unstable:639d4f17218568afd6494dbd807bebb2beb9d6b3      2.2s
- > [internal] load metadata for docker.io/niteo/nixpkgs-nixpkgs-unstable:639d4f17218568afd6494dbd807bebb2beb9d6b3:
- failed to solve with frontend dockerfile.v0: 
-  failed to create LLB definition: pull access denied, repository does not exist or may require authorization: 
-  server message: insufficient_scope: authorization failed
```

```diff
@@ Approach 1: Step 7: Most likely niteo does not have a base image with above combination @@

# We shall create a base image with above combination
# Follow the steps shown below:

@@ Approach 1: Steps 7.1: Work with nix-docker-base code base @@

# git clone git@github.com:teamniteo/nix-docker-base.git
# cd nix-docker-base
# nix-shell -p niv 
# niv show
# niv init # It asked to run 'niv init'
# git status
# niv show
# niv modify nixpkgs -a branch=nixpkgs-unstable
# niv update nixpkgs
# niv show
```

```diff
@@ Approach 1: Steps 7.2: Build the base image @@

! https://github.com/teamniteo/nix-docker-base/blob/master/.github/workflows/push.yml
# REGISTRY_USER=amitd nix-shell --run 'scripts/image-update test "$PWD" nixos-unstable  16'
```

```sh
Package ‘glibc-2.37-8’ in /nix/store/rxk626qrhsg0xlddbhb0vc05547vlyb3-nixpkgs-src/pkgs/development/libraries/glibc/default.nix:166 is not available on the requested hostPlatform:
         hostPlatform.config = "aarch64-apple-darwin"
         package.meta.platforms = [
           "aarch64-linux"
           "armv5tel-linux"
           "armv6l-linux"
           "armv7a-linux"
           "armv7l-linux"
           "i686-linux"
           "m68k-linux"
           "microblaze-linux"
           "microblazeel-linux"
           "mipsel-linux"
           "mips64el-linux"
           "powerpc64-linux"
           "powerpc64le-linux"
           "riscv32-linux"
           "riscv64-linux"
           "s390-linux"
           "s390x-linux"
           "x86_64-linux"
         ]
         package.meta.badPlatforms = [ ]
       , refusing to evaluate.
```

```diff
@@ Approach 1: Steps 7.3: @@

# I was running above on my Mac
# Let us redo the steps on a Linux machine

# git clone  https://github.com/teamniteo/nix-docker-base.git
# cd nix-docker-base
# nix-shell -p niv 
# niv init
# git status
# niv update nixpkgs
```
```diff
- FATAL: Cannot get latest revision for branch 'nixos-unstable' (NixOS/nixpkgs)
- The request failed: Response {responseStatus = Status {statusCode = 403, statusMessage = "rate limit exceeded"}
```

```diff
@@ Approach 1: Steps 7.4: Authenticate to do away with GH rate exceeded error @@

# Generate a Personal Account Token at GitHub from GitHub UI
# Save the token in mytoken.txt
# [optional] gh auth login --with-token < mytoken.txt
# GITHUB_TOKEN=$(cat mytoken.txt) niv update nixpkgs # 🔥
# niv show
```

```diff
@@ Approach 1: Steps 7.5: Try Again: Build the base image @@

# exit # exits nix shell
# REGISTRY_USER=amitd nix-shell --run 'scripts/image-update test "$PWD" nixos-unstable  16' # 🔥
! This might take time. No pre built binaries / caches for unstable release
```
```sh
Cooking the image...
Finished.
Image built successfully
Testing image..
Running tests for /nix/store/g38pgn5sjs9v80qkkzsrb5g6vr5d0c3k-docker-image-nixpkgs.tar.gz..
Loading built image into docker..
❌ open /nix/store/g38pgn5sjs9v80qkkzsrb5g6vr5d0c3k-docker-image-nixpkgs.tar.gz: no such file or directory
Failed to load the built image into docker
Image tests failed
```

```diff
@@ Approach 1: Steps 7.6: Wait! Above tar file is available @@

! ll /nix/store/g38pgn5sjs9v80qkkzsrb5g6vr5d0c3k-docker-image-nixpkgs.tar.gz
```
```sh
-r--r--r-- 1 root root 126629663 Jan  1  1970 /nix/store/g38pgn5sjs9v80qkkzsrb5g6vr5d0c3k-docker-image-nixpkgs.tar.gz
```

```diff
@@ Steps 7.7: Load the tar to docker @@

- Note: We will deal with above error later
! docker load < /nix/store/g38pgn5sjs9v80qkkzsrb5g6vr5d0c3k-docker-image-nixpkgs.tar.gz
# docker images # ✅
```
```
REPOSITORY                  TAG                                        IMAGE ID       CREATED         SIZE
nixpkgs                     g38pgn5sjs9v80qkkzsrb5g6vr5d0c3k           3ba87715ee0b   6 minutes ago   390MB
```

```diff
@@ Approach 1: Steps 7.7: Retry Step 6 @@

# Following is the Dockerfile with updated FROM statement
```
```Dockerfile
FROM nixpkgs:g38pgn5sjs9v80qkkzsrb5g6vr5d0c3k AS build

# Rest all remain same
```
```diff
- Step 3/7 : RUN   nix-env -f src -iA myEnv --option filter-syscalls false   && export-profile /dist
- ---> Running in 0fde15823a86
- error: attribute 'buildEnv' missing
-       at /root/src/default.nix:7:11:
-            6|   inherit pkgs;
-            7|   myEnv = pkgs.buildEnv {
-             |           ^
-            8|     name = "env";
```

```diff
@@ Approach 1: Steps 7.8: Fix niv imports @@
```
```nix
# This is a Nix file named default.nix
{ sources ? import nix/sources.nix }: # import
let
  # pkgs = import <nixpkgs> {}; # 👈 Original
  pkgs = import sources.nixpkgs { overlays = [] ; config = {}; }; # use
in {
  myEnv = pkgs.buildEnv {
    name = "env";
    paths = with pkgs; [
      curl # 👈 either built from source or its prebuilt binary is fetched
      cacert # 👈 either built from source or its prebuilt binary is fetched
    ];
  };
}
```
```diff
# docker build . -t tryme:2
```
```sh
docker images
REPOSITORY                  TAG                                        IMAGE ID       CREATED          SIZE
tryme                       2                                          d7b9cfbf3bb5   7 seconds ago    44.2MB
<none>                      <none>                                     f60e95b89486   10 seconds ago   666MB
<none>                      <none>                                     8cf30a1f122f   6 minutes ago    390MB
<none>                      <none>                                     c082bb8cf7f3   8 minutes ago    390MB
<none>                      <none>                                     77fb5c12ff25   9 minutes ago    390MB
<none>                      <none>                                     6fb26132c6ed   2 hours ago      390MB
<none>                      <none>                                     06167f3ef5b4   2 hours ago      390MB
<none>                      <none>                                     b1282b330c3c   2 hours ago      390MB
nixpkgs                     g38pgn5sjs9v80qkkzsrb5g6vr5d0c3k           3ba87715ee0b   3 hours ago      390MB
```

```diff
@@ Approach 1: Steps 7.9: Did it work? @@

# We shall build the result & run against scanners
# nix build -f default.nix
# nix run github:tiiuae/sbomnix#vulnxscan -- ./result
```
```sh
INFO     Generating SBOM for target '/nix/store/bi9p0hwyxqc8qwx2viscf9a5qf171iva-env'
INFO     Loading runtime dependencies referenced by '/nix/store/bi9p0hwyxqc8qwx2viscf9a5qf171iva-env'
INFO     Using SBOM '/tmp/vulnxscan_8zu1e2t_.json'
INFO     Running vulnix scan
INFO     Running grype scan
INFO     Running OSV scan
INFO     Querying vulnerabilities
INFO     Console report

Potential vulnerabilities impacting 'result' or some of its runtime dependencies:

| vuln_id        | url                                             | package   | version   |  grype  |  osv  |  vulnix  |  sum  |
|----------------+-------------------------------------------------+-----------+-----------+---------+-------+----------+-------|
| CVE-2023-27534 | https://nvd.nist.gov/vuln/detail/CVE-2023-27534 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2023-27533 | https://nvd.nist.gov/vuln/detail/CVE-2023-27533 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2023-23916 | https://nvd.nist.gov/vuln/detail/CVE-2023-23916 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2023-0466  | https://nvd.nist.gov/vuln/detail/CVE-2023-0466  | openssl   | 1.1.1k    |    1    |   0   |    1     |   2   |
| CVE-2023-0465  | https://nvd.nist.gov/vuln/detail/CVE-2023-0465  | openssl   | 1.1.1k    |    1    |   0   |    1     |   2   |
| CVE-2023-0464  | https://nvd.nist.gov/vuln/detail/CVE-2023-0464  | openssl   | 1.1.1k    |    1    |   0   |    1     |   2   |
| CVE-2023-0286  | https://nvd.nist.gov/vuln/detail/CVE-2023-0286  | openssl   | 1.1.1k    |    1    |   0   |    1     |   2   |
| CVE-2023-0215  | https://nvd.nist.gov/vuln/detail/CVE-2023-0215  | openssl   | 1.1.1k    |    1    |   0   |    1     |   2   |
| CVE-2022-43552 | https://nvd.nist.gov/vuln/detail/CVE-2022-43552 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2022-37434 | https://nvd.nist.gov/vuln/detail/CVE-2022-37434 | zlib      | 1.2.11    |    0    |   0   |    1     |   1   |
| CVE-2022-35252 | https://nvd.nist.gov/vuln/detail/CVE-2022-35252 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2022-32221 | https://nvd.nist.gov/vuln/detail/CVE-2022-32221 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2022-32208 | https://nvd.nist.gov/vuln/detail/CVE-2022-32208 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2022-32207 | https://nvd.nist.gov/vuln/detail/CVE-2022-32207 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2022-32206 | https://nvd.nist.gov/vuln/detail/CVE-2022-32206 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2022-32205 | https://nvd.nist.gov/vuln/detail/CVE-2022-32205 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2022-27782 | https://nvd.nist.gov/vuln/detail/CVE-2022-27782 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2022-27781 | https://nvd.nist.gov/vuln/detail/CVE-2022-27781 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2022-27776 | https://nvd.nist.gov/vuln/detail/CVE-2022-27776 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2022-27775 | https://nvd.nist.gov/vuln/detail/CVE-2022-27775 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2022-27774 | https://nvd.nist.gov/vuln/detail/CVE-2022-27774 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2022-23219 | https://nvd.nist.gov/vuln/detail/CVE-2022-23219 | glibc     | 2.32-46   |    0    |   0   |    1     |   1   |
| CVE-2022-23218 | https://nvd.nist.gov/vuln/detail/CVE-2022-23218 | glibc     | 2.32-46   |    0    |   0   |    1     |   1   |
| CVE-2022-22576 | https://nvd.nist.gov/vuln/detail/CVE-2022-22576 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2022-4450  | https://nvd.nist.gov/vuln/detail/CVE-2022-4450  | openssl   | 1.1.1k    |    1    |   0   |    1     |   2   |
| CVE-2022-4304  | https://nvd.nist.gov/vuln/detail/CVE-2022-4304  | openssl   | 1.1.1k    |    1    |   0   |    1     |   2   |
| CVE-2022-2097  | https://nvd.nist.gov/vuln/detail/CVE-2022-2097  | openssl   | 1.1.1k    |    1    |   0   |    1     |   2   |
| CVE-2022-2068  | https://nvd.nist.gov/vuln/detail/CVE-2022-2068  | openssl   | 1.1.1k    |    1    |   0   |    1     |   2   |
| CVE-2022-1292  | https://nvd.nist.gov/vuln/detail/CVE-2022-1292  | openssl   | 1.1.1k    |    1    |   0   |    1     |   2   |
| CVE-2022-0778  | https://nvd.nist.gov/vuln/detail/CVE-2022-0778  | openssl   | 1.1.1k    |    1    |   0   |    1     |   2   |
| CVE-2021-38604 | https://nvd.nist.gov/vuln/detail/CVE-2021-38604 | glibc     | 2.32-46   |    0    |   0   |    1     |   1   |
| CVE-2021-27645 | https://nvd.nist.gov/vuln/detail/CVE-2021-27645 | glibc     | 2.32-46   |    0    |   0   |    1     |   1   |
| CVE-2021-22947 | https://nvd.nist.gov/vuln/detail/CVE-2021-22947 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2021-22946 | https://nvd.nist.gov/vuln/detail/CVE-2021-22946 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2021-22926 | https://nvd.nist.gov/vuln/detail/CVE-2021-22926 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2021-22925 | https://nvd.nist.gov/vuln/detail/CVE-2021-22925 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2021-22924 | https://nvd.nist.gov/vuln/detail/CVE-2021-22924 | curl      | 7.76.1    |    0    |   1   |    0     |   1   |
| CVE-2021-22923 | https://nvd.nist.gov/vuln/detail/CVE-2021-22923 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2021-22922 | https://nvd.nist.gov/vuln/detail/CVE-2021-22922 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2021-22901 | https://nvd.nist.gov/vuln/detail/CVE-2021-22901 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2021-22898 | https://nvd.nist.gov/vuln/detail/CVE-2021-22898 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2021-22897 | https://nvd.nist.gov/vuln/detail/CVE-2021-22897 | curl      | 7.76.1    |    0    |   0   |    1     |   1   |
| CVE-2021-4160  | https://nvd.nist.gov/vuln/detail/CVE-2021-4160  | openssl   | 1.1.1k    |    1    |   0   |    1     |   2   |
| CVE-2021-3712  | https://nvd.nist.gov/vuln/detail/CVE-2021-3712  | openssl   | 1.1.1k    |    1    |   1   |    1     |   3   |
| CVE-2021-3711  | https://nvd.nist.gov/vuln/detail/CVE-2021-3711  | openssl   | 1.1.1k    |    1    |   1   |    1     |   3   |
| CVE-2019-18276 | https://nvd.nist.gov/vuln/detail/CVE-2019-18276 | bash      | 4.4-p23   |    0    |   0   |    1     |   1   |
| CVE-2019-17498 | https://nvd.nist.gov/vuln/detail/CVE-2019-17498 | libssh2   | 1.9.0     |    1    |   1   |    0     |   2   |
| CVE-2018-25032 | https://nvd.nist.gov/vuln/detail/CVE-2018-25032 | zlib      | 1.2.11    |    0    |   0   |    1     |   1   |
| CVE-2018-16395 | https://nvd.nist.gov/vuln/detail/CVE-2018-16395 | openssl   | 1.1.1k    |    0    |   0   |    1     |   1   |

INFO     Wrote: vulns.csv
```

```diff
@@ Approach 1: Steps 7.10: Lets Wrap: Above is something I dont understand @@

- WE SHALL CONTINUE WITH THIS APPROACH LATER ONCE I UNDERSTAND MORE ON NIX!
```

### ✅ Approach 2: Grab revision that has the OpenSSL Fix

```diff
# 🔥 🧨
! https://github.com/NixOS/nixpkgs/issues/9682#issuecomment-658424656
! https://lazamar.co.uk/nix-versions/?channel=nixpkgs-unstable&package=openssl
! https://github.com/NixOS/nixpkgs/commit/15cf84feea87949eb01b9b6e631246fe6991cd3a
```

```diff
@@ Approach 2: Steps 1: Update default.nix to fetch archive from a pinned revision @@
! Modifications is required at default.nix file
! We shall avoid niv for pinning
```

```nix
# This is a Nix file named default.nix
# run: nix build -f default.nix

# { sources ? import nix/sources.nix }: # with niv
let
  # pkgs = import <nixpkgs> {}; # original # without niv
  # pkgs = import sources.nixpkgs { overlays = [] ; config = {}; }; # with niv

  # refer: https://lazamar.co.uk/nix-versions/?channel=nixpkgs-unstable&package=openssl
  # for openssl version 3.0.8
  pkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/8ad5e8132c5dcf977e308e7bf5517cc6cc0bf7d8.tar.gz";
  }) {};
in {
  myEnv = pkgs.buildEnv {
    name = "env";
    paths = with pkgs; [
      curl # 👈 either built from source or its prebuilt binary is fetched
      cacert # 👈 either built from source or its prebuilt binary is fetched
    ];
  };
}
```

```diff
@@ Approach 2: Steps 2: Scan for CVEs using SBOM @@
! nix run github:tiiuae/sbomnix#vulnxscan -- ./result
```
```sh
INFO     Generating SBOM for target '/nix/store/lk0hgj7d9q0j401wsfahz6vh5zn1azqc-env'
INFO     Loading runtime dependencies referenced by '/nix/store/lk0hgj7d9q0j401wsfahz6vh5zn1azqc-env'
INFO     Using SBOM '/tmp/vulnxscan_7xu2hgyt.json'
INFO     Running vulnix scan
INFO     Running grype scan
INFO     Running OSV scan
INFO     Querying vulnerabilities
INFO     Console report

Potential vulnerabilities impacting 'result' or some of its runtime dependencies:

| vuln_id        | url                                             | package   | version   |  grype  |  osv  |  vulnix  |  sum  |
|----------------+-------------------------------------------------+-----------+-----------+---------+-------+----------+-------|
| CVE-2023-27534 | https://nvd.nist.gov/vuln/detail/CVE-2023-27534 | curl      | 7.88.0    |    0    |   0   |    1     |   1   |
| CVE-2023-27533 | https://nvd.nist.gov/vuln/detail/CVE-2023-27533 | curl      | 7.88.0    |    0    |   0   |    1     |   1   |
| CVE-2023-0466  | https://nvd.nist.gov/vuln/detail/CVE-2023-0466  | openssl   | 3.0.8     |    1    |   0   |    1     |   2   |
| CVE-2023-0465  | https://nvd.nist.gov/vuln/detail/CVE-2023-0465  | openssl   | 3.0.8     |    1    |   0   |    1     |   2   |
| CVE-2023-0464  | https://nvd.nist.gov/vuln/detail/CVE-2023-0464  | openssl   | 3.0.8     |    1    |   0   |    1     |   2   |

INFO     Wrote: vulns.csv
```
```diff
@@ Above indicates a substantial reduction in CVEs @@
@@ 😍 CVE count were reduced from 17 to 5 @@
# Above was possible since several runtime dependencies were updated due to use of a recent nixpkgs
```

### 🚧 Approach 3: Grab revision that has the latest curl

```diff
# 🔥 🧨
! https://github.com/NixOS/nixpkgs/issues/9682#issuecomment-658424656
! https://lazamar.co.uk/nix-versions/?channel=nixpkgs-unstable&package=curl
! https://github.com/NixOS/nixpkgs/commit/280f14490eeff5285e9f5e79b81869ce720546db
```
```diff
@@ Optional: You may try below shell envs before updating default.nix:
+ You can get into these shells & check the version & extra details w.r.t curl binary

# nix-shell -p curlWithGnuTls -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/8ad5e8132c5dcf977e308e7bf5517cc6cc0bf7d8.tar.gz
# nix-shell -p curlWithGnuTls -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/280f14490eeff5285e9f5e79b81869ce720546db.tar.gz
```

### Work In Progress

```diff
@@ Future: @@

@@ Support for rusttls as backend @@
+ Moving to a memory safe backend can reduce CVEs
+ This was introduced a couple of week back (Apr 2 2023)
- This does not have any prebuilt binaries. Hence this take HOURS to build

# References
! https://github.com/NixOS/nixpkgs/commit/74207b79f05fe0f067528c7fd3c7c8fd60128939
! nix-shell -p curlWithGnuTls -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/74207b79f05fe0f067528c7fd3c7c8fd60128939.tar.gz

@@ Others: @@
# Target different architectures
# Reduce image size by removing the man pages
# Reduce image size by removing the localization info
# Reduce image size by stripping the binaries
```

### Thank You
```yaml
- https://github.com/teamniteo/nix-docker-base
- 🔥 🧨 https://github.com/teamniteo/nix-docker-base/blob/master/scripts/export-profile
- 💎 https://github.com/teamniteo/nix-docker-base/tree/master/static-root-files/etc
```

### Extras

```diff
@@ If nix is forgotten by your terminal @@
! . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh # source the profile
```

```diff
@@ Nix Profile Long Story: @@
# Construct a COHERENT USER or SYSTEM environment
# Nix symlinks entries of the Nix store into profiles

# These are the front-end by which Nix allows rollbacks
# Since the store is immutable and previous versions of profiles are kept
# Reverting to an earlier state -> change the symlink to a previous profile
```

```diff
@@ Nix Profile Gist: @@
# Nix symlinks binaries into entries of the Nix store representing the user environments
# These user environments are then symlinked 
# 🔥 Into labeled profiles stored in /nix/var/nix/profiles
# 🔥 Which are in turn symlinked to the user's ~/.nix-profile
```

### Label
```diff
- display errors
+ type commands
! links or commands with more focus
# your comments
@@ your statement in purple (and bold)@@
```
