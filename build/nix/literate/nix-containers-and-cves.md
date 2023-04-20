
### 🍭 Motivation
- Building Container Images Should Be Simple
- Nix for Automated Dependency Management
- Leverage Nix Community to Fix CVEs .. Fast

### 🏎️ We start by building a Nix Evironment
```diff
@@ taking curl & ca certificates as an example @@
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
# Run following command to build the environment
+ nix build -f default.nix
```

### 🧐 What just happened?
```diff
# This oputputs the path of the environment that just got built
! nix build -f default.nix --print-out-paths
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
@@ Size of the environment @@
! nix path-info /nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env -Sh
/nix/store/f5r0g1mr62dk1k6gaj2dm9q1is42arak-env  53.2M
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
@@ Note: Below uses Nix 22.11 @@
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
```sh
------                                                                                                                             
 > [build 3/3] RUN   nix-env -f default.nix -iA myEnv --show-trace   && export-profile /dist:                                      
...
❌ #7 12.99 error: unable to load seccomp BPF program: Invalid argument ❌
------
executor failed running [/bin/sh -c nix-env -f default.nix -iA myEnv --show-trace   && export-profile /dist]: exit code: 1
```

### 🚗 Detour: Search for the Fix
```diff
@@ This turned to be a common issue @@ 
@@ Community has it solved @@
! https://github.com/30block/sweet-home/commit/5e4ab948f43acd69c94af5c5676f983ca991683d

@@ Fix was as simple as an additional option @@
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
+ docker images
```
```sh
REPOSITORY                 TAG        IMAGE ID       CREATED          SIZE
tryme                      latest     574751459789   16 minutes ago   55.5MB
```
```diff
@@ Note: Nix knew the container image size ahead of time @@
```

#### ✂️ Extras: Deconstruct Image Size
```diff
@@ Readers can skip this if they do not want to get into the size details @@
@@ Click 'Size Details' otherwise @@
```

<details>
  <summary>Size Details</summary>
  
```diff
@@ Size of image should ideally be same as size of /dist @@
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

```diff
@@  What folders get formed inside /dist (that gets formed in the image)? @@

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

</details>
  
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
# This outputs CVEs by parsing the SBOM
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
@@ 🔥 Let us take a Moment to Understand What Just Happened @@

# 1/ SBOM was generated on fly
# 2/ SBOM was fed to multiple scanners
# 3/ Each scanner reports the CVEs from the provided SBOM
# 4/ None of these scanners were installed
# 5/ The tool i.e. sbomnix which made this possible is not installed
# 6/ All of these are managed on the fly by Nix
# 7/ vulnix is a scanner capable of recognizing CVE patches that are applied to Nix packages
```

```diff
@@ Can we get a CVE report due to BUILDTIME dependencies? @@

# This is easy in Nix
# Since Nix knows the dependencies ahead of time

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

### 🥤 How to fix the CVEs esp. the ones due to runtime dependencies ?
```diff
@@ Is it possible to fix CVEs by bumping Nix distribution? @@
```

```diff
@@ Available openssl packages in Nix 22.11 i.e. stable release we have used so far @@

+ nix-env -qP --available openssl
```
```sh
nixpkgs.openssl_1_1     openssl-1.1.1s
nixpkgs.openssl         openssl-3.0.7
nixpkgs.openssl_3_0     openssl-3.0.7
nixpkgs.openssl_legacy  openssl-3.0.7
```

### ❌ Approach 1: Use the OpenSSL Fix Available in Latest Nixpkgs i.e. un-released

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

- WE SHALL CONTINUE WITH THIS APPROACH LATER ONCE I UNDERSTAND MORE ON NIX
! I SHOULD NOT HAVE INCLUDED NIV & DOCKERFILE AT SUCH AN EARLY STAGE
```

### ✅ Approach 2: Grab revision that has the OpenSSL Fix

```diff
@@ 🔥 🧨 References @@
! https://github.com/NixOS/nixpkgs/issues/9682#issuecomment-658424656
! https://lazamar.co.uk/nix-versions/?channel=nixpkgs-unstable&package=openssl
! https://github.com/NixOS/nixpkgs/commit/15cf84feea87949eb01b9b6e631246fe6991cd3a
```

```diff
@@ Approach 2: Steps 1: Update default.nix to fetch archive from a pinned revision @@
! Modifications is required at default.nix file
! Avoid niv for pinning
```

```nix
# This is a Nix file named default.nix
# run: nix build -f default.nix

let
  # refer: https://lazamar.co.uk/nix-versions/?channel=nixpkgs-unstable&package=openssl
  # for openssl version 3.0.8
  pkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/8ad5e8132c5dcf977e308e7bf5517cc6cc0bf7d8.tar.gz";
  }) {};
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

### ✅ Approach 3: Grab a nixpkgs revision that has the latest curl i.e. 8.0.1

```diff
@@ 🔥 🧨 References @@
! https://github.com/NixOS/nixpkgs/issues/9682#issuecomment-658424656
! https://lazamar.co.uk/nix-versions/?channel=nixpkgs-unstable&package=curl
! https://github.com/NixOS/nixpkgs/commit/280f14490eeff5285e9f5e79b81869ce720546db
```
```diff
@@ Optional: You may try below shell envs before updating default.nix @@
+ You can get into these shells & check curl version its backends

# nix-shell -p curlWithGnuTls -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/8ad5e8132c5dcf977e308e7bf5517cc6cc0bf7d8.tar.gz
# nix-shell -p curlWithGnuTls -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/280f14490eeff5285e9f5e79b81869ce720546db.tar.gz
```

```diff
@@ Approach 3: Steps 1: Update default.nix to fetch archive from a pinned revision @@
! Modifications is required at default.nix file
! Avoid using niv to pin nixpkgs
```

```nix
# This is a Nix file named default.nix
# run: nix build -f default.nix

let
  # refer: https://github.com/NixOS/nixpkgs/commit/280f14490eeff5285e9f5e79b81869ce720546db
  # for curl 8.0.1
  pkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/280f14490eeff5285e9f5e79b81869ce720546db.tar.gz";
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
@@ Approach 3: Steps 2: Scan for CVEs using SBOM @@
! nix run github:tiiuae/sbomnix#vulnxscan -- ./result
```
```sh
INFO     Generating SBOM for target '/nix/store/rybqmps78s85pbrjxxwsjqj9ri02r5p3-env'
INFO     Loading runtime dependencies referenced by '/nix/store/rybqmps78s85pbrjxxwsjqj9ri02r5p3-env'
INFO     Using SBOM '/tmp/vulnxscan_oiijrc17.json'
INFO     Running vulnix scan
INFO     Running grype scan
INFO     Running OSV scan
INFO     Querying vulnerabilities
INFO     Console report

Potential vulnerabilities impacting 'result' or some of its runtime dependencies:

| vuln_id       | url                                            | package   | version   |  grype  |  osv  |  vulnix  |  sum  |
|---------------+------------------------------------------------+-----------+-----------+---------+-------+----------+-------|
| CVE-2023-0466 | https://nvd.nist.gov/vuln/detail/CVE-2023-0466 | openssl   | 3.0.8     |    1    |   0   |    1     |   2   |
| CVE-2023-0465 | https://nvd.nist.gov/vuln/detail/CVE-2023-0465 | openssl   | 3.0.8     |    1    |   0   |    1     |   2   |
| CVE-2023-0464 | https://nvd.nist.gov/vuln/detail/CVE-2023-0464 | openssl   | 3.0.8     |    1    |   0   |    1     |   2   |

INFO     Wrote: vulns.csv
```

```diff
@@ Above indicates further reduction in CVEs @@
@@ 😍 CVE count were reduced from 5 to 3 @@
```

### ✅ Approach 4: Latest curl with rusttls as the backend

```diff
@@ Nix pkgs recently supported rusttls as backend for curl @@

+ Moving to a memory safe backend can reduce CVEs
+ This was introduced a couple of weeks back (Apr 2 2023)
```

```diff
@@ Approach 4: Steps 1: First experiment with the fresh commit @@
@@ Build curl with openssl at rev 74207b79f05fe0f067528c7fd3c7c8fd60128939 @@

- 🤬 This does not have any prebuilt binaries as of today i.e. 18 Apr 2023
- ⏰ HENCE THIS TOOK HOURS TO BUILD
! refer: https://github.com/NixOS/nixpkgs/commit/74207b79f05fe0f067528c7fd3c7c8fd60128939

# time nix-shell -p curlWithGnuTls -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/74207b79f05fe0f067528c7fd3c7c8fd60128939.tar.gz
# curl --version
```
```sh
curl 8.0.1 (x86_64-pc-linux-gnu) libcurl/8.0.1 GnuTLS/3.8.0 zlib/1.2.13 brotli/1.0.9 zstd/1.5.4 libidn2/2.3.4 libssh2/1.10.0 nghttp2/1.51.0
Release-Date: 2023-03-20
Protocols: dict file ftp ftps gopher gophers http https imap imaps mqtt pop3 pop3s rtsp scp sftp smb smbs smtp smtps telnet tftp
Features: alt-svc AsynchDNS brotli GSS-API HSTS HTTP2 HTTPS-proxy IDN Kerberos Largefile libz NTLM NTLM_WB SPNEGO SSL threadsafe TLS-SRP UnixSockets zstd
```

```diff
@@ Approach 4: Steps 2: Update default.nix to specify rusttls option for curl @@
```

```nix
# This is a Nix file named default.nix
# nix build -f default.nix

let
  pkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/74207b79f05fe0f067528c7fd3c7c8fd60128939.tar.gz";
  }) {};
  curltls = pkgs.curl.override { opensslSupport = false; rustlsSupport = true; };
in rec {
  myEnv = pkgs.buildEnv {
    name = "env";
    paths = [
      curltls
      pkgs.cacert
    ];
  };
}
```

```diff
@@ Approach 4: Steps 3: Scan for CVEs using SBOM @@
! nix run github:tiiuae/sbomnix#vulnxscan -- ./result
```
```sh
Potential vulnerabilities impacting 'result' or some of its runtime dependencies:

| vuln_id       | url                                            | package   | version   |  grype  |  osv  |  vulnix  |  sum  |
|---------------+------------------------------------------------+-----------+-----------+---------+-------+----------+-------|
| CVE-2023-0466 | https://nvd.nist.gov/vuln/detail/CVE-2023-0466 | openssl   | 3.0.8     |    1    |   0   |    1     |   2   |
| CVE-2023-0465 | https://nvd.nist.gov/vuln/detail/CVE-2023-0465 | openssl   | 3.0.8     |    1    |   0   |    1     |   2   |
| CVE-2023-0464 | https://nvd.nist.gov/vuln/detail/CVE-2023-0464 | openssl   | 3.0.8     |    1    |   0   |    1     |   2   |
```

```diff
@@ ./result/bin/curl --version @@

curl 8.0.1 (x86_64-pc-linux-gnu) libcurl/8.0.1 rustls-ffi/0.9.2/rustls/0.20.8 zlib/1.2.13 brotli/1.0.9 zstd/1.5.4 libidn2/2.3.4 libssh2/1.10.0 nghttp2/1.51.0
Release-Date: 2023-03-20
Protocols: dict file ftp ftps gopher gophers http https imap imaps mqtt pop3 pop3s rtsp scp sftp smtp smtps telnet tftp
Features: alt-svc AsynchDNS brotli GSS-API HSTS HTTP2 HTTPS-proxy IDN Kerberos Largefile libz SPNEGO SSL threadsafe UnixSockets zstd
```
```diff
@@ Approach 4: Steps 4: Why is openssl shown in vulnerabilities? @@
@@ Let us inspect the runtime dependencies? @@

- nix path-info /nix/store/qq7hg6ccfxqwmkrf6yl41svynw3p221s-env/ -rSh
```
```sh
/nix/store/0scnj0c385wpivhxcndg8yl29y0wlxfy-libunistring-1.1  	   1.7M
/nix/store/1fn9bbma0y8ccbc7vscfysbav3aaq2gf-nss-cacert-3.86   	 475.7K
/nix/store/4dq9kkpnxj9b2mn6jhw76099zpkwdxhm-libidn2-2.3.4     	   2.1M
/nix/store/hgk8b05xswawwlmzv9057336xhr3p8k6-glibc-2.35-224    	  30.9M
/nix/store/cnljympmlw1kg4j94y700dj10d7na2p5-gcc-12.2.0-lib    	  38.7M
/nix/store/6masxpxid431cm1b1f6k4b39fq3im0jz-zstd-1.5.4        	  39.8M
/nix/store/7p23dw8qna6hykicjl4c1a7jpflyjwbm-bash-5.2-p15      	  32.5M
/nix/store/7q7g02x7g19a9rbs0s33c7ln25vmq2cc-brotli-1.0.9-lib  	  32.6M
/nix/store/98md6rh7sni201qc171dkvjxhb34bb4b-openssl-3.0.8     	  37.1M
/nix/store/alkg051b3nsmagczqgwnrh5zm98nkqp1-zlib-1.2.13       	  31.1M
/nix/store/8cshalb7w38lkal5hbnsqy2mrdhqc1l8-libssh2-1.10.0    	  37.5M
/nix/store/ni9s9kffvm2d00jgbz4fqhj1cxw0n5sl-keyutils-1.6.3-lib	  31.0M
/nix/store/vy6xib9jjcaw9wjx1j7ggvvnhlpyz81m-libkrb5-1.20.1    	  34.8M
/nix/store/wvxaixf6ymr6y9bax5qfqx9404bcf7gs-nghttp2-1.51.0-lib	  31.2M
/nix/store/cfhgc8v0nz7zmx3rmipvmh83271v07hq-curl-8.0.1        	  56.8M
/nix/store/pgqbh67cmxc7swpa7k8q3qa1vxqrgal9-curl-8.0.1-bin    	  57.0M
/nix/store/vgrifdmm6n55y1pkgw9bldzlyh8h6x61-curl-8.0.1-man    	  60.6K
/nix/store/qq7hg6ccfxqwmkrf6yl41svynw3p221s-env               	  57.6M
```

```diff
@@ 💥 ❌ 🧨 Approach 4: Summary: Investigate if openssl is really needed as a runtime dependency @@
```

### 🧑‍🔬 Approach 5: Use OpenSSL 3.1.0 from OpenSSL Source Code

```diff
@@ Scenario: @@
@@ [19 Apr 2023]: OpenSSL 3.1.0 is not yet available in nixpkgs main branch @@

+ We build curl using openssl 3.1.0
```

```nix
# This is a Nix file named default.nix
# nix build -f default.nix

let
  pkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/74207b79f05fe0f067528c7fd3c7c8fd60128939.tar.gz";
  }) {};
  openssl = pkgs.openssl.overrideAttrs (old: { 
    version = "3.1.0"; 
    sha256 = "aaa925ad9828745c4cad9d9efeb273deca820f2cdcf2c3ac7d7c1212b7c497b4"; 
  });
  curlnew = pkgs.curl.override { opensslSupport = true; inherit openssl; };
in rec {
  myEnv = pkgs.buildEnv {
    name = "env";
    paths = [
      curlnew
      pkgs.cacert
    ];
  };
}
```

```diff
@@ Quirks: Why is openssl version still at 3.0.8 ? @@

# ./result/bin/curl --version
curl 8.0.1 (x86_64-pc-linux-gnu) libcurl/8.0.1 OpenSSL/3.0.8 zlib/1.2.13 brotli/1.0.9 zstd/1.5.4 libidn2/2.3.4 libssh2/1.10.0 nghttp2/1.51.0
Release-Date: 2023-03-20
Protocols: dict file ftp ftps gopher gophers http https imap imaps mqtt pop3 pop3s rtsp scp sftp smb smbs smtp smtps telnet tftp
Features: alt-svc AsynchDNS brotli GSS-API HSTS HTTP2 HTTPS-proxy IDN Kerberos Largefile libz NTLM NTLM_WB SPNEGO SSL threadsafe TLS-SRP UnixSockets zstd
```

```diff
@@ Quirks: Why are there multiple openssl versions as runtime dependencies? @@

# nix path-info /nix/store/nkf3jzdlgylyxhg0920sxkdwg6351dw1-env/ -rSh
/nix/store/0scnj0c385wpivhxcndg8yl29y0wlxfy-libunistring-1.1  	   1.7M
/nix/store/1fn9bbma0y8ccbc7vscfysbav3aaq2gf-nss-cacert-3.86   	 475.7K
/nix/store/4dq9kkpnxj9b2mn6jhw76099zpkwdxhm-libidn2-2.3.4     	   2.1M
/nix/store/hgk8b05xswawwlmzv9057336xhr3p8k6-glibc-2.35-224    	  30.9M
/nix/store/cnljympmlw1kg4j94y700dj10d7na2p5-gcc-12.2.0-lib    	  38.7M
/nix/store/6masxpxid431cm1b1f6k4b39fq3im0jz-zstd-1.5.4        	  39.8M
/nix/store/7q7g02x7g19a9rbs0s33c7ln25vmq2cc-brotli-1.0.9-lib  	  32.6M
/nix/store/98md6rh7sni201qc171dkvjxhb34bb4b-openssl-3.0.8     	  37.1M
/nix/store/alkg051b3nsmagczqgwnrh5zm98nkqp1-zlib-1.2.13       	  31.1M
/nix/store/8cshalb7w38lkal5hbnsqy2mrdhqc1l8-libssh2-1.10.0    	  37.5M
/nix/store/inqyv3wf4hby7m4zcc1xpfsxy5dazp2k-openssl-3.1.0     	  37.1M
/nix/store/7p23dw8qna6hykicjl4c1a7jpflyjwbm-bash-5.2-p15      	  32.5M
/nix/store/ni9s9kffvm2d00jgbz4fqhj1cxw0n5sl-keyutils-1.6.3-lib	  31.0M
/nix/store/vy6xib9jjcaw9wjx1j7ggvvnhlpyz81m-libkrb5-1.20.1    	  34.8M
/nix/store/wvxaixf6ymr6y9bax5qfqx9404bcf7gs-nghttp2-1.51.0-lib	  31.2M
/nix/store/2k5ngchzvy438x9axbjh2xszi7dd3bg9-curl-8.0.1        	  59.1M
/nix/store/7ravzjh47cxmvy0nmkhb5hcgdv9f2iyd-curl-8.0.1-man    	  60.6K
/nix/store/r6xic00v2vm2qjih7xkynaw177wdqcsj-curl-8.0.1-bin    	  59.3M
/nix/store/nkf3jzdlgylyxhg0920sxkdwg6351dw1-env               	  59.8M
```

```diff
@@ Let us get to the root cause of the dependencies @@

@@ nix why-depends /nix/store/nkf3jzdlgylyxhg0920sxkdwg6351dw1-env /nix/store/98md6rh7sni201qc171dkvjxhb34bb4b-openssl-3.0.8 @@

/nix/store/nkf3jzdlgylyxhg0920sxkdwg6351dw1-env
└───/nix/store/r6xic00v2vm2qjih7xkynaw177wdqcsj-curl-8.0.1-bin
    └───/nix/store/2k5ngchzvy438x9axbjh2xszi7dd3bg9-curl-8.0.1
        └───/nix/store/8cshalb7w38lkal5hbnsqy2mrdhqc1l8-libssh2-1.10.0
            └───/nix/store/98md6rh7sni201qc171dkvjxhb34bb4b-openssl-3.0.8

@@ nix why-depends /nix/store/nkf3jzdlgylyxhg0920sxkdwg6351dw1-env /nix/store/inqyv3wf4hby7m4zcc1xpfsxy5dazp2k-openssl-3.1.0 @@

/nix/store/nkf3jzdlgylyxhg0920sxkdwg6351dw1-env
└───/nix/store/r6xic00v2vm2qjih7xkynaw177wdqcsj-curl-8.0.1-bin
    └───/nix/store/inqyv3wf4hby7m4zcc1xpfsxy5dazp2k-openssl-3.1.0
```

```diff
@@ Query nix package called libssh2 @@
+ This helps us learn the exact package name mapped to the specific version

# nix-env -qaP libssh2
nixpkgs.libssh2                                libssh2-1.10.0
nixpkgs.lispPackages_new.sbclPackages.libssh2  libssh2-20160531-git
```

```diff
@@ We override libsssh2 as well @@

# This is a Nix file named default.nix
# nix build -f default.nix

let
  pkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/74207b79f05fe0f067528c7fd3c7c8fd60128939.tar.gz";
  }) {};
  openssl = pkgs.openssl.overrideAttrs (old: { 
    version = "3.1.0"; 
    sha256 = "aaa925ad9828745c4cad9d9efeb273deca820f2cdcf2c3ac7d7c1212b7c497b4"; 
  });
  libssh2 = pkgs.libssh2.override { inherit openssl; };
  curlnew = pkgs.curl.override { opensslSupport = true; inherit openssl; inherit libssh2; };
in rec {
  myEnv = pkgs.buildEnv {
    name = "env";
    paths = [
      curlnew
      pkgs.cacert
    ];
  };
}
```

```diff
@@ ./result/bin/curl --version @@

curl 8.0.1 (x86_64-pc-linux-gnu) libcurl/8.0.1 OpenSSL/3.0.8 zlib/1.2.13 brotli/1.0.9 zstd/1.5.4 libidn2/2.3.4 libssh2/1.10.0 nghttp2/1.51.0
Release-Date: 2023-03-20
Protocols: dict file ftp ftps gopher gophers http https imap imaps mqtt pop3 pop3s rtsp scp sftp smb smbs smtp smtps telnet tftp
Features: alt-svc AsynchDNS brotli GSS-API HSTS HTTP2 HTTPS-proxy IDN Kerberos Largefile libz NTLM NTLM_WB SPNEGO SSL threadsafe TLS-SRP UnixSockets zstd
```

```diff
@@ curl --version still shows openssl 3.0.8 @@
@@ Let us cross check the runtime dependencies @@

@@ nix path-info /nix/store/70lfij94qxakd0w96r4rb2n95an8dxn5-env/ -rSh @@
/nix/store/0scnj0c385wpivhxcndg8yl29y0wlxfy-libunistring-1.1  	   1.7M
/nix/store/1fn9bbma0y8ccbc7vscfysbav3aaq2gf-nss-cacert-3.86   	 475.7K
/nix/store/4dq9kkpnxj9b2mn6jhw76099zpkwdxhm-libidn2-2.3.4     	   2.1M
/nix/store/619pdd4jfqw59r8d70kg3vvyxjjjixvg-curl-8.0.1-man    	  60.6K
/nix/store/hgk8b05xswawwlmzv9057336xhr3p8k6-glibc-2.35-224    	  30.9M
/nix/store/cnljympmlw1kg4j94y700dj10d7na2p5-gcc-12.2.0-lib    	  38.7M
/nix/store/6masxpxid431cm1b1f6k4b39fq3im0jz-zstd-1.5.4        	  39.8M
/nix/store/alkg051b3nsmagczqgwnrh5zm98nkqp1-zlib-1.2.13       	  31.1M
/nix/store/7q7g02x7g19a9rbs0s33c7ln25vmq2cc-brotli-1.0.9-lib  	  32.6M
/nix/store/inqyv3wf4hby7m4zcc1xpfsxy5dazp2k-openssl-3.1.0     	  37.1M
/nix/store/pq1f0gb5qw4w13rrhdz4cpc742ih47qv-libssh2-1.10.0    	  37.5M
/nix/store/7p23dw8qna6hykicjl4c1a7jpflyjwbm-bash-5.2-p15      	  32.5M
/nix/store/ni9s9kffvm2d00jgbz4fqhj1cxw0n5sl-keyutils-1.6.3-lib	  31.0M
/nix/store/vy6xib9jjcaw9wjx1j7ggvvnhlpyz81m-libkrb5-1.20.1    	  34.8M
/nix/store/wvxaixf6ymr6y9bax5qfqx9404bcf7gs-nghttp2-1.51.0-lib	  31.2M
/nix/store/c078y8r3pjkd815jmk68h6kdm78nh5d2-curl-8.0.1        	  52.9M
/nix/store/yxfiia8nif5932x9shviy7jv4m2rsa3p-curl-8.0.1-bin    	  53.1M
/nix/store/70lfij94qxakd0w96r4rb2n95an8dxn5-env               	  53.7M

@@ 😍 Look! openssl 3.0.8 is no longer a runtime dependency @@
```

```diff
@@ Lets check for CVEs @@

@@ nix run github:tiiuae/sbomnix#vulnxscan -- ./result @@

Potential vulnerabilities impacting 'result' or some of its runtime dependencies:

| vuln_id       | url                                            | package   | version   |  grype  |  osv  |  vulnix  |  sum  |
|---------------+------------------------------------------------+-----------+-----------+---------+-------+----------+-------|
| CVE-2023-0466 | https://nvd.nist.gov/vuln/detail/CVE-2023-0466 | openssl   | 3.1.0     |    1    |   0   |    1     |   2   |
| CVE-2023-0465 | https://nvd.nist.gov/vuln/detail/CVE-2023-0465 | openssl   | 3.1.0     |    1    |   0   |    1     |   2   |
| CVE-2023-0464 | https://nvd.nist.gov/vuln/detail/CVE-2023-0464 | openssl   | 3.1.0     |    1    |   0   |    1     |   2   |

@@ 🕵️‍♀️ Above implies openssl 3.1.0 has not fixed the CVEs yet! @@
+ We probably need not upgrade openssl to 3.1.0 right away!
```

### Future Works
```diff
@@ MOAR on Memory Safety @@
+ https://www.chainguard.dev/unchained/building-the-first-memory-safe-distro-wolfi
```

```diff
@@ Others @@
# sha256 vs hash
# Target different architectures
# Reduce image size by removing the man pages
# Reduce image size by removing the localization info
# Reduce image size by stripping the binaries
```

### Thank You
```yaml
- 🔥 https://github.com/teamniteo/nix-docker-base/blob/master/scripts/export-profile
- 💎 https://github.com/teamniteo/nix-docker-base/tree/master/static-root-files/etc
- 💎 https://news.ycombinator.com/item?id=30918962
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
