## https://fettblog.eu/rust-tiny-little-traits/

### WHAT
- Inverting all the way
- Convert that simple function or condition to trait
- One trait (i.e. interface) With One Function
  - You do not really need to follow this rule always

### WOW
- We make the standard library structs &/ enums implement our trait
- Our customization to std lib
- We can also make it a pub(crate)

### HOW
- The trait function almost always take &self as the first arg
- 

### Did you know
- std::net
  - Ipv4Addr & Ipv6Addr are two structs
  - IpAddr is an enum
- &self is a reference of itself
  - Is shorthand for self: &Self
  - Has access to all fields of the struct it is referring to

### Baby Steps -> Ask -> All Seem Quirky

#### if let Ok(some_list) = something
```rust
let addr = req.as_str();
let addr = (addr, 0).to_socket_addrs(); // Is this tuple 😎 // Gives us SocketAddr

if let Ok(addresses) = addr { // Should the LHS & RHS reverse 😎
    for a in addresses {
        if a.ip().eq(&Ipv4Addr::new(127, 0, 0, 1)) { // & and new together 😎 i.e. &Self
            return Box::pin(async { Err(io::Error::from(ErrorKind::Other)) }); // So loong 😎
        }
    }
}
```

#### Do not get confused with &self & self
```rust
impl IsLocalhost for Ipv4Addr {
    fn is_localhost(&self) -> bool { // Since &self is shorthand for self: &Self 😎
        Ipv4Addr::new(127, 0, 0, 1).eq(self) || Ipv4Addr::new(0, 0, 0, 0).eq(self) // since self is &Self 😎
    }
}

impl IsLocalhost for Ipv6Addr { // impl like quirky old Java times 😎
    fn is_localhost(&self) -> bool {
        Ipv6Addr::new(0, 0, 0, 0, 0, 0, 0, 1).eq(self) // Did you know these numbers 😎
    }
}
```

#### What is ref in an enum match
```rust
impl IsLocalhost for IpAddr { // Implement trait for the enum
    fn is_localhost(&self) -> bool {
        match self {
            IpAddr::V4(ref a) => a.is_localhost(), // Why => 😎 Is it anonymous function impl
            IpAddr::V6(ref a) => a.is_localhost(), // ref 🥸 Is it destructuring?
        }
    }
}
```

#### Impl at another struct from lib
```rust
// Should we implement these everywhere
// Feels like we are adding syntactic sugar everywhere 🤔
impl IsLocalhost for SocketAddr {
    fn is_localhost(&self) -> bool {
        self.ip().is_localhost()
    }
}
```