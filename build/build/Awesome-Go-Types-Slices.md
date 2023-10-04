### Shoutouts
```yaml
- https://go.dev/blog/deconstructing-type-parameters # type # generic # slices
```

### See It Works
```go
func Clone[S ~[]E, E any](s S) S {
  // Appending TO a slice with ZERO CAPACITY
  // will CREATE a new BACKING ARRAY
  return append(s[:0:0], s...)
}
```
