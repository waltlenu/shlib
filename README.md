# shlib

A shell library of reusable Bash functions.

## Installation

Clone the repository:

```bash
git clone https://github.com/waltlenu/shlib.git
```

## Usage

Source the library in your script:

```bash
#!/usr/bin/env bash
source /path/to/shlib/lib/shlib.sh

# Use library functions
shlib::info "Hello from shlib!"
```

## Available Functions

### Core

- `shlib::version` - Print the library version
- `shlib::command_exists <cmd>` - Check if a command exists
- `shlib::error <message>` - Print an error message to stderr
- `shlib::warn <message>` - Print a warning message to stderr
- `shlib::info <message>` - Print an info message

## Adding New Functions

Add functions to `lib/shlib.sh` using the `shlib::` namespace prefix:

```bash
shlib::my_function() {
    # implementation
}
```

## Running Tests

This project uses [Bats](https://github.com/bats-core/bats-core) for testing.

### Install Bats

```bash
# macOS
brew install bats-core

# Ubuntu/Debian
apt install bats

# Or clone directly
git clone https://github.com/bats-core/bats-core.git
```

### Run Tests

```bash
bats tests/
```

## Documentation

View the man page:

```bash
man man/shlib.7
```

## Project Structure

```
shlib/
├── lib/
│   └── shlib.sh          # The library
├── man/
│   └── shlib.7           # Man page
├── tests/                 # Bats test files
├── examples/              # Usage examples
└── README.md
```

## License

MIT License - see [LICENSE](LICENSE) for details.
