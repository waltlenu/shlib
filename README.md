# shlib

[![CI](https://github.com/waltlenu/shlib/actions/workflows/ci.yml/badge.svg)](https://github.com/waltlenu/shlib/actions/workflows/ci.yml)

A shell library of reusable Bash functions.

## Installation

Clone the repository:

```bash
git clone https://github.com/waltlenu/shlib.git
```

## Documentation

View the man page:

```bash
man man/shlib.7
```

## Usage

Source the library in your script:

```bash
#!/usr/bin/env bash
source /path/to/shlib/shlib.sh

# Use library functions
shlib::einfon "Hello 🌍"
```

## Contributing

### Project Structure

```
shlib/
├── shlib.sh     # The library
├── man/         # Man pages
├── tests/       # Bats test files
├── examples/    # Usage examples
└── README.md    # This file (!)
```

### Adding New Functions

Add functions to `shlib.sh` using the `shlib::` namespace prefix:

```bash
shlib::my_function() {
    # implementation
}
```

### Linting

This project uses [ShellCheck](https://github.com/koalaman/shellcheck) for linting.

```bash
shellcheck -s bash tests/
```

### Testing

This project uses [Bats](https://github.com/bats-core/bats-core) for testing.

```bash
bats tests/
```

## License

MIT License - see [LICENSE](LICENSE) for details.
