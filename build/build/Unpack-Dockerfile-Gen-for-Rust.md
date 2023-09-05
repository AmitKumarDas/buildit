### Shoutout
```yaml
- https://github.com/rust-lang/docker-rust/tree/master
```

### Dockerfile Generation using Py & Dockerfile Templates
```yaml
- https://github.com/rust-lang/docker-rust/blob/master/x.py
```

### Workflow
```yaml
- Bunch of files present in releases pages of github repo
- These files include: Dockerfile, .py, .rs, .env, build.config, justfile, etc
- Dockerfile is the BUILD ENV for pyhon or rust or just
- These files can be downloaded by carvel's vendir, etc.
- release-machinery/ folder will have these downloaded files
- release-machinery/ folder can be deleted & re-downloded
- release-machinery/ folder will be git versioned
- release-machinery/Dockerfile.main acts as the entry point similar to main file
- release-machinery/Dockerfile.main has the blueprint for the workflow
- build-inputs/ will hold the config overrides # API
- ci/ will hold the final artifacts # API
- ci/Dockerfile, ci/.env, ci/build.config, ci/lever.yaml, ci/jenkinsfile
- Run 'docker build -f release-machinery/Dockerfile.main' to generate ci/ artifacts
```
