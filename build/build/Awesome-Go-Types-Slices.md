### Shoutouts
```yaml
- https://go.dev/blog/deconstructing-type-parameters # type # generic # slices
```

### slices.Clone in go
```go
func Clone[S ~[]E, E any](s S) S {
  // Appending TO a slice with ZERO CAPACITY
  // will CREATE a new BACKING ARRAY
  return append(s[:0:0], s...)
}
```

### A Custom Clone function
```go
func Clone[E any](s []E) []E {
  // ...
}
```
