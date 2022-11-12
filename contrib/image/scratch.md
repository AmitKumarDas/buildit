### From https://iximiuz.com/en/posts/containers-distroless-images/

### Tread with care - Lots of Missing Stuff
- Missing Folders such as /tmp, /home, /var, etc.
- Missing CA certificates
- Missing timezone
- Missing user management

### No User Management
- The /etc/passwd and /etc/group files are missing in "from scratch" containers
```Dockerfile
FROM scratch

COPY <<EOF /etc/group
root:x:0:
nonroot:x:65532:
EOF

COPY <<EOF /etc/passwd
root:x:0:0:root:/root:/sbin/nologin
nonroot:x:65532:65532:nonroot:/home/nonroot:/sbin/nologin
EOF

COPY --from=builder /app/main /

CMD ["/main"]
```
- docker run --user root --rm scratch-current-user-fixed
- docker run --user nonroot --rm scratch-current-user-fixed
