#!/usr/bin/env bash
#
# Example: Basic usage of shlib
#

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source the library
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../lib/shlib.sh"

# Print version
echo "shlib version: $(shlib::version)"
echo

# Using logging functions
shlib::infon "This is an informational message"
shlib::warnn "This is a warning message"
shlib::errorn "This is an error message"
echo

# Using colorised logging functions
shlib::cinfon "This is an informational message"
shlib::cwarnn "This is a warning message"
shlib::cerrorn "This is an error message"
echo

# Check for commands
if shlib::command_exists git; then
    shlib::info "git is installed"
else
    shlib::warn "git is not installed"
fi

if shlib::command_exists nonexistent_cmd; then
    shlib::info "nonexistent_cmd is installed"
else
    shlib::info "nonexistent_cmd is not installed (expected)"
fi
