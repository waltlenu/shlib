#!/usr/bin/env bash
#
# shlib - A shell library of reusable functions
#
# Usage:
#   source /path/to/shlib/lib/shlib.sh
#

# Prevent double-sourcing
[[ -n "${SHLIB_LOADED:-}" ]] && return 0
readonly SHLIB_LOADED=1

# Library version
readonly SHLIB_VERSION="0.1.0"

# Detect library directory
# shellcheck disable=SC2034,SC2155
readonly SHLIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Enable strict mode (can be disabled by the caller if needed)
set -euo pipefail

#
# Core Functions
#

# Print the library version
shlib::version() {
    echo "${SHLIB_VERSION}"
}

# Check if a command exists
shlib::command_exists() {
    command -v "$1" &>/dev/null
}

# Print an error message to stderr
shlib::error() {
    echo "error: $*" >&2
}

# Print a warning message to stderr
shlib::warn() {
    echo "warning: $*" >&2
}

# Print an info message
shlib::info() {
    echo "info: $*"
}
