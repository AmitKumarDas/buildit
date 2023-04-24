### References
```diff
# 👍 https://go.googlesource.com/proposal/+/master/design/56986-godebug.md

# https://github.com/kubernetes/kubernetes/pull/113983
# https://github.com/kubernetes/enhancements/tree/master/keps/sig-release/3744-stay-on-supported-go-versions
# https://kubernetes.io/blog/2023/04/06/keeping-kubernetes-secure-with-updated-go-versions/
# https://github.com/aws/eks-distro-build-tooling/tree/main/projects/golang/go
# https://github.com/aws/eks-distro
# https://github.com/aws/eks-distro-build-tooling
# https://ryantm.github.io/nixpkgs/languages-frameworks/go/
# https://www.tweag.io/blog/2021-03-04-gomod2nix/
# https://nichi.co/articles/go-module-in-nix.html
# https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/tools/go-migrate/default.nix
# https://github.com/NixOS/nixpkgs/tree/master/pkgs/development/compilers/go
# https://github.com/coredns/coredns/issues/5997
# https://docs.google.com/document/d/1C7utWMjGpDcBc5TB_ooddERsid59sFLC7gqLzyS5aKY/edit
```

### Quote / UnQuote
```diff
@@ Impossible to update @@ 

# Older, long-term-supported versions of Kubernetes to a newer version of Go
# Those older versions don’t have the same access to performance improvements and bug fixes
```

```diff
@@ Practice of being able to opt out of these risky changes using GODEBUG settings @@
```
