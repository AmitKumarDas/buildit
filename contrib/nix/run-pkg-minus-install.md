## Motivation
If I want to run a program, I don’t have to install it. I can load a shell with that program.

## Steps
- Running an arbitrary program with nix-shell
- nix-shell does two things
  - It will read an environment specification from a file named shell.nix 
  - & load up a bash shell (which you can override) with that environment present
  - Or it will do the same thing with a list of packages supplied on the command line
- I want to run the cowsay program
  - I **do not** have to install it
  - I can **load a shell with that program**
```shell
nix-shell -p cowsay

these 3 paths will be fetched (7.77 MiB download, 48.88 MiB unpacked):
  /nix/store/14m63w3bn8x8z9bymr38as22br8wkviy-libxcrypt-4.4.28
  /nix/store/6dvzqz0qs46sv6vqcndklxzwvkj5xa5d-cowsay-3.04
  /nix/store/v829scv04fr41jwyirlyrj2pjcpqxb6a-perl-5.36.0
copying path '/nix/store/14m63w3bn8x8z9bymr38as22br8wkviy-libxcrypt-4.4.28' from 'https://cache.nixos.org'...
copying path '/nix/store/v829scv04fr41jwyirlyrj2pjcpqxb6a-perl-5.36.0' from 'https://cache.nixos.org'...
copying path '/nix/store/6dvzqz0qs46sv6vqcndklxzwvkj5xa5d-cowsay-3.04' from 'https://cache.nixos.org'...
```
```shell
[nix-shell:~/work/buildit]$ cowsay hello
 _______ 
< hello >
 ------- 
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

## 🤩 Takeaways 🤩
- `nix-shell -p cowsay`
  - It downloads cowsay from the nixpkgs package repository
  - It then launches a bash shell with that program available, by adding it to the PATH

- Run
  - nix-shell -p python3 -p nodejs-10_x
  - python --version
  - node --version

- echo $PATH from inside the nix-shell
  - search if your desired program from its output
  - you may see a lot of extra packages as well

- The long string of numbers & letters
  - It's a hash of all the inputs
  - which means that if one of the dependencies change, the hash will change too

- Exit from nix-shell by typing `exit` & hit enter


## Reference
- https://monospacedmonologues.com/2022/06/throwaway-development-environments-with-nix/