## https://opensource.com/article/18/10/podman-more-secure-way-run-containers

### Notes
- You can run Podman and containers as a non-root user
- This means you never have to give a user root privileges on the host
- While in the client/server model (like Docker employs)
  - You must open a socket to a privileged daemon running as root to launch the containers
  - There you are at the mercy of the security mechanisms implemented in the daemon 
  - Versus the security mechanisms implemented in the host operating systems

### SD_NOTIFY
- If you put a Podman command into a systemd unit file
- The container process can return notice up the stack through Podman
  - That the service is ready to receive tasks
  - This is something that can't be done in client/server mode

### Socket activation
- You can pass down connected sockets from systemd to Podman
- And onto the container process to use them
- This is impossible in the client/server model
