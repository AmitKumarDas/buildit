## Lima
### Setup
- RUN:
  - git clone git@github.com:lima-vm/lima.git
  - cd lima/examples
  - limactl start debian.yaml
```shell
INFO[0002] Attempting to download the image from "https://cloud.debian.org/images/cloud/bullseye/20221020-1174/debian-11-generic-arm64-20221020-1174.qcow2"  digest="sha512:bd1e3b95e589df3ec8f869a9e7d14bbd2f64f479e52c0e93c7c3e6576177a0796c17c5b4775086215163b5427c2a77bf7816ffad012aeab11bfdb813f11ed467"
INFO[0073] Downloaded the nerdctl archive from "https://github.com/containerd/nerdctl/releases/download/v0.23.0/nerdctl-full-0.23.0-linux-arm64.tar.gz" 
INFO[0075] [hostagent] Starting QEMU (hint: to watch the boot progress, see "/Users/amitd2/.lima/debian/serial.log") 
INFO[0075] SSH Local Port: 50389                        
INFO[0075] [hostagent] Waiting for the essential requirement 1 of 5: "ssh" 
INFO[0085] [hostagent] Waiting for the essential requirement 1 of 5: "ssh" 
INFO[0085] [hostagent] The essential requirement 1 of 5 is satisfied 
INFO[0085] [hostagent] Waiting for the essential requirement 2 of 5: "user session is ready for ssh" 
INFO[0085] [hostagent] The essential requirement 2 of 5 is satisfied 
INFO[0085] [hostagent] Waiting for the essential requirement 3 of 5: "sshfs binary to be installed" 
INFO[0085] [hostagent] The essential requirement 3 of 5 is satisfied 
INFO[0085] [hostagent] Waiting for the essential requirement 4 of 5: "/etc/fuse.conf (/etc/fuse3.conf) to contain \"user_allow_other\"" 
INFO[0093] [hostagent] The essential requirement 4 of 5 is satisfied 
INFO[0093] [hostagent] Waiting for the essential requirement 5 of 5: "the guest agent to be running" 
INFO[0094] [hostagent] The essential requirement 5 of 5 is satisfied 
INFO[0094] [hostagent] Mounting "/Users/amitd2" on "/Users/amitd2" 
INFO[0094] [hostagent] Mounting "/tmp/lima" on "/tmp/lima" 
INFO[0094] [hostagent] Waiting for the optional requirement 1 of 2: "systemd must be available" 
INFO[0094] [hostagent] Forwarding "/run/lima-guestagent.sock" (guest) to "/Users/amitd2/.lima/debian/ga.sock" (host) 
INFO[0094] [hostagent] The optional requirement 1 of 2 is satisfied 
INFO[0094] [hostagent] Not forwarding TCP 0.0.0.0:22    
INFO[0094] [hostagent] Waiting for the optional requirement 2 of 2: "containerd binaries to be installed" 
INFO[0094] [hostagent] Not forwarding TCP [::]:22       
INFO[0097] [hostagent] The optional requirement 2 of 2 is satisfied 
INFO[0097] [hostagent] Waiting for the final requirement 1 of 1: "boot scripts must have finished" 
INFO[0109] [hostagent] The final requirement 1 of 1 is satisfied 
INFO[0109] READY. Run `limactl shell debian` to open the shell. 
amitd2@amitd2-a01 examples % limactl shell debian
```
  - limactl shell debian

## Teardown
- RUN:
  - exit
  - limactl stop debian
- 