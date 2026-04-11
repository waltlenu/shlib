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

shlib::ui_banner "shlib" "" "gay"

shlib::ui_headern "shlib Examples"
echo

# Example helpers
_header() { shlib::ui_headern "${1#shlib::}"; }
_run() {
    echo "> $*"
    "$@"
}
_show() { echo "> $*"; }
# shellcheck disable=SC2005
_eval() {
    echo "> $*"
    echo "$("$@")"
}
