#!/usr/bin/env bash
# shellcheck disable=SC1087

########################################################################
#                                                                      #
#  {{ .project }} - {{ .description }}                  #
#                                                                      #
#  Usage: source /path/to/shlib/shlib.bash                             #
#  License: {{ .license }}                                           #
#                                                                      #
########################################################################

#######################################
# Global (minimal) logic
#######################################

# Prevent double-sourcing
[[ -n "${SHLIB_LOADED:-}" ]] && return 0

# Require bash version 3 or higher
if [[ "${BASH_VERSINFO[0]}" -lt 3 ]]; then
    echo "shlib: requires bash version 3 or higher (found ${BASH_VERSION})" >&2
    return 1
fi

readonly SHLIB_LOADED=1

# Enable strict mode (can be disabled by the caller if needed)
set -euo pipefail

# Library version
readonly SHLIB_VERSION="{{ .version }}"

# Detect library directory
# shellcheck disable=SC2034,SC2155
readonly SHLIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

#######################################
# Global variables
#######################################

# 16 standard color names (8 normal + 8 bright)
SHLIB_ANSI_COLORNAMES=(
    "Black" "Red" "Green" "Yellow" "Blue" "Magenta" "Cyan" "White"
    "Bright Black" "Bright Red" "Bright Green" "Bright Yellow"
    "Bright Blue" "Bright Magenta" "Bright Cyan" "Bright White"
)
readonly SHLIB_ANSI_COLORNAMES

# Foreground color codes (30-37 normal, 90-97 bright)
SHLIB_ANSI_FGCODES=(30 31 32 33 34 35 36 37 90 91 92 93 94 95 96 97)
readonly SHLIB_ANSI_FGCODES

# Background color codes (40-47 normal, 100-107 bright)
SHLIB_ANSI_BGCODES=(40 41 42 43 44 45 46 47 100 101 102 103 104 105 106 107)
readonly SHLIB_ANSI_BGCODES

# Text style codes
SHLIB_ANSI_STYLECODES=(0 1 2 3 4 5 7 8 9)
readonly SHLIB_ANSI_STYLECODES

# Text style names
SHLIB_ANSI_STYLENAMES=(
    "Normal" "Bold" "Dim" "Italic" "Underline"
    "Blink" "Reverse" "Hidden" "Strikethrough"
)
readonly SHLIB_ANSI_STYLENAMES
