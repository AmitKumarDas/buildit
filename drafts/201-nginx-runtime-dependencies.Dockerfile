# Use nix as the builder
FROM nixos/nix:latest AS builder

# Update the channel so we can get the latest packages
RUN nix-channel --update nixpkgs

WORKDIR /app

# Now that our code is here we actually build it
RUN nix-build -A nginx '<nixpkgs>'

# Copy all the run time dependencies into /tmp/nix-store-closure
RUN mkdir /tmp/nix-store-closure
RUN echo "[Runtime-Dependencies]: " $(nix-store -qR result/) | tr " " "\n"
RUN cp -R $(nix-store -qR result/) /tmp/nix-store-closure

ENTRYPOINT [ "/bin/sh" ]

# Our production stage
FROM scratch
WORKDIR /app
# Copy the runtime dependencies into /nix/store
# Note we don't actually have nix installed on this container. But that's fine,
# we don't need it, the built code only relies on the given files existing, not
# Nix.
COPY --from=builder /tmp/nix-store-closure /nix/store
