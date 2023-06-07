```diff
@@ https://github.com/jmgilman/dev-container/blob/master/Dockerfile @@
@@ Nix + Dockerfile + Scripting @@
```

```Dockerfile
# Create user
RUN groupadd -g ${GID} ${USER} && \
    useradd -u ${UID} -g ${GID} -G sudo -m ${USER} -s /bin/bash
COPY --from=base --chown=${USER}:${USER} /home/${USER} /home/${USER}
```

```Dockerfile
# Configure sudo and Nix
RUN sed -i 's/%sudo.*ALL/%sudo   ALL=(ALL:ALL) NOPASSWD:ALL/' /etc/sudoers && \
    echo "sandbox = false" > /etc/nix.conf && \
    echo "experimental-features = nix-command flakes" >> /etc/nix.conf
```

```Dockerfile
# Copy configs
COPY --chown=${USER}:${USER} config/flake.nix /home/${USER}/myproj/flake.nix
COPY --chown=${USER}:${USER} config/flake.lock /home/${USER}/myproj/flake.lock
COPY --chown=${USER}:${USER} config/config.nix /home/${USER}/myproj/config.nix
```

