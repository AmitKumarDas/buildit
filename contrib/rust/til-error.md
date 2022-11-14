## Notes - https://hoverbear.org/blog/understand-over-guesswork/
```yaml
- io::Error and a Utf8Error are different types 
- Hence they cannot be returned in the same Result<T,E>
- Since the E value would differ and violate Rust's strong typing
- Solve this problem:
  - Creating your enum of various Error types
  - Implement Into<T> &/ From<T> traits
- 
```
