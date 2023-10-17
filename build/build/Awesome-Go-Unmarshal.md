### Shoutout
```yaml
- https://abhinavg.net/2021/02/24/flexible-yaml/
```

### Below YAML is possible! Surprising Yet True!
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

### Hows above done in gopkg.in/yaml.v3?
```go
// Instead of unmarshal function we start to make use of *yaml.Node
// yaml.Node in turn provides Decode function

type Unmarshaler interface {
  UnmarshalYAML(value *yaml.Node) error
}
```

```go
// Decode decodes the node and stores its data
// into the value pointed to by v.
func (*Node) Decode(interface{}) error
```

```diff
 func (u *User) UnmarshalYAML(
-  unmarshal func(interface{}) error,
+  value *yaml.Node,
 ) error {
   var name string
-  if err := unmarshal(&name); err == nil {
+  if err := value.Decode(&name); err == nil {
     ...
   }

   ...
-  if err := unmarshal((*rawUser)(u)); err != nil {
+  if err := value.Decode((*rawUser)(u)); err != nil {
     return err
   }
```

### How to achieve above in JSON
```go
type Unmarshaler interface {
  UnmarshalJSON([]byte) error
}
```

```go
func (u *User) UnmarshalJSON(data []byte) error {
  var name string
  if err := json.Unmarshal(data, &name); err == nil {
    // {"users": ["carol"]}
    u.Name = name
    return nil
  }

  // {"users": [{"name": "alice", "role": "admin"}]}
  type rawUser User
  if err := json.Unmarshal(data, (*rawUser)(u)); err != nil {
    return err
  }

  return nil
}
```

