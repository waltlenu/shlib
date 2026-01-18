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

# @description Print the library version
# @stdout The version string
# @exitcode 0 Always succeeds
# @example
#   shlib::version
shlib::version() {
    echo "${SHLIB_VERSION}"
}

# @description Check if a command exists in PATH
# @arg $1 string The command name to check
# @exitcode 0 Command exists
# @exitcode 1 Command not found
# @example
#   shlib::command_exists git
shlib::command_exists() {
    command -v "$1" &>/dev/null
}

#
# Logging Functions
#

# @description Print an error message to stderr (without newline)
# @arg $@ string The error message to print
# @stderr The message prefixed with "error: "
# @exitcode 0 Always succeeds
# @example
#   shlib::error "Something went wrong"
shlib::error() {
    echo -n "error: $*" >&2
}

# @description Print a warning message to stdout (without newline)
# @arg $@ string The warning message to print
# @stdout The message prefixed with "warning: "
# @exitcode 0 Always succeeds
# @example
#   shlib::warn "This might cause issues"
shlib::warn() {
    echo -n "warning: $*"
}

# @description Print an info message to stdout (without newline)
# @arg $@ string The info message to print
# @stdout The message prefixed with "info: "
# @exitcode 0 Always succeeds
# @example
#   shlib::info "Processing file"
shlib::info() {
    echo -n "info: $*"
}

# @description Print an error message to stderr (with newline)
# @arg $@ string The error message to print
# @stderr The message prefixed with "error: " followed by newline
# @exitcode 0 Always succeeds
# @example
#   shlib::errorn "Something went wrong"
shlib::errorn() {
    echo "error: $*" >&2
}

# @description Print a warning message to stdout (with newline)
# @arg $@ string The warning message to print
# @stdout The message prefixed with "warning: " followed by newline
# @exitcode 0 Always succeeds
# @example
#   shlib::warnn "This might cause issues"
shlib::warnn() {
    echo "warning: $*"
}

# @description Print an info message to stdout (with newline)
# @arg $@ string The info message to print
# @stdout The message prefixed with "info: " followed by newline
# @exitcode 0 Always succeeds
# @example
#   shlib::infon "Processing complete"
shlib::infon() {
    echo "info: $*"
}
