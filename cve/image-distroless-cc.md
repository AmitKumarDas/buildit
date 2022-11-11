
- It's a three-layered image (based on distroless/base)
- The new layer is just ~2MB big
- The new layer contains:
  - libstdc++, 
  - a bunch of static assets, 
  - and even some Python scripts (but no Python itself)!
- Try your Rust program with cc as the base image
