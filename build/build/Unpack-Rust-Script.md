### Shoutout
```yaml
- https://rust-script.org/
```

### Rust TILs
```yaml
- Debug Formatter: {:?}
- #!/usr/bin/env rust-script as a shebang line
- -e/--expr option to accept a Rust expression
- -d/--dep option to accepts dependencies (if any)
```

### What makes Rust Expression to Work
```yaml
- The code given is EMBEDDED into a block expression
- EVALUATED
- PRINTED out using the Debug formatter (i.e. {:?})
```

### Writing a Quick Filter ~ Pipes we all Love
```sh
cat now.ers | rust-script --loop \
    "let mut n=0; move |l| {n+=1; println!(\"{:>6}: {}\",n,l.trim_end())}"
```
```sh
 1: // cargo-deps: time="0.1.25"
 3: fn main() {
 4:     println!("{}", time::now().rfc822z());
 5: }
```
