#### Guix
```yaml
- https://elephly.net/posts/2015-06-21-getting-started-with-guix.html

- If you are using a 64 bit machine, download the compressed x86_64 archive from the FTP server
- ftp://alpha.gnu.org/gnu/guix/guix-binary-0.9.0.x86_64-linux.tar.xz
- Download the matching cryptographic signature file
- They all have the same name as the archive you downloaded, but end on .sig

- To ensure that the tarballs are signed by release managers
- Fetch both Ludo's and my own PGP key from PGP key servers
  - gpg2 --recv-keys 090b11993d9aebb5 197a5888235facac

- With these keys you can now check that the file you downloaded is in fact legit
- Run following command in the same directory that holds the tarball and the signature file
  - gpg2 --verify guix-binary-0.9.0.x86_64-linux.tar.xz.sig

- unpack the archive as root in the root directory:
  - cd /
  - tar xf guix-binary-0.9.0.SYSTEM.tar.xz
  - This creates:
    - a pre-populated store at /gnu/store
    - the local state directory /var/guix
    - a Guix profile for the root user at /root/.guix-profile (contains guix command line tools & the daemon)

- Create restricted user accounts (used by the daemon) to build software in a controlled environment
- You may not need ten, but it’s a good default

```

#### Building Secure Supply Chain with GNU Guix
```yaml
- https://arxiv.org/pdf/2206.14606v1.pdf
```
```yaml
- a model and tool to authenticate new Git revisions
- Git checkout authentication is applicable beyond the specific use case of Guix

- Focuses on attestation—certifying each link of the supply chain
- Enabling independent verification of each step
- Reproducible builds, “bootstrappable” builds, and Provenance Tracking

- Reproducible Deployment, Reproducible and Verifiable builds, and Provenance Tracking
```

```yaml
- guix install python # installs the Python interpreter
- guix pull # updates Guix itself and the set of available packages
- guix upgrade # upgrades previously-installed packages to their latest available version
- Package management is per-user rather than system-wide
- it does not require system administrator privileges, nor does it require mutual trust among users
```

```yaml
- guix shell # creates a one-off development environment containing the given packages
- guix pack # creates standalone application bundles or container images 
  - providing one or more software packages and all the packages they depend on at run time
  - The container images can be loaded by Docker, podman, and similar container tools
```

```yaml
- build processes as a set of pure functions
- given a set of inputs (compiler, libraries, build scripts, and so on)
- a package’s build function is assumed to always produce the same result
```

```yaml
- Guix, like Nix and unlike Debian or Fedora, is essentially a source-based distribution
```

```yaml
- guix build --check hello
  - # REBUILDS the hello package locally
  - # prints an ERROR if the build result DIFFERS from that already available
- guix challenge hello 
  - # COMPARES binaries of the hello package available LOCALLY 
  - # with those provided by one or several substitute servers

- These two commands allow users and developers to find about binaries that might have been tampered with
- For packagers, they are more commonly a way to find out about non-deterministic build processes
  — e.g., build processes that include timestamps or random seeds in their output
  - or that depend on hardware details
```

```yaml
- Bootstrappable Builds
- Are reproducible builds enough to guarantee that one can verify source-to-binary mappings?

- A legitimate-looking build process would produce a malicious binary
- If that build process is reproducible, it just reproducibly builds a malicious binary

- Trusting Trust Attack
  - Targets the compilation toolchain typically by modifying the compiler 
  - Such that it emits malicious code when it recognizes specific patterns of source code
  - This attack can be undetectable

- What makes such attacks possible?
  - Users and distributions rely on OPAQUE binaries at some level to BOOTSTRAP the entire package dependency graph
```

```yaml
- GNU/Linux systems are built around the C language
  - At the root of the package dependency graph:
  - We have the GNU C Library (glibc), 
  - the GNU Compiler Collection (GCC), 
  - the GNU Binary Utilities (Binutils), 
  - and the GNU command-line utilities (Coreutils, grep, sed, Findutils, etc.)
- All this written in C and C++

- How does one build the first GCC though? 
  - Historically, distributions such as Debian would informally rely on previously-built binaries 
  - To build the new ones: e.g. when GCC is upgraded
  - It is built using GCC as available in the previous version of the distribution
```

```yaml
- Issue That is No More

- The functional build model does not allow us to “cheat”
- The whole dependency graph has to be described and be self-contained
- Thus, it must describe how the first GCC and C library are obtained

- Initially, Guix relied on pre-built statically linked binaries 
- of GCC, Binutils, libc, & few others to get started
  - Even though these binary seeds were eventually built with Guix and
  - thus reproducible and verifiable using the same Guix revision
- They were around 250 MiB of OPAQUE, NON-AUDITABLE binaries
```

```yaml
- Distributing Updates Securely
- How can users know that updates to Guix and its package collection that they fetch are genuine?

- The problem of securing software updates 
- is often viewed through the lens of binary distributions such as Debian
- where the main asset to be protected are binaries themselves
- Guix being a source-based distribution, the question has to be approached from a different angle
```

```yaml
- in-toto framework
  - It focuses on Artifact FLOW Integrity
  - Artifacts created by a step cannot be ALTERED before the next step

- Guix has end-to-end control over artifact flow
- From source code to binaries delivered to users
- Complete Provenance Tracking: Enables one to VERIFY the Source-To-Binary mapping
- Or to simply not use the project’s official binaries

- in-toto’s approach to artifact flow integrity makes verification hard in the first place
- In a sense, in-toto addresses non-verifiability through attestation
- SLSA [23] and sigstore [20] take a similar approach, insisting on CERTIFICATION 
- Rather than allowing INDEPENDENT VERIFICATION of each step
```

