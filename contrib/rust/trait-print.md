## https://fettblog.eu/rust-tiny-little-traits/

### very clumsy writing println!("{:?}", whatever);
```rust
trait Print {
    fn print(&self);
}
```

### Implement Print for every type that implements Debug
```rust
impl<T: std::fmt::Debug> Print for T {
    fn print(&self) {
        println!("{:?}", self);
    }
}
```

### Easy Life
```rust
"Hello, world".print();
vec![0, 1, 2, 3, 4].print();
"You get the idea".print()
```


referral link - https://rolp.co/IumxC
https://vmware.rolepoint.com/?shorturl=HGEEC#job/ahBzfnJvbGVwb2ludC1wcm9kchALEgNKb2IYgIDou7fjtQoM
R2221828	 Business Strategy and Operations-Project Management	 09/11/2022
Bengaluru, Karnataka, India
workday - alu@1xxVXX
