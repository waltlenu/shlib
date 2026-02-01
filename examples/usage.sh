#!/usr/bin/env bash

#
# Example: Run all shlib examples
#
# Individual example scripts:
#   - core.sh     Core functions (version, list_functions, list_variables)
#   - arrays.sh   Array functions
#   - kv.sh       Key-value
#   - logging.sh  Logging functions
#   - strings.sh  String manipulation functions
#   - sys.sh      System functions
#   - ui.sh       UI functions

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source the library
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../shlib.sh"

shlib::banner_toilet "shlib" "" "gay"

shlib::headern "shlib Examples"
echo

# Run all example scripts
scripts=(
    "core.sh"
    "arrays.sh"
    "dt.sh"
    "kv.sh"
    "logging.sh"
    "strings.sh"
    "sys.sh"
    "ui.sh"
)

for script in "${scripts[@]}"; do
    shlib::hrn "$script" 60 "="
    # shellcheck disable=SC1090
    source "${SCRIPT_DIR}/${script}"
    echo
done

shlib::einfon "All examples completed!"
