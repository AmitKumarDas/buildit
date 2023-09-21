```yaml
- # Parallel, Build, Performance, Goroutines, Tasks
- https://pkg.go.dev/golang.org/x/sync/errgroup


# Profile Guided Optimisation
- https://theyahya.com/posts/go-pgo/


 # BUILDER # JOIN
- https://hackernoon.com/go-design-patterns-an-introduction-to-builder


- # Functional
- https://github.com/IBM/fp-go
- https://github.com/logic-building/functional-go
- https://github.com/repeale/fp-go
- https://github.com/antonmedv/expr


- # Discussions
- https://github.com/golang/go/issues/42088 # go run executable for module mode
 - https://github.com/golang/go/issues/42088#issuecomment-747048756
 - https://github.com/golang/go/issues/42088#issuecomment-755490047

- # Idea: Developer Environments @ 21 Sep 2023
- devenvs/my_cli.go & devenvs/Dockerfile.my_cli.tpl
 - # Generate a Dockerfile that INSTALL or RUN specific version of my_cli
 - # Generate the Dockerfile by embedding the Dockerfile.my_cli.tpl
 - # Generate is a PUBLIC function that can be IMPORTED by other go projects
 - # go install github.com/someone/project/cmd/my_cli@rev
 - # go run github.com/someone/project/cmd/my_cli@rev
 - # rev is a Dockerfile ARG that defaults to main
```

