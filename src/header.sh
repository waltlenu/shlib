#!/usr/bin/env bash
# shellcheck disable=SC2034

########################################################################
#                                                                      #
#  shlib - A library of reusable Bash shell functions (examples)       #
#                                                                      #
#  Usage: bash shlib.example.bash                                      #
#  License: MIT                                                        #
#                                                                      #
########################################################################

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source the library
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/shlib.bash"

shlib::banner_toilet "shlib" "" "gay"

shlib::headern "shlib Examples"
echo
