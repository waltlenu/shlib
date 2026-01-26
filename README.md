# shlib

[![CI](https://github.com/waltlenu/shlib/actions/workflows/ci.yml/badge.svg)](https://github.com/waltlenu/shlib/actions/workflows/ci.yml)

A library of reusable [Bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) shell functions.

- Just [one file](shlib.sh), (but a long one 😜), easy to download and source
- Pure Bash whenever possible:
  - Idiomatic
  - No external binaries
  - Requires Bash >= 3.x because that's what MacOS ships with (the last version released under GPL2)
- Won't pollute the environment
  - Every function is "name-spaced" by prefixing it with `shlib::`
  - Every global variable is "name-spaced" by prefixing it with `SHLIB_`
- Strict mode (`set -euo pipefail`) enabled
- Fully tested with [bats](https://github.com/bats-core/bats-core)
- Statically analysed with [ShellCheck](https://github.com/koalaman/shellcheck)
- Yes, I let [Claude Code](CLAUDE.md) assist me but I watch it with suspicion 👹

## Usage

_Don't just "curl bash pipe it"_

⚠️ First, **please read** the [code](shlib.sh). At least the top of the file, where all the global instructions/variables are located. The rest of the file is made up Bash function definitions. Everything _should_ be inoffensive because I don't want errors in my own scripts, but don't take my word for it.

I recommend downloading the latest [released](https://github.com/waltlenu/shlib/releases) version of this library and source in your Bash script:

```bash
#!/usr/bin/env bash

REMOTE='waltlenu/shlib'
LATEST_TAG=$(curl -sL "https://api.github.com/repos/$REMOTE/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
curl -fsSL --remote-name "https://raw.githubusercontent.com/$REMOTE/refs/tags/$LATEST_TAG/shlib.sh"

# Load library
source shlib.sh

# Use library functions
shlib::einfon "Hello 🌍"
```

But if you prefer the very latest, or just copy a function, go ahead.

## Examples

Try running the [examples/usage.sh][examples/usage.sh] script. The `shlib::ansi_` function print pretty colors 😀

## Documentation

View the man page(s):

```bash
man man/shlib.7
```

## Contributing

### Project Structure

```text
shlib/
├── shlib.sh     # THE library
├── man/         # Man pages
├── tests/       # Bats test files
├── examples/    # Usage examples
└── README.md    # This file (!)
```

### Adding New Functions

Insert/Append functions to `shlib.sh` making sure you add the `shlib::` namespace prefix:

```bash
shlib::my_function() {
    # implementation
}
```

### Linting and formatting

This project uses [ShellCheck](https://github.com/koalaman/shellcheck) for linting, [shfmt](https://github.com/patrickvane/shfmt) for formatting:

```bash
shellcheck -s bash shlib.sh
```

### Testing

This project uses [Bats](https://github.com/bats-core/bats-core) for testing.

```bash
bats tests/
```

## License

MIT License - see [LICENSE](LICENSE) for details.
