#!/usr/bin/env bash
#
# Example: Basic usage of shlib
#

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source the library
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../shlib.sh"

# Print version
echo "shlib version: $(shlib::version)"
echo

# Using logging functions
shlib::headern "Logging functions"
shlib::infon "This is an informational message"
shlib::warnn "This is a warning message"
shlib::errorn "This is an error message"
echo

# Using colorised logging functions
shlib::headern "Colorised Logging functions"
shlib::cinfon "This is an informational message"
shlib::cwarnn "This is a warning message"
shlib::cerrorn "This is an error message"
echo

# Using emoji logging functions
shlib::headern "Emoji Logging functions"
shlib::einfon "This is an informational message"
shlib::ewarnn "This is a warning message"
shlib::eerrorn "This is an error message"
echo

# Check for commands
if shlib::command_exists git; then
    shlib::cinfon "git is installed"
else
    shlib::cwarnn "git is not installed"
fi

if shlib::command_exists nonexistent_cmd; then
    shlib::cinfon "nonexistent_cmd is installed"
else
    shlib::cwarnn "nonexistent_cmd is not installed (expected)"
fi
