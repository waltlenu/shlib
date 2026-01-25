#!/usr/bin/env bash
#
# Example: Core functions from shlib
#

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source the library
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../shlib.sh"

shlib::headern "Core Functions"

# Print version
echo "shlib::version: $(shlib::version)"
echo

# List all library functions
echo "shlib::list_functions (first 10):"
shlib::list_functions | head -10
echo "... ($(shlib::list_functions | wc -l | tr -d ' ') total functions)"
echo

# List all library variables
echo "shlib::list_variables:"
shlib::list_variables
