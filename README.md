# shlib

[![CI](https://github.com/waltlenu/shlib/actions/workflows/ci.yml/badge.svg)](https://github.com/waltlenu/shlib/actions/workflows/ci.yml)

A library of reusable [Bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) shell functions.

- Just [one file](shlib.bash), but a long one 😜 -> easy to download and source
- Pure Bash:
  - Idiomatic
  - No external binaries[^1]
  - Bash `>= 3.x`, or `4`[^2][^3]
- Won't pollute the environment
  - Every function is "name-spaced" by prefixing it with `shlib::`
  - Every global variable is "name-spaced" by prefixing it with `SHLIB_`
- Strict mode (`set -euo pipefail`) enabled
- Fully tested with [bats](https://github.com/bats-core/bats-core)
- Statically analysed with [ShellCheck](https://github.com/koalaman/shellcheck)
- Yes, I let [Claude Code](CLAUDE.md) assist me but I watch it with suspicion 👹

[^1]: Whenever possible
[^2]: There is a section called KV (Key Value) that implements associative arrays functions. It requires BASH v4.x+.
[^3]: Because that's what MacOS ships with (the last version released under GPL2)

## Usage

_**Don't** just "curl pipe bash it"_

⚠️ First, **please read** the [code](shlib.bash), at least the top of the file.

That's where all the global instructions/variables are located. The rest of the file is made up Bash function definitions. Everything _should_ be inoffensive because I don't want errors in my own scripts, but **don't** take my word for it.

I recommend downloading the latest [released](https://github.com/waltlenu/shlib/releases) version of this library and source in your Bash script:

```bash
#!/usr/bin/env bash

REMOTE='waltlenu/shlib'
LATEST_TAG=$(curl -sL "https://api.github.com/repos/$REMOTE/releases/latest" \
  | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
curl -fsSL --remote-name \
  "https://raw.githubusercontent.com/$REMOTE/refs/tags/$LATEST_TAG/shlib.bash"

# Load library
source shlib.bash

# Use library functions
shlib::einfon "Hello 🌍"
```

But if you prefer the very [latest](https://raw.githubusercontent.com/waltlenu/shlib/refs/heads/main/shlib.bash), or just copy a function, go ahead.

### Examples

Try running the [examples/usage.sh](examples/usage.sh) script. The `shlib::ansi_` functions print pretty colors 😀

### Documentation

Read the man page(s):

```bash
man ./shlib.7
```

## Contributing

### Project Structure

```text
shlib/
├── shlib.bash          # THE library
├── shlib.7             # Man page
├── shlib.bats          # Bats tests
├── shlib.example.bash  # Usage example
|
├── hack/               # Building scripts
├── src/                # Codebase fragments
└── tmpl/               # Template files
```

### Adding New Functions

Insert/Append functions to `shlib.bash` by adding files to `src/` and making sure you add the `shlib::` namespace prefix:

```bash
shlib::my_function() {
    # implementation
}
```

### Linting, formatting, testing

This project uses:
- [ShellCheck](https://github.com/koalaman/shellcheck) for static analysis
- [shfmt](https://github.com/patrickvane/shfmt) for formatting
- [Bats](https://github.com/bats-core/bats-core) for testing

```bash
make all

# or:
shellcheck -s bash shlib.bash
shfmt -i 4 -ci -bn shlib.bash
bats tests/
```

### TODO

Plenty of features still missing:

- [ ] ui: add a confirmation prompt
- [ ] sys: add functions like is_root
- [ ] make tmp file, dir
- [ ] random string functions

## License

MIT License - see [LICENSE](LICENSE) for details.
