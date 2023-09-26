### Shoutouts
```yaml
- https://github.com/fornwall/rust-script/tree/main/tests/scripts  # 🎖️
- https://tldp.org/LDP/abs/html/parameter-substitution.html
```

### Test | Assert
```sh
#!/bin/sh
set -e -u
assert_equals() {
    if [ "$1" != "$2" ]; then
      echo "Invalid output: Expected '$1', was '$2'"
      exit 1
    fi
}
assert_equals "result: 3" "$(just -f justfile/Justfile)"
assert_equals "hello, rust" "$(./hello.ers)"
assert_equals "hello, rust" "$(./hello-without-main.ers)"

HYPERFINE_OUTPUT=$(rust-script --wrapper "hyperfine --runs 99" fib.ers)

case "$HYPERFINE_OUTPUT" in
  *"99 runs"*)
    ;;
  *)
    echo "Hyperfine output: $HYPERFINE_OUTPUT"
    exit 1
    ;;
esac
```

### Debian | tar | ar | Condition NIL | Condition File
```sh
#!/bin/sh
set -o errexit

DEB=$1
if [ -z "$DEB" ]; then
  echo "Usage: dpkg_extract <deb file> [files to extract]"
  exit 1;
fi

if ! [ -f "$DEB" ]; then
  echo "$DEB package was not found"
  exit 1;
fi

shift

ar -x "$DEB" data.tar.xz
tar -xf data.tar.xz "$@"
rm data.tar.xz
```

### Loop | Retry | distroless/updateWorkspaceSnapshots.sh
```sh
#/bin/sh

set -o errexit
set -o xtrace

# build our package_manager
(cd debian_package_manager; make update)

# the default config and output files are all in the current working
# working directory
for i in $(seq 5); do ./debian_package_manager/update && exit 0 || sleep 60; done

# we didn't succesfully complete an update
exit 1
```
