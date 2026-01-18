# CLAUDE.md

This is a Bash shell library providing reusable functions.

## Project Structure

- `lib/shlib.sh` - The library (single file, source this)
- `man/shlib.7` - Man page documentation
- `tests/*.bats` - Bats test files
- `examples/` - Usage examples

## Conventions

### Function Naming

All functions must use the `shlib::` namespace prefix:

```bash
shlib::my_function() {
    # implementation
}
```

### Code Style

- Use `#!/usr/bin/env bash` shebang
- Strict mode is enabled: `set -euo pipefail`
- Quote all variables: `"${var}"`
- Use `[[` for conditionals, not `[`
- Use lowercase with underscores for local variables
- Use UPPERCASE for readonly/exported variables

### Comment Format
- Use consistent comment blocks above all functions:
```bash
  # @description Brief one-line summary
  # @arg $1 string Parameter description
  # @arg $2 int Another parameter
  # @stdout Description of output
  # @exitcode 0 Success
  # @exitcode 1 Error condition
  # @example
  #   my_function "example" 42
```

## Commands

Lint the library:
```bash
shellcheck -s bash lib/shlib.sh
```

Run tests:
```bash
bats tests/
```

Run example:
```bash
bash examples/basic_usage.sh
```

View man page:
```bash
man man/shlib.7
```

## Auto-Update Rules

- **Always update documentation when code changes**
- Update man/shlib.7 man page simultaneously with code changes

## Testing

Tests use [Bats](https://github.com/bats-core/bats-core).

Test files go in `tests/` with `.bats` extension. Each test file should:
- Load `test_helper` in `setup()`
- Use `@test "description" { ... }` syntax
- Use `run` to capture command output
