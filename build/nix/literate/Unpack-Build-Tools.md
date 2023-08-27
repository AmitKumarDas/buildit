### What
- Deep dive into build systems & pieces that make one

### Shoutout
```yaml
- https://github.com/casey/just
- https://github.com/golang/go/issues/50603 # version
```

### Notes on Just
```yaml
- just:  a command runner & not a build system
- just: like make & does not tries to be a build system
- os_funcs: os, arch, os_family,
- env: env_var, env_var_or_default
- file_funcs: path & file manipulations,
- util_funcs: quote, replace, replace_regex, trim
- conds: path_exists,
- sha: sha256, sha256_path, uuid
- env: load & export
- export: export variables to recipes as env variables
- attributes: use of annotations against recipes
- conds: os specific recipes via attributes / annotations
- result: store command evaluation via backticks
- conds: expressions, regex, inside {{}},
- error_func: use inside conditions to stop execution when validation fails
- args: pass via NAME=VALUE pairs while executing just command line
- args: OVERRIDE the VARIABLES declared in the justfile
- syntax: {{..}} for justfile variables & recipe parameters substitution # 🎖️ YAML
- syntax: ${..} for env variable substitution # 🎖️ YAML
- env: load env variables from .env FILE if dotenv-load is set
- parameters: to just recipes; different from env; different from variables
```

### Notes on Go & Version
```yaml
- refer: https://github.com/golang/go/issues/50603
```
