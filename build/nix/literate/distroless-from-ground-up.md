### 🍬 Motivation 🍬
- Teams feel use of distroless images are limited!
- Is distroless suitable for binaries that have a bunch of shared dependencies?
- Does distroless go beyond minimal size to accounted size?
- What is distroless' answer to securing Software Supply Chain?
- Will understanding Bazel help build custom distroless images?

```diff
@@ Risk Reward Ratio: Learning Bazel vs. Managing thousands of CVEs @@
```

### 🚴‍♀️ Bazel 101 🚴‍♀️
```diff
@@ https://jayconrod.com/posts/115/organizing-bazel-workspace-files @@
```

```diff
# WORKSPACE file in present in root
# Is used to declare dependencies
```

```diff
! Managing WORKSPACE file is one of the most difficult parts of using Bazel

@@ Can run arbitrary commands on the host system @@
@@ WORKSPACE files in external repositories are NOT evaluated RECURSIVELY @@
@@ You're responsible for declaring direct dependencies & indirect dependencies @@
```

```diff
@@ Bazel has NO TOOLS to: @@
# 1/ LIST indirect dependencies 
# 2/ RESOLVE CONFLICTS between multiple declarations
```

```diff
@@ Best Practices: Dependency Management @@
# 1/ Name of the file s.a. deps.bzl or myabc_deps.bzl
# 2/ Put above in root of the directory & hence make it easy to find
# 3/ Avoid loading other .bzl files here since it needs those .bzl files to be declared earlier
# 4/ DON'T OVERRIDE EARLIER DECLARATIONS of the same repositories. How? 
# -- Verify whether a dependency has been declared by calling native.existing_rule
```

### 🥤 Learnings so far 🥤
```bzl
def _maybe(rule, name, **kwargs):
  if not native.existing_rule(name):
    rule(name = name, **kwargs)
```
```bzl
_maybe(
  http_archive,
  name = "zlib",
  build_file = "@com_google_protobuf//:third_party/zlib.BUILD",
  sha256 = "629380c90a77b964d896ed37163f5c3a34f6e6d897311f1df2a7016355c45eff",
  strip_prefix = "zlib-1.2.11",
  urls = ["https://github.com/madler/zlib/archive/v1.2.11.tar.gz"],
)
```

### 💥 Bazel & Starlark 101 💥

```diff
@@ https://jayconrod.com/posts/106/writing-bazel-rules--simple-binary-rule @@

# 1/ You say WHAT you want to build, NOT HOW to build it 👈 🧐
# 2/ Each BUILD file implicitly defines a Bazel package
```

```diff
@@ PACKAGE VS. TARGET VS. BUILD VS. DIRECTORY @@

# 1/ A PACKAGE consists of the TARGETS declared in the BUILD.bazel file
# 2/ and all of the FILES in the package's DIRECTORY and SUBDIRECTORIES
# 3/ EXCLUDING targets and files defined in OTHER packages' subdirectories
```

```diff
@@ Labels are strings that look like "@io_bazel_rules_go//go:def.bzl" @@

# 1/ a repository name (io_bazel_rules_go)
# 2/ a package name (go)
# 3/ and a file or target name (def.bzl)

@@ Repository name and the package name may be omitted @@ 
# when a label refers to something in the same repository or package

@@ Repositories are defined in a file called WORKSPACE @@ 
# which lives in the root directory of a project
```
