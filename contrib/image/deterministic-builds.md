## https://tensor5.dev/reproducible-container-images/

### Use Hash
- FROM busybox
- FROM busybox:1.32.0
- Docker images are content addressable
  - i.e. we can target a specific image using a hash of its content
  - Hash, unlike the version tag, cannot be changed 
  - To find out what the hash of version 1.32.0 of the BusyBox image is, use `podman inspect`
  - `podman inspect busybox:1.32.0`
    - FROM busybox@sha256:400ee2ed939df769d4681023810d2e4fb9479b8401d97003c710d0e20f7c49c6

### Fix Timestamps
- Timestamps indeterminism occurs twice during the generation of a Docker image
- First when we `ADD` or `COPY` files to the image, those files get the timestamp of the moment they are copied
  - Same is true when we generate a file inside the Dockerfile using a `RUN` script
- Second, according to the specifications every image has a creation timestamp
- Fixing this indeterminism requires setting all timestamps to a predefined date
  - e.g. the zero Unix time 1970-01-01T00:00:00.000Z
  - It cannot be done using a Dockerfile instruction
  - But requires some low level commands provided by Buildah

#### buildah.sh
```shell
#!/bin/sh

# This sha corresponds to busybox:1.32.0
# Derive the sha by running `podman inspect busybox:1.32.0`
ctr=$(buildah from busybox@sha256:400ee2ed939df769d4681023810d2e4fb9479b8401d97003c710d0e20f7c49c6)

# Interact with the container as a mounted filesystem
mnt=$(buildah mount "$ctr")

# Copy the script.sh file and then we change its timestamp to zero using touch
cp script.sh "$mnt"
touch --date=@0 "$mnt/script.sh"
buildah umount "$ctr"

buildah config --entrypoint '["/script.sh"]' --cmd '' "$ctr"

# --omit-timestamp flag is necessary to set the image creation timestamp to zero as well
buildah commit --omit-timestamp "$ctr"
# Clean up by removing the temporary container
buildah rm "$ctr"
```

#### Notes
- buildah mount without root privileges requires **running** the whole script in a **simulated environment**
  - This is provided by buildah unshare
  - buildah unshare ./buildah.sh
- Run the above script as many time as you want, it will always produce tha same **bit-by-bit** image
- There is a little drawback in this process
  - All images have the same creation time
  - This can be particularly annoying in CI environments where we build a new image for each commit
  - To solve this problem we can tag each image with the Git commit hash it was built form
    - The commit hash provides a unique identifier
    - In addition, when someone runs a build at that particular commit, the same Docker image will be generated
