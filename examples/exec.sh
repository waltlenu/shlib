#!/usr/bin/env bash
#
# Example: Execution functions from shlib
#

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source the library
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../shlib.sh"

shlib::headern "Command Execution Functions"

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
