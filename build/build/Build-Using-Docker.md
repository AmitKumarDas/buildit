### Shoutouts

```yaml
- https://github.com/estesp/manifest-tool/tree/main
  - Docker, Digest, Index, Manifest, Golang, CLI, Debug
```

```yaml
- https://github.com/estesp/manifest-tool/blob/main/Dockerfile
  - Developer Environment, Dependencies, Bind Mount Source
```

```yaml
- https://github.com/distribution/distribution/blob/main/dockerfiles/git.Dockerfile
  - Developer Environment, Mount from Other Layer, Go Install from Commit
  - ENV GIT_CHECK_EXCLUDE="./vendor"
  - Mount, Bind, Cache
  - Each check / feature is done inside a specific Dockerfile
```

```yaml
- https://github.com/distribution/distribution/blob/main/dockerfiles/lint.Dockerfile
  - Developer Environment, Lint Inside Dockerfile, Mount, Cache, Bind
```

```yaml
- https://github.com/distribution/distribution/blob/main/dockerfiles/vendor.Dockerfile
  - Check outdated vendor
  - git status --porcelain -- go.mod go.sum vendor
  - go mod outdated
```
