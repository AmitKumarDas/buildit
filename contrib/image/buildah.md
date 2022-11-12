## https://mkdev.me/posts/dockerless-part-2-how-to-build-container-image-for-rails-application-without-docker-and-dockerfile

### WHAT
- Buildah is a container image builder tool, that produces OCI-compliant images
- It is distributed as a single binary and is written in Go

### WHY
- Buildah can only be used to manipulate images
  - i.e. Build & Push
- No daemon is involved
- No need of root privileges to build image
  - Unlike Docker that requires you to be member of the docker group in order to use it
  - Buildah & Podman can be run by an un-priviledged user 
  - Without the need of being member of groups
  - & therefore provide a much safer alternative
- Can use shell scripts instead of Dockerfile to build image
- Building multi arch images is great with Buildah

### USE
- Handy tool in CI CD
- Build container images inside K8s
- The equivalent of `docker build` to build an image with Buildah is `buildah bud`

### Why shellscript can be a better alternative than Dockerfile
- We can mount the complete container filesystem inside-of the build server 
- & manipulate it directly from the host with the tools installed on the host
- It is useful when we don't want to install tools inside the image to do build-time manipulations
- However, this kind of ruins the portability of your build script
- Well use Nix along with this shell script 💡 🥸

### Technical
- Buildah does run containers
- It provides no way to do it in a way that would be useful for anything but building images
- Buildah is not a replacement for container engine
- It only gives you some primitives to debug the process of building an image!

### Build From Scratch
- https://youtu.be/iI7fqwNRa0Q?t=1290
- https://gitlab.com/buzzcrate/bookdemo/-/blob/main/.gitlab-ci.yml

### References
- https://tensor5.dev/reproducible-container-images/
