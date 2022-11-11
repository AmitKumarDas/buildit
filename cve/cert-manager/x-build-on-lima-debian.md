## 11 Nov 2022

- RUN:
  - Setup steps at ../env/lima-debian.md
- RUN (inside debian shell):
  - lsb_release -a # gives the debian version 
  - sudo apt install git
  - git version
  - curl version
  - sudo apt install make
  - sudo apt install jq
- RUN (outside Lima shell):
  - git clone git@github.com:cert-manager/cert-manager.git
- RUN (inside Lima shell):
  - cd cert-manager
  - make help
```shell
make/tools.mk:411: *** Missing required tools: go (or run 'make vendor-go') docker (or set CTR to a docker-compatible tool).  Stop.
```

### Install Go on Debian (on Lima)
- REFER: https://www.digitalocean.com/community/tutorials/how-to-install-go-on-debian-10
- RUN:
  - sudo apt update
- RUN (outside of Lima shell):
  - curl -O https://dl.google.com/go/go1.19.3.linux-amd64.tar.gz
- RUN (inside Lima shell):
  - sudo rm -rf /usr/local/go
  - sudo tar -C /usr/local -xzf go1.19.3.linux-amd64.tar.gz
  - echo $PATH
  - export PATH=$PATH:/usr/local/go/bin
  - echo $PATH
  - source $HOME/.profile
  - go
```shell
bash: /usr/local/go/bin/go: cannot execute binary file: Exec format error
```


### Install Docker on Debian (on Lima)
- REFER: https://docs.docker.com/engine/install/debian/
- RUN:
  - sudo apt-get remove docker docker-engine docker.io containerd runc
  - **1/ Setup Repository**:
    - sudo apt-get update
    - sudo apt-get install ca-certificates curl gnupg lsb-release
    - sudo mkdir -p /etc/apt/keyrings
    - curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    - echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  - **2/ Install Docker Engine**:
    - sudo apt-get update
    - sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
    - sudo docker run hello-world
