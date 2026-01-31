#!/usr/bin/env bash

#
# Example: UI functions from shlib
#

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source the library
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../shlib.sh"

shlib::headern "UI Functions"

#
# Header Functions
#
shlib::headern "Header Functions"
shlib::header "This is a header without newline"
echo " <- see?"
shlib::headern "This is a header with newline"
echo

#
# Horizontal Rules
#
shlib::headern "Horizontal Rules"
shlib::hrn
shlib::hrn "Section Title"
shlib::hrn "Custom" 30 "="
shlib::hrn "" 50 "─"
echo

#
# Status Indicators
#
shlib::headern "Status Indicators"
shlib::status_okn "Task completed successfully"
shlib::status_failn "Task failed with error"
shlib::status_pendingn "Task is pending..."
echo

#
# Spinner
#
shlib::headern "Spinner"
echo "Running a command with spinner..."
if shlib::spinner "Simulating work" sleep 3; then
    shlib::einfon "Command completed successfully"
else
    shlib::eerrorn "Command failed"
fi
echo

#
# ANSI Color Reference
#
shlib::headern "ANSI Color Reference"

echo "shlib::ansi_styles:"
shlib::ansi_styles
echo

echo "shlib::ansi_fg_colors:"
shlib::ansi_fg_colors
echo

echo "shlib::ansi_bg_colors:"
shlib::ansi_bg_colors
echo

echo "shlib::ansi_color_matrix:"
shlib::ansi_color_matrix
echo

echo "shlib::ansi_color_matrix_bright:"
shlib::ansi_color_matrix_bright
echo

echo "shlib::ansi_256_palette:"
shlib::ansi_256_palette
