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

### Named Tuple
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
```

### 
