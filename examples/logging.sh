#!/usr/bin/env bash
#
# Example: Logging functions from shlib
#

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source the library
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../shlib.sh"

#
# Simple Logging Functions
#
shlib::headern "Simple Logging Functions"

# With newline
shlib::infon "This is an info message (with newline)"
shlib::warnn "This is a warning message (with newline)"
shlib::errorn "This is an error message (with newline)"

# Without newline (need to add our own)
shlib::info "This is an info message (no newline)"
echo " <- manually added newline"
shlib::warn "This is a warning message (no newline)"
echo " <- manually added newline"
shlib::error "This is an error message (no newline)"
echo " <- manually added newline" >&2
echo

#
# Colorized Logging Functions
#
shlib::headern "Colorized Logging Functions"

# With newline
shlib::cinfon "This is a colorized info message (with newline)"
shlib::cwarnn "This is a colorized warning message (with newline)"
shlib::cerrorn "This is a colorized error message (with newline)"

# Without newline
shlib::cinfo "Colorized info (no newline)"
echo " <- added newline"
shlib::cwarn "Colorized warning (no newline)"
echo " <- added newline"
shlib::cerror "Colorized error (no newline)"
echo " <- added newline" >&2
echo

#
# Emoji Logging Functions
#
shlib::headern "Emoji Logging Functions"

# With newline
shlib::einfon "This is an emoji info message (with newline)"
shlib::ewarnn "This is an emoji warning message (with newline)"
shlib::eerrorn "This is an emoji error message (with newline)"

# Without newline
shlib::einfo "Emoji info (no newline)"
echo " <- added newline"
shlib::ewarn "Emoji warning (no newline)"
echo " <- added newline"
shlib::eerror "Emoji error (no newline)"
echo " <- added newline" >&2
