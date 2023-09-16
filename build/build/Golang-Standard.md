## src/strings/reader.go

### 1-Pager - High Level
```yaml
- Implements multiple Golang Interfaces
- Implements all Interface contracts by reading from a string
- NOTE: READ actually WRITES against the provided []byte
```

### 1-Pager - Low Level
```yaml
- n = copy(b, r.s[off:])
```
