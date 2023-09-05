### Shoutout
```yaml
- https://github.com/rust-lang/docker-rust/tree/master
```

### Dockerfile Generation using Py & Dockerfile Templates
```yaml
- https://github.com/rust-lang/docker-rust/blob/master/x.py
```

### TIL
```yaml
- f-string to enclose formatted string
```

### File + Read + f-string + UTF
```py
rust_version = "1.72.0"

def rustup_hash(arch):
    url = f"https://static.rust-lang.org/rustup/archive/{rustup_version}/{arch}/rustup-init.sha256"
    with request.urlopen(url) as f:
        return f.read().decode('utf-8').split()[0]
```

### Named Tuple & Usage
```py
// Definition
// I.e. DebianArch type with properties bashbrew, dpkg, rust
DebianArch = namedtuple("DebianArch", ["bashbrew", "dpkg", "rust"])

// A List of Initialised DebianArch type
// I.e. DebianArch obj with filled-up properties
debian_arches = [
    DebianArch("amd64", "amd64", "x86_64-unknown-linux-gnu"),
    DebianArch("arm32v7", "armhf", "armv7-unknown-linux-gnueabihf"),
    DebianArch("arm64v8", "arm64", "aarch64-unknown-linux-gnu"),
    DebianArch("i386", "i386", "i686-unknown-linux-gnu"),
]

for arch in alpine_arches:
    hash = rustup_hash(arch.rust)  // Named Dot Operations with Minimal Effort 🎖️🎖️🎖️
```

### Variants & the Default
```py
debian_variants = [
    "buster",
    "bullseye",
    "bookworm",
]

default_debian_variant = "bookworm"
```

### Git Commit of a File
```py
def file_commit(file):
    return subprocess.run(
            ["git", "log", "-1", "--format=%H", "HEAD", "--", file],
            capture_output = True) \
        .stdout \
        .decode('utf-8') \
        .strip()
```

### Read File
```py
def read_file(file):
    with open(file, "r") as f:
        return f.read()
```

### Write File
```py
def write_file(file, contents):
    dir = os.path.dirname(file)
    if dir and not os.path.exists(dir):
        os.makedirs(dir)
    with open(file, "w") as f:
        f.write(contents)
```

### Generate Shell Script Within the Dockerfile Template
```py
// Notice Indentation
// Really Simple Way to Build File Contents
// Smart Use of %% vs ${} vs f"{}"
// Simplest Ever Dockerfile Generation                 🎖️🎖️🎖️
// Use of \\\n to Let the Script Rendered with \n      🎖️🎖️🎖️
// Use of f-Strings to Python Variable Substitution    🎖️🎖️🎖️
def update_debian():
    arch_case = 'dpkgArch="$(dpkg --print-architecture)"; \\\n'
    arch_case += '    case "${dpkgArch##*-}" in \\\n'
    for arch in debian_arches:
        hash = rustup_hash(arch.rust)
        arch_case += f"        {arch.dpkg}) rustArch='{arch.rust}'; rustupSha256='{hash}' ;; \\\n"
    arch_case += '        *) echo >&2 "unsupported architecture: ${dpkgArch}"; exit 1 ;; \\\n'
    arch_case += '    esac'

    template = read_file("Dockerfile-debian.template")
    slim_template = read_file("Dockerfile-slim.template")

    for variant in debian_variants:
        rendered = template \
            .replace("%%RUST-VERSION%%", rust_version) \
            .replace("%%RUSTUP-VERSION%%", rustup_version) \
            .replace("%%DEBIAN-SUITE%%", variant) \
            .replace("%%ARCH-CASE%%", arch_case)
        write_file(f"{rust_version}/{variant}/Dockerfile", rendered)

        rendered = slim_template \
            .replace("%%RUST-VERSION%%", rust_version) \
            .replace("%%RUSTUP-VERSION%%", rustup_version) \
            .replace("%%DEBIAN-SUITE%%", variant) \
            .replace("%%ARCH-CASE%%", arch_case)
        write_file(f"{rust_version}/{variant}/slim/Dockerfile", rendered)
```
