## Usage
- Navigate to this folder
- Run
  - `nix-shell`
- Once its successful you will be inside the shell
- Run
  - `nix-env --list-generations`
  - `nix-env -q --out-path`
  - `python -c 'import numpy as np; print(np.arange(15, dtype=np.int64).reshape(3, 5))'`
  - `exit`
