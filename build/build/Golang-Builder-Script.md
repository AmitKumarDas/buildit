### Shoutouts
```yaml
- https://github.com/bitfield/script
```

### Imports to Watch Out
```go
"bufio"
"container/ring"
"crypto/sha256"
"encoding/hex"
"encoding/json"
"github.com/itchyny/gojq"
"mvdan.cc/sh/v3/shell"
```

### Make Others' API your Own - http.Get
```go
func (p *Pipe) WithHTTPClient(c *http.Client) *Pipe {...}     # Builder Step
func (p *Pipe) Get(url string) *Pipe {...}                    # Piggyback on the Known API
func Get(url string) *Pipe {...}                              # New Instance
```
