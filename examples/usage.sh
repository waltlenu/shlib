#!/usr/bin/env bash

#
# Example: Run all shlib examples
#
# Individual example scripts:
#   - core.sh     Core functions (version, list_functions, list_variables)
#   - exec.sh     Execution functions (command_exists)
#   - logging.sh  Logging functions (simple, colorized, emoji)
#   - strings.sh  String manipulation functions
#   - arrays.sh   Array functions
#   - kv.sh       Key-value (associative array) functions (requires bash 4+)
#   - ui.sh       UI functions (headers, hr, status, spinner, ANSI)

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source the library
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../shlib.sh"

shlib::headern "shlib Examples"
echo "Version: $(shlib::version)"
echo

# Run all example scripts
scripts=(
    "core.sh"
    "exec.sh"
    "logging.sh"
    "strings.sh"
    "arrays.sh"
    "kv.sh"
    "ui.sh"
)

for script in "${scripts[@]}"; do
    shlib::hrn "$script" 60 "="
    # shellcheck disable=SC1090
    source "${SCRIPT_DIR}/${script}"
    echo
done

shlib::einfon "All examples completed!"
