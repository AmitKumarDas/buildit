### Credit
```diff
# https://jayconrod.com/posts/
# https://www.youtube.com/watch?v=2KUunGBZiiM
# https://www.youtube.com/watch?v=hLD6vKl4Txc
# https://github.com/kriscfoster/multi-language-bazel-monorepo    😍
```

### Summary

```diff
@@ .bazelrc for build configurations @@
# So you do not need to pass them as args    - while executing bazel run
```

```diff
@@ @workspace//pkg/path:target @@

//pkg/path:target - OMIT @workspace          - if in same workspace
:target           - OMIT //pkg/path          - if in same package
target            - same as :target          - conventionally only used for files
//pkg/path        - same as //pkg/path:path
```

### 🚴‍♀️ Bazel 101 - Day 1 🚴‍♀️

```diff
# WORKSPACE file present in root Is USED to declare external DEPENDENCIES      💥
```

```diff
@@ Managing WORKSPACE file - Most difficult @@

# Can run arbitrary COMMANDS on the host system                                💣
# WORKSPACE files in external repositories are NOT evaluated RECURSIVELY       😢
# You declare direct & indirect DEPENDENCIES                                   😢
```

```diff
@@ Bazel CAN NOT: @@
# 1/ List INDIRECT dependencies 
# 2/ Resolve CONFLICTS between multiple declarations
```

```diff
@@ Best Practices: Dependency Management @@

# 1/ NAME                                                - deps.bzl or myabc_deps.bzl
# 2/ PLACE                                               - at ROOT - easy to find
# 3/ AVOID LOADING OTHER .bzl files inside .bzl file     - it forces those .bzl files to be declared earlier
# 4/ DON'T OVERRIDE EARLIER DECLARATIONS                 - of the same repositories
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
@@ Each BUILD file implicitly defines a Bazel PACKAGE @@ 💥 
# Note: BUILD file may be BLANK to define a package 💥
```

```diff
@@ PACKAGE VS. TARGET VS. BUILD VS. DIRECTORY @@

# 1/ A PACKAGE contains TARGETS declared in the BUILD.bazel file
# 2/ And all of the FILES in the package's DIRECTORY and SUBDIRECTORIES
# 3/ EXCLUDING targets and files defined in OTHER packages' subdirectories
```

```diff
@@ Labels ~ strings ~ "@io_bazel_rules_go//go:def.bzl" @@

# 1/ REPO name (io_bazel_rules_go)
# 2/ PACKAGE name (go)
# 3/ FILE or TARGET name (def.bzl)

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

# Produces files that are OUT-OF-DATE 💥
# Several strategies for running actions

! 1/ LOCAL: Runs actions within a SANDBOX that only exposes DECLARED INPUTS
# Thus Hermetic builds: Hard to accidentally depend on system files that vary across machines 💥

! 2/ Run actions on REMOTE build servers where this isolation happens automatically
```

### 🚴‍♀️ Bazel 101 - Day 3 🚴‍♀️

```diff
@@ https://github.com/jayconrod/rules_go_simple @@ 🥤
```

```diff
# Declare ALL external dependencies inside a function in deps.bzl
# So projects that depend on rules_go_simple can SHARE these dependencies
```

```diff
# bazel_skylib is a set of libraries that are useful for writing Bazel rules
# A function is private if it starts with an underscore (it cannot be loaded from other files)
# Declaring a git repository doesn't automatically download it (downloaded only if something is needed from inside)
# All rules support a set of common attributes (name, visibility, & tags). These don't need to be declared explicitly
# DefaultInfo is a special provider that all rules should return
# run_shell takes the list of INPUT files that will be made available in the SANDBOX
# Instead of writing Bash commands, it's better to compile tools with Bazel and use those
# That lets you write more sophisticated (and reproducible) build logic in your language of choice
# create one file that loads our public symbols e.g. def.bzl
# To test a rule, we can define a sh_test rule that runs the rule and checks its output
```

```diff
@@ Folder Structure: @@

# WORKSPACE may load deps.bzl
# internal/rules.bzl may load internal/actions.bzl
# tests/BUILD.bazel & can be tested with: bazel test //tests:hello_test
```

```diff
@@ Exercise caution on using Bash commands in Bazel actions @@ ❌

# It's hard to write portable commands
# It's hard to get quoting and escaping right (definitely use shell.quote from @bazel_skylib)
# It's hard to avoid including some implicit dependency
# Bazel tries to isolate you from this with the sandbox
```

```diff
# I had to use use_default_shell_env = True to be able to find "go" on PATH
# We should generally avoid using tools installed on the user's system since they may differ across systems
```

### 🚴‍♀️ Bazel 101 - Day 4 🚴‍♀️
```diff
@@ https://jayconrod.com/posts/107/writing-bazel-rules--library-rule--depsets--providers @@
```

```diff
# Structs, providers, and depsets: Data structures to pass information between rules
# Struct values are immutable
# There are also to_json and to_proto methods on every struct
# We'll use depsets to accumulate information about dependencies
# NO need to explicitly WRITE ALL TRANSITIVE dependencies in the go_binary rule
```

### 🚴‍♀️ Bazel 101 - Day 5 🚴‍♀️
```diff
@@ https://jayconrod.com/posts/108/writing-bazel-rules--data-and-runfiles @@
```

```diff
# data files are made available at run-time using data attributes
# useful for plugins, configuration files, certificates and keys, and resources
```

### 🚴‍♀️ Bazel 101 - Day 6 🚴‍♀️
```diff
@@ https://jayconrod.com/posts/109/writing-bazel-rules--moving-logic-to-execution @@ 🥵
```

```diff
# Rule set authors can write code for any of these phases
# It's often possible to solve a problem multiple ways
# Execution phase has many advantages
# Execution code has I/O access to source files, so it can be smarter
# It can be written in any language, so it can be faster and more flexible than Starlark
# Work can be distributed across many machines
# And the results can be cached persistently, so it can be faster for everyone
```

```diff
# In Go, importcfg files map import paths 🥤
# e.g. "net/http" to compiled package files like /home/jay/go/pkg/linux_amd64/net/http.a
# The ‑I and ‑L compiler and linker options, which let us specify directories to search
# Using search paths requires extra I/O and is somewhat inflexible and error-prone
# So it's better to use importcfg files
```
