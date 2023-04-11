#### Reference
```yaml
- https://github.com/teamniteo/nix-docker-base
```

#### Step: Create default.nix file
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

#### Step:


