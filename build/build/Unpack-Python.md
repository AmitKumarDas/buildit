### Set | Map |  Filter | Exclude | Functional
```py
d = tomllib.loads(path.read_text('utf-8'))
dtool = d.get('tool', {}).get('flit', {})
unknown_sections = set(dtool) - {
  'metadata', 'module', 'scripts', 'entrypoints', 'sdist', 'external-data'
}
unknown_sections = [s for s in unknown_sections if not s.lower().startswith('x-')]
```

```py
if not set(md_sect).issuperset(metadata_required_fields):
  missing = metadata_required_fields - set(md_sect)
  raise ConfigError("Required fields missing: " + '\n'.join(missing))
```

### TOML & Type Checking
```yaml
- WHY: Parse &/ generate build provenance
- REFER: https://github.com/pypa/flit/blob/main/flit_core/flit_core/config.py
- TIL: Error Handling, Custom Error, Conditions, Parse Py Data Structure
- TIL: Map TYPES to TOML fields
```

