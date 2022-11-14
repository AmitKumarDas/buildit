## More on ref

```yaml
- IpAddr::V4(ref a) => a.is_localhost(), # within a match self
- IpAddr::V6(ref a) => a.is_localhost(), # where self is &self
```
