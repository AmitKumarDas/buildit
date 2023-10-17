### Shoutout
```yaml
- https://abhinavg.net/2021/02/24/flexible-yaml/
```

### This is possible
```yaml
users:
  - name: alice 
    role: admin
  - bob 
  - carol
  - name: dave
    role: mod
```

```diff
 type Config struct {
-  Users []string `yaml:"users"`
+  Users []*User  `yaml:"users"`
 }
+
+type User struct {
+  Name string `yaml:"name"`
+  Role Role   `yaml:"role"`
+}
```

```go
// UnmarshalText specifies how to parse a Role from a string.
func (r *Role) UnmarshalText(bs []byte) error {
  switch string(bs) {
  case "user":
    *r = RoleUser
  case "mod":
    *r = RoleMod
  case "admin":
    *r = RoleAdmin
  default:
    return fmt.Errorf("unknown role %q", bs)
  }
  return nil
}
```

```go
func (u *User) UnmarshalYAML(
  unmarshal func(interface{}) error,
) error {
  var name string
  if err := unmarshal(&name); err == nil {
    // The old format was used. Only the name was specified.
    // For example,
    //
    // - bob
    //
    // Set just the name.
    u.Name = name
    return nil
  }

  // The new format was used. A full object was specified.
  // For example,
  //
  // - name: dave
  //   role: mod
  //
  // Decode the whole object.
  type rawUser User
  if err := unmarshal((*rawUser)(u)); err != nil {
    return err
  }

  // Nothing to do. (*rawUser)(u) above hydrated *u.
  return nil
}
```
