### 🍬 Motivation 🍬
- Teams feel use of distroless images are limited!
- Is distroless suitable for binaries that depend on shared dependencies e.g. c/c++ projects?
- Can distroless go beyond minimalism i.e. from minimal size to size that is accounted?
- What is distroless' answer to securing Software Supply Chain?
- Will understanding Bazel help build custom distroless images?

```diff
@@ Risk Reward Ratio: Learning Bazel vs. Managing thousands of CVEs @@
```

### 🚴‍♀️ Bazel 101 - Day 1 🚴‍♀️
```diff
@@ https://jayconrod.com/posts/115/organizing-bazel-workspace-files @@
```

```diff
# WORKSPACE file in present in root 💥
# Is USED to declare external DEPENDENCIES 💥
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
# 2/ Put above in ROOT of the directory & hence make it easy to find
# 3/ AVOID LOADING OTHER .bzl files here since it needs those .bzl files to be declared earlier
# 4/ DON'T OVERRIDE EARLIER DECLARATIONS of the same repositories. How? 
# -- Verify whether a dependency has been declared by calling native.existing_rule
```

#### 🥤 Snippets 🥤
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

### 🚴‍♀️ Bazel 101 - Day 2 🚴‍♀️

```diff
@@ https://jayconrod.com/posts/106/writing-bazel-rules--simple-binary-rule @@

# 1/ You say WHAT you WANT to build, NOT HOW to build it 👈 🧐
# 2/ Each BUILD file implicitly defines a Bazel PACKAGE 💥
# Note: BUILD file may be BLANK to define a package 💥
```

```diff
@@ PACKAGE VS. TARGET VS. BUILD VS. DIRECTORY @@

# 1/ A PACKAGE consists of the TARGETS declared in the BUILD.bazel file 💥
# 2/ and all of the FILES in the package's DIRECTORY and SUBDIRECTORIES
# 3/ EXCLUDING targets and files defined in OTHER packages' subdirectories
```

```diff
@@ Labels are strings that look like "@io_bazel_rules_go//go:def.bzl" @@

# 1/ REPO name (io_bazel_rules_go)
# 2/ PACKAGE name (go)
# 3/ FILE or TARGET name (def.bzl)

@@ Repository name and the package name may be omitted @@ 
# -- when a label refers to something in the same repository or package

@@ Repositories are defined in a file called WORKSPACE @@ 💥
# -- lives in the root directory of a project
```

```diff
@@ Loading Phase: READ build files & output a GRAPH of TARGETS and DEPENDENCIES @@

! BUILD files => LOAD => TARGET GRAPH 💥
```

```diff
@@ Analysis Phase: Bazel evaluates RULES in the target graph @@

# RULES == FILES + ACTIONS (that will produce those files) 💥
# The output of analysis is the file-action graph
# Rules cannot directly perform any I/O

! TARGET GRAPH => ANALYSIS => FILE ACTION GRAPH 💥
```

```diff
@@ Execution Phase: Runs actions in the file-action graph @@

! Produces files that are out of date 💥

# Several strategies for running actions:

! 1/ LOCAL: Runs actions within a SANDBOX that only exposes DECLARED INPUTS
# Thus Hermetic builds: Hard to accidentally depend on system files that vary across machines 💥

! 2/ Run actions on REMOTE build servers where this isolation happens automatically
```

### 🚴‍♀️ Bazel 101 - Day 3 🚴‍♀️

```diff
@@ https://github.com/jayconrod/rules_go_simple @@ 🥤

# Declare ALL external dependencies inside a function in deps.bzl
# So projects that depend on rules_go_simple can SHARE these dependencies
```


### 🥤 TIL 🥤
```diff
# bazel_skylib is a set of libraries that are useful for writing Bazel rules
# A function is private if it starts with an underscore (it cannot be loaded from other files)
# Declaring a git repository doesn't automatically download it (downloaded only if something is needed from inside)
# All rules support a set of common attributes (name, visibility, & tags). These don't need to be declared explicitly
# DefaultInfo is a special provider that all rules should return
# Folder Structure: WORKSPACE may load deps.bzl
# Folder Structure: internal/rules.bzl may load internal/actions.bzl
# run_shell takes the list of INPUT files that will be made available in the SANDBOX
# Instead of writing Bash commands, it's better to compile tools with Bazel and use those
# That lets you write more sophisticated (and reproducible) build logic in your language of choice
```

```diff
@@ Exercise caution on using Bash commands in Bazel actions for several reasons @@

# It's hard to write portable commands
# It's hard to get quoting and escaping right (definitely use shell.quote from @bazel_skylib)
# It's hard to avoid including some implicit dependency
# Bazel tries to isolate you from this with the sandbox
```

```diff
# I had to use use_default_shell_env = True to be able to find "go" on PATH
# We should generally avoid using tools installed on the user's system since they may differ across systems
```
