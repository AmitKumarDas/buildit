### https://iximiuz.com/en/posts/containers-distroless-images/

- It's 10 times bigger than distroless/static (but still just ~20MB)
- It has two layers (and the first layer is `distroless/static`)
- The second layer brings tons of shared libraries - most notably libc and openssl
- Again, no typical Linux distro fluff
- For Go with CGO enabled
- Rust has a runtime dependency on libgcc, and may not work here
