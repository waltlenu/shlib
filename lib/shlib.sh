#!/usr/bin/env bash
#
# shlib - A shell library of reusable functions
#
# Usage:
#   source /path/to/shlib/lib/shlib.sh
#

# Prevent double-sourcing
[[ -n "${SHLIB_LOADED:-}" ]] && return 0

# Require bash version 3 or higher
if [[ "${BASH_VERSINFO[0]}" -lt 3 ]]; then
    echo "shlib: requires bash version 3 or higher (found ${BASH_VERSION})" >&2
    return 1
fi

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
# Color Codes
#

# shellcheck disable=SC2034
readonly SHLIB_COLOR_RED='\033[0;31m'
# shellcheck disable=SC2034
readonly SHLIB_COLOR_YELLOW='\033[0;33m'
# shellcheck disable=SC2034
readonly SHLIB_COLOR_BLUE='\033[0;34m'
# shellcheck disable=SC2034
readonly SHLIB_COLOR_RESET='\033[0m'
# shellcheck disable=SC2034
readonly SHLIB_COLOR_BOLD='\033[1m'

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

#
# Colorized Logging Functions
#

# @description Print a colorized error message to stderr (without newline)
# @arg $@ string The error message to print
# @stderr The message prefixed with red "error: "
# @exitcode 0 Always succeeds
# @example
#   shlib::cerror "Something went wrong"
shlib::cerror() {
    echo -ne "${SHLIB_COLOR_RED}error:${SHLIB_COLOR_RESET} $*" >&2
}

# @description Print a colorized warning message to stdout (without newline)
# @arg $@ string The warning message to print
# @stdout The message prefixed with yellow "warning: "
# @exitcode 0 Always succeeds
# @example
#   shlib::cwarn "This might cause issues"
shlib::cwarn() {
    echo -ne "${SHLIB_COLOR_YELLOW}warning:${SHLIB_COLOR_RESET} $*"
}

# @description Print a colorized info message to stdout (without newline)
# @arg $@ string The info message to print
# @stdout The message prefixed with blue "info: "
# @exitcode 0 Always succeeds
# @example
#   shlib::cinfo "Processing file"
shlib::cinfo() {
    echo -ne "${SHLIB_COLOR_BLUE}info:${SHLIB_COLOR_RESET} $*"
}

# @description Print a colorized error message to stderr (with newline)
# @arg $@ string The error message to print
# @stderr The message prefixed with red "error: " followed by newline
# @exitcode 0 Always succeeds
# @example
#   shlib::cerrorn "Something went wrong"
shlib::cerrorn() {
    echo -e "${SHLIB_COLOR_RED}error:${SHLIB_COLOR_RESET} $*" >&2
}

# @description Print a colorized warning message to stdout (with newline)
# @arg $@ string The warning message to print
# @stdout The message prefixed with yellow "warning: " followed by newline
# @exitcode 0 Always succeeds
# @example
#   shlib::cwarnn "This might cause issues"
shlib::cwarnn() {
    echo -e "${SHLIB_COLOR_YELLOW}warning:${SHLIB_COLOR_RESET} $*"
}

# @description Print a colorized info message to stdout (with newline)
# @arg $@ string The info message to print
# @stdout The message prefixed with blue "info: " followed by newline
# @exitcode 0 Always succeeds
# @example
#   shlib::cinfon "Processing complete"
shlib::cinfon() {
    echo -e "${SHLIB_COLOR_BLUE}info:${SHLIB_COLOR_RESET} $*"
}

# @description Print a bold header message to stdout (without newline)
# @arg $@ string The header message to print
# @stdout The message in bold
# @exitcode 0 Always succeeds
# @example
#   shlib::header "Section Title"
shlib::header() {
    echo -ne "${SHLIB_COLOR_BOLD}$*${SHLIB_COLOR_RESET}"
}

# @description Print a bold header message to stdout (with newline)
# @arg $@ string The header message to print
# @stdout The message in bold followed by newline
# @exitcode 0 Always succeeds
# @example
#   shlib::headern "Section Title"
shlib::headern() {
    echo -e "${SHLIB_COLOR_BOLD}$*${SHLIB_COLOR_RESET}"
}

#
# Emoji Logging Functions
#

# @description Print an emoji error message to stderr (without newline)
# @arg $@ string The error message to print
# @stderr The message prefixed with "❌ "
# @exitcode 0 Always succeeds
# @example
#   shlib::eerror "Something went wrong"
shlib::eerror() {
    echo -n "❌ $*" >&2
}

# @description Print an emoji warning message to stdout (without newline)
# @arg $@ string The warning message to print
# @stdout The message prefixed with "⚠️ "
# @exitcode 0 Always succeeds
# @example
#   shlib::ewarn "This might cause issues"
shlib::ewarn() {
    echo -n "⚠️  $*"
}

# @description Print an emoji info message to stdout (without newline)
# @arg $@ string The info message to print
# @stdout The message prefixed with "ℹ️ "
# @exitcode 0 Always succeeds
# @example
#   shlib::einfo "Processing file"
shlib::einfo() {
    echo -n "ℹ️  $*"
}

# @description Print an emoji error message to stderr (with newline)
# @arg $@ string The error message to print
# @stderr The message prefixed with "❌ " followed by newline
# @exitcode 0 Always succeeds
# @example
#   shlib::eerrorn "Something went wrong"
shlib::eerrorn() {
    echo "❌ $*" >&2
}

# @description Print an emoji warning message to stdout (with newline)
# @arg $@ string The warning message to print
# @stdout The message prefixed with "⚠️ " followed by newline
# @exitcode 0 Always succeeds
# @example
#   shlib::ewarnn "This might cause issues"
shlib::ewarnn() {
    echo "⚠️  $*"
}

# @description Print an emoji info message to stdout (with newline)
# @arg $@ string The info message to print
# @stdout The message prefixed with "ℹ️ " followed by newline
# @exitcode 0 Always succeeds
# @example
#   shlib::einfon "Processing complete"
shlib::einfon() {
    echo "ℹ️  $*"
}

#
# String Manipulation Functions
#

# @description Remove leading and trailing whitespace from a string
# @arg $1 string The string to trim
# @stdout The trimmed string
# @exitcode 0 Always succeeds
# @example
#   shlib::str_trim "  hello world  "
shlib::str_trim() {
    local str="$1"
    str="${str#"${str%%[![:space:]]*}"}"
    str="${str%"${str##*[![:space:]]}"}"
    echo "$str"
}

# @description Remove leading whitespace from a string
# @arg $1 string The string to trim
# @stdout The string with leading whitespace removed
# @exitcode 0 Always succeeds
# @example
#   shlib::str_ltrim "  hello world"
shlib::str_ltrim() {
    local str="$1"
    echo "${str#"${str%%[![:space:]]*}"}"
}

# @description Remove trailing whitespace from a string
# @arg $1 string The string to trim
# @stdout The string with trailing whitespace removed
# @exitcode 0 Always succeeds
# @example
#   shlib::str_rtrim "hello world  "
shlib::str_rtrim() {
    local str="$1"
    echo "${str%"${str##*[![:space:]]}"}"
}

# @description Get the length of a string
# @arg $1 string The string to measure
# @stdout The length of the string
# @exitcode 0 Always succeeds
# @example
#   shlib::str_len "hello"
shlib::str_len() {
    echo "${#1}"
}

# @description Check if a string is empty or contains only whitespace
# @arg $1 string The string to check
# @exitcode 0 String is empty or whitespace only
# @exitcode 1 String contains non-whitespace characters
# @example
#   shlib::str_is_empty "   " && echo "empty"
shlib::str_is_empty() {
    local trimmed
    trimmed="${1#"${1%%[![:space:]]*}"}"
    trimmed="${trimmed%"${trimmed##*[![:space:]]}"}"
    [[ -z "$trimmed" ]]
}

# @description Convert a string to uppercase
# @arg $1 string The string to convert
# @stdout The uppercase string
# @exitcode 0 Always succeeds
# @example
#   shlib::str_to_upper "hello"
shlib::str_to_upper() {
    echo "$1" | tr '[:lower:]' '[:upper:]'
}

# @description Convert a string to lowercase
# @arg $1 string The string to convert
# @stdout The lowercase string
# @exitcode 0 Always succeeds
# @example
#   shlib::str_to_lower "HELLO"
shlib::str_to_lower() {
    echo "$1" | tr '[:upper:]' '[:lower:]'
}
