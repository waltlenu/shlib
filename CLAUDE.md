# CLAUDE.md

A Bash shell library providing reusable functions, assembled from modular source fragments.

## Architecture

Source fragments in `src/` are assembled into output files via Go templates and the `hack/render.go` CLI tool. **Never edit the generated output files directly** — edit the source fragments in `src/`, then run `make build`.

Generated output files (committed to git so users can source without needing Go):

| Output file | Source extension | Template | Description |
|---|---|---|---|
| `shlib.bash` | `.bash` | `tmpl/shlib.bash.gotmpl` | The library |
| `shlib.bats` | `.bats` | `tmpl/shlib.bats.gotmpl` | Bats tests |
| `shlib.example.bash` | `.sh` | `tmpl/shlib.example.bash.gotmpl` | Usage examples |
| `shlib.7` | `.bash` comments | `tmpl/shlib.7.gotmpl` | Man page (auto-generated from `@description` comment blocks via `shdoc`) |

## Project Structure

```
src/
├── header.bash / .bats / .sh / .man   <- Preambles for each output type
├── footer.bash / .bats / .sh / .man   <- Footers for each output type
├── _core/                              <- Core functions (sorts first)
│   ├── version.bash                    <- Implementation (one file per function)
│   ├── version.bats                    <- Tests
│   └── version.sh                      <- Example usage
├── arrays/                             <- Section directories (auto-discovered)
│   ├── push.bash
│   ├── push.bats
│   └── push.sh
├── logging/
├── strings/
└── ...
tmpl/                                   <- Go template files
hack/render.go                          <- Template renderer CLI (stdlib only)
```

Sections are auto-discovered by globbing `src/*/*.EXT` — adding a new directory with the right file extensions is enough.  `_core/` sorts first due to the underscore prefix; all other sections sort alphabetically.

## Adding a New Function

1. Create the source files in `src/<section>/`:
   - `src/<section>/<function>.bash` — Implementation (with `@description` comment block)
   - `src/<section>/<function>.bats` — Tests
   - `src/<section>/<function>.sh` — Example usage
   - No `.man` file needed — the man page is auto-generated from the `@description`/`@arg`/`@exitcode`/`@example` comment block in the `.bash` file
2. Run `make build` to regenerate all output files
3. Run `make all` to verify (lint + format + test)

To add a new section, create a new directory under `src/` — no template changes needed.

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
- Use pure bash whenever possible
- Must support bash version 3
- Quote all variables: `"${var}"`
- Use `[[` for conditionals, not `[`
- Use lowercase with underscores for local variables
- Use UPPERCASE for readonly/exported variables

### Comment Format

Use consistent comment blocks above all functions:

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

Build (assemble output files from src/ fragments):
```bash
make build
```

Run all checks (build + lint + format + test):
```bash
make all
```

Format codebase:
```bash
shfmt -w -i 4 -ci -bn shlib.bash
```

Lint the library:
```bash
shellcheck -s bash shlib.bash
```

Run tests:
```bash
bats shlib.bats
```

View man page:
```bash
man ./shlib.7
```

Run Go render tool tests:
```bash
go test ./hack/ -v
```

## Rules

- **Always edit `src/` fragments, never the generated output files**
- **Always run `make build` after changing source fragments**
- When adding or modifying a function, update all three file types (.bash, .bats, .sh)
- The man page is auto-generated from the structured comment block in the `.bash` file — keep comments accurate
- Always format code with shfmt
- The `src/header.man` and `src/footer.man` are hand-written troff for the top/bottom of the man page

## Testing

Tests use [Bats](https://github.com/bats-core/bats-core). Test fragments go in `src/<section>/<function>.bats` and are assembled into `shlib.bats`.
