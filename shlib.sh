#!/usr/bin/env bash
# shellcheck disable=SC1087

# shlib - A library of reusable Bash shell functions
#
# Usage:
#   source /path/to/shlib/shlib.sh
#
# License: MIT
#

# ShellCheck Exclusions:
# - https://www.shellcheck.net/wiki/SC1087

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
readonly SHLIB_VERSION="0.1.3"

# Detect library directory
# shellcheck disable=SC2034,SC2155
readonly SHLIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

#
# Global variables
#

# 16 standard color names (8 normal + 8 bright)
SHLIB_ANSI_COLOR_NAMES=(
    "Black" "Red" "Green" "Yellow" "Blue" "Magenta" "Cyan" "White"
    "Bright Black" "Bright Red" "Bright Green" "Bright Yellow"
    "Bright Blue" "Bright Magenta" "Bright Cyan" "Bright White"
)
readonly SHLIB_ANSI_COLOR_NAMES

# Foreground color codes (30-37 normal, 90-97 bright)
SHLIB_ANSI_FG_CODES=(30 31 32 33 34 35 36 37 90 91 92 93 94 95 96 97)
readonly SHLIB_ANSI_FG_CODES

# Background color codes (40-47 normal, 100-107 bright)
SHLIB_ANSI_BG_CODES=(40 41 42 43 44 45 46 47 100 101 102 103 104 105 106 107)
readonly SHLIB_ANSI_BG_CODES

# Text style codes
SHLIB_ANSI_STYLE_CODES=(0 1 2 3 4 5 7 8 9)
readonly SHLIB_ANSI_STYLE_CODES

# Text style names
SHLIB_ANSI_STYLE_NAMES=(
    "Normal" "Bold" "Dim" "Italic" "Underline"
    "Blink" "Reverse" "Hidden" "Strikethrough"
)
readonly SHLIB_ANSI_STYLE_NAMES

#
# Core Functions
#

# @description List all shlib functions
# @stdout One function name per line, sorted alphabetically
# @exitcode 0 Always succeeds
# @example
#   shlib::list_functions
shlib::list_functions() {
    declare -F | while read -r _ _ name; do
        if [[ "$name" == shlib::* ]]; then
            echo "$name"
        fi
    done | sort
}

# @description List all shlib global variables
# @stdout One variable name per line, sorted alphabetically
# @exitcode 0 Always succeeds
# @example
#   shlib::list_variables
shlib::list_variables() {
    compgen -v | while read -r name; do
        if [[ "$name" == SHLIB_* ]]; then
            echo "$name"
        fi
    done | sort
}

# @description Print the library version
# @stdout The version string
# @exitcode 0 Always succeeds
# @example
#   shlib::version
shlib::version() {
    echo "${SHLIB_VERSION}"
}

#
# Execution
#

# @description Check if a command exists in PATH
# @arg $1 string The command name to check
# @exitcode 0 Command exists
# @exitcode 1 Command not found
# @example
#   shlib::command_exists git
shlib::command_exists() {
    command -v "$1" &>/dev/null
}

#
# Logging Functions
#

# @description Print a colorized error message to stderr (without newline)
# @arg $@ string The error message to print
# @stderr The message prefixed with red "error: "
# @exitcode 0 Always succeeds
# @example
#   shlib::cerror "Something went wrong"
shlib::cerror() {
    printf '\033[%sm%s\033[%sm %s' "${SHLIB_ANSI_FG_CODES[1]}" "error:" "${SHLIB_ANSI_STYLE_CODES[0]}" "$*" >&2
}

# @description Print a colorized error message to stderr (with newline)
# @arg $@ string The error message to print
# @stderr The message prefixed with red "error: " followed by newline
# @exitcode 0 Always succeeds
# @example
#   shlib::cerrorn "Something went wrong"
shlib::cerrorn() {
    printf '\033[%sm%s\033[%sm %s\n' "${SHLIB_ANSI_FG_CODES[1]}" "error:" "${SHLIB_ANSI_STYLE_CODES[0]}" "$*" >&2
}

# @description Print a colorized info message to stdout (without newline)
# @arg $@ string The info message to print
# @stdout The message prefixed with blue "info: "
# @exitcode 0 Always succeeds
# @example
#   shlib::cinfo "Processing file"
shlib::cinfo() {
    printf '\033[%sm%s\033[%sm %s' "${SHLIB_ANSI_FG_CODES[4]}" "info:" "${SHLIB_ANSI_STYLE_CODES[0]}" "$*"
}

# @description Print a colorized info message to stdout (with newline)
# @arg $@ string The info message to print
# @stdout The message prefixed with blue "info: " followed by newline
# @exitcode 0 Always succeeds
# @example
#   shlib::cinfon "Processing complete"
shlib::cinfon() {
    printf '\033[%sm%s\033[%sm %s\n' "${SHLIB_ANSI_FG_CODES[4]}" "info:" "${SHLIB_ANSI_STYLE_CODES[0]}" "$*"
}

# @description Print a colorized warning message to stdout (without newline)
# @arg $@ string The warning message to print
# @stdout The message prefixed with yellow "warning: "
# @exitcode 0 Always succeeds
# @example
#   shlib::cwarn "This might cause issues"
shlib::cwarn() {
    printf '\033[%sm%s\033[%sm %s' "${SHLIB_ANSI_FG_CODES[3]}" "warning:" "${SHLIB_ANSI_STYLE_CODES[0]}" "$*"
}

# @description Print a colorized warning message to stdout (with newline)
# @arg $@ string The warning message to print
# @stdout The message prefixed with yellow "warning: " followed by newline
# @exitcode 0 Always succeeds
# @example
#   shlib::cwarnn "This might cause issues"
shlib::cwarnn() {
    printf '\033[%sm%s\033[%sm %s\n' "${SHLIB_ANSI_FG_CODES[3]}" "warning:" "${SHLIB_ANSI_STYLE_CODES[0]}" "$*"
}

# @description Print an emoji error message to stderr (without newline)
# @arg $@ string The error message to print
# @stderr The message prefixed with "❌️ "
# @exitcode 0 Always succeeds
# @example
#   shlib::eerror "Something went wrong"
shlib::eerror() {
    echo -n "❌️  $*" >&2
}

# @description Print an emoji error message to stderr (with newline)
# @arg $@ string The error message to print
# @stderr The message prefixed with "❌️ " followed by newline
# @exitcode 0 Always succeeds
# @example
#   shlib::eerrorn "Something went wrong"
shlib::eerrorn() {
    echo "❌️  $*" >&2
}

# @description Print an emoji info message to stdout (without newline)
# @arg $@ string The info message to print
# @stdout The message prefixed with "ℹ️ "
# @exitcode 0 Always succeeds
# @example
#   shlib::einfo "Processing file"
shlib::einfo() {
    echo -n "ℹ️  $*"
}

# @description Print an emoji info message to stdout (with newline)
# @arg $@ string The info message to print
# @stdout The message prefixed with "ℹ️ " followed by newline
# @exitcode 0 Always succeeds
# @example
#   shlib::einfon "Processing complete"
shlib::einfon() {
    echo "ℹ️  $*"
}

# @description Print an error message to stderr (without newline)
# @arg $@ string The error message to print
# @stderr The message prefixed with "error: "
# @exitcode 0 Always succeeds
# @example
#   shlib::error "Something went wrong"
shlib::error() {
    echo -n "error: $*" >&2
}

# @description Print an error message to stderr (with newline)
# @arg $@ string The error message to print
# @stderr The message prefixed with "error: " followed by newline
# @exitcode 0 Always succeeds
# @example
#   shlib::errorn "Something went wrong"
shlib::errorn() {
    echo "error: $*" >&2
}

# @description Print an emoji warning message to stdout (without newline)
# @arg $@ string The warning message to print
# @stdout The message prefixed with "⚠️ "
# @exitcode 0 Always succeeds
# @example
#   shlib::ewarn "This might cause issues"
shlib::ewarn() {
    echo -n "⚠️  $*"
}

# @description Print an emoji warning message to stdout (with newline)
# @arg $@ string The warning message to print
# @stdout The message prefixed with "⚠️ " followed by newline
# @exitcode 0 Always succeeds
# @example
#   shlib::ewarnn "This might cause issues"
shlib::ewarnn() {
    echo "⚠️  $*"
}

# @description Print an info message to stdout (without newline)
# @arg $@ string The info message to print
# @stdout The message prefixed with "info: "
# @exitcode 0 Always succeeds
# @example
#   shlib::info "Processing file"
shlib::info() {
    echo -n "info: $*"
}

# @description Print an info message to stdout (with newline)
# @arg $@ string The info message to print
# @stdout The message prefixed with "info: " followed by newline
# @exitcode 0 Always succeeds
# @example
#   shlib::infon "Processing complete"
shlib::infon() {
    echo "info: $*"
}

# @description Print a warning message to stdout (without newline)
# @arg $@ string The warning message to print
# @stdout The message prefixed with "warning: "
# @exitcode 0 Always succeeds
# @example
#   shlib::warn "This might cause issues"
shlib::warn() {
    echo -n "warning: $*"
}

# @description Print a warning message to stdout (with newline)
# @arg $@ string The warning message to print
# @stdout The message prefixed with "warning: " followed by newline
# @exitcode 0 Always succeeds
# @example
#   shlib::warnn "This might cause issues"
shlib::warnn() {
    echo "warning: $*"
}

#
# String Manipulation Functions
#

# @description Check if a string contains a substring
# @arg $1 string The string to search in
# @arg $2 string The substring to search for
# @exitcode 0 String contains substring
# @exitcode 1 String does not contain substring
# @example
#   shlib::str_contains "hello world" "world" && echo "found"
shlib::str_contains() {
    [[ "$1" == *"$2"* ]]
}

# @description Check if a string ends with a suffix
# @arg $1 string The string to check
# @arg $2 string The suffix to check for
# @exitcode 0 String ends with suffix
# @exitcode 1 String does not end with suffix
# @example
#   shlib::str_endswith "hello world" "world" && echo "yes"
shlib::str_endswith() {
    [[ "$1" == *"$2" ]]
}

# @description Check if a string is empty or contains only whitespace
# @arg $1 string The string to check
# @exitcode 0 String is empty or whitespace only
# @exitcode 1 String contains non-whitespace characters
# @example
#   shlib::str_is_empty "   " && echo "empty"
shlib::str_is_empty() {
    local trimmed
    trimmed="${1#"${1%%[![:space:]]*}"}"
    trimmed="${trimmed%"${trimmed##*[![:space:]]}"}"
    [[ -z "$trimmed" ]]
}

# @description Get the length of a string
# @arg $1 string The string to measure
# @stdout The length of the string
# @exitcode 0 Always succeeds
# @example
#   shlib::str_len "hello"
shlib::str_len() {
    echo "${#1}"
}

# @description Remove leading whitespace from a string
# @arg $1 string The string to trim
# @stdout The string with leading whitespace removed
# @exitcode 0 Always succeeds
# @example
#   shlib::str_ltrim "  hello world"
shlib::str_ltrim() {
    local str="$1"
    echo "${str#"${str%%[![:space:]]*}"}"
}

# @description Pad a string on the left to a specified length
# @arg $1 string The string to pad
# @arg $2 int The desired total length
# @arg $3 string The padding character (default: space)
# @stdout The padded string
# @exitcode 0 Always succeeds
# @example
#   shlib::str_padleft "42" 5 "0"  # outputs "00042"
shlib::str_padleft() {
    local str="$1"
    local len="$2"
    local pad="${3:- }"
    while [[ ${#str} -lt $len ]]; do
        str="${pad}${str}"
    done
    echo "$str"
}

# @description Pad a string on the right to a specified length
# @arg $1 string The string to pad
# @arg $2 int The desired total length
# @arg $3 string The padding character (default: space)
# @stdout The padded string
# @exitcode 0 Always succeeds
# @example
#   shlib::str_padright "hi" 5 "-"  # outputs "hi---"
shlib::str_padright() {
    local str="$1"
    local len="$2"
    local pad="${3:- }"
    while [[ ${#str} -lt $len ]]; do
        str="${str}${pad}"
    done
    echo "$str"
}

# @description Repeat a string N times
# @arg $1 string The string to repeat
# @arg $2 int The number of times to repeat (default: 1)
# @stdout The repeated string
# @exitcode 0 Always succeeds
# @example
#   shlib::str_repeat "ab" 3  # outputs "ababab"
#   shlib::str_repeat "-" 10  # outputs "----------"
shlib::str_repeat() {
    local str="$1"
    local count="${2:-1}"
    local result=""
    local i

    for ((i = 0; i < count; i++)); do
        result="${result}${str}"
    done
    echo "$result"
}

# @description Remove trailing whitespace from a string
# @arg $1 string The string to trim
# @stdout The string with trailing whitespace removed
# @exitcode 0 Always succeeds
# @example
#   shlib::str_rtrim "hello world  "
shlib::str_rtrim() {
    local str="$1"
    echo "${str%"${str##*[![:space:]]}"}"
}

# @description Split a string into an array using a separator
# @arg $1 string The name of the array variable to store results (without $)
# @arg $2 string The string to split
# @arg $3 string The separator (default: " ")
# @exitcode 0 Always succeeds
# @example
#   shlib::str_split result "a,b,c" ","
#   # result is now (a b c)
shlib::str_split() {
    local arr_name="$1"
    local str="$2"
    local sep="${3- }"

    # Initialize array as empty
    eval "$arr_name=()"

    # Handle empty string
    [[ -z "$str" ]] && return 0

    # Handle empty separator - split into characters
    if [[ -z "$sep" ]]; then
        local i
        for ((i = 0; i < ${#str}; i++)); do
            eval "$arr_name+=(\"\${str:\$i:1}\")"
        done
        return 0
    fi

    # Split string by separator
    local remaining="$str"
    local part

    while true; do
        if [[ "$remaining" == *"$sep"* ]]; then
            # shellcheck disable=SC2034
            part="${remaining%%"$sep"*}"
            eval "$arr_name+=(\"\$part\")"
            remaining="${remaining#*"$sep"}"
        else
            # Last part (or only part if no separator found)
            eval "$arr_name+=(\"\$remaining\")"
            break
        fi
    done

    return 0
}

# @description Check if a string starts with a prefix
# @arg $1 string The string to check
# @arg $2 string The prefix to check for
# @exitcode 0 String starts with prefix
# @exitcode 1 String does not start with prefix
# @example
#   shlib::str_startswith "hello world" "hello" && echo "yes"
shlib::str_startswith() {
    [[ "$1" == "$2"* ]]
}

# @description Convert a string to lowercase
# @arg $1 string The string to convert
# @stdout The lowercase string
# @exitcode 0 Always succeeds
# @example
#   shlib::str_to_lower "HELLO"
shlib::str_to_lower() {
    echo "$1" | tr '[:upper:]' '[:lower:]'
}

# @description Convert a string to uppercase
# @arg $1 string The string to convert
# @stdout The uppercase string
# @exitcode 0 Always succeeds
# @example
#   shlib::str_to_upper "hello"
shlib::str_to_upper() {
    echo "$1" | tr '[:lower:]' '[:upper:]'
}

# @description Remove leading and trailing whitespace from a string
# @arg $1 string The string to trim
# @stdout The trimmed string
# @exitcode 0 Always succeeds
# @example
#   shlib::str_trim "  hello world  "
shlib::str_trim() {
    local str="$1"
    str="${str#"${str%%[![:space:]]*}"}"
    str="${str%"${str##*[![:space:]]}"}"
    echo "$str"
}

#
# Array Functions
#

# @description Append one or more elements to an array
# @arg $1 string The name of the array variable (without $)
# @arg $@ string Elements to append
# @exitcode 0 Always succeeds
# @example
#   my_array=(a b)
#   shlib::arr_append my_array c d
#   # my_array is now (a b c d)
shlib::arr_append() {
    local arr_name="$1"
    shift
    local elem

    for elem in "$@"; do
        eval "$arr_name+=(\"\$elem\")"
    done
}

# @description Delete an element from an array by index
# @arg $1 string The name of the array variable (without $)
# @arg $2 int The index to delete
# @exitcode 0 Always succeeds
# @example
#   my_array=(a b c d)
#   shlib::arr_delete my_array 1
#   # my_array is now (a c d)
shlib::arr_delete() {
    local arr_name="$1"
    local index="$2"
    eval "unset '$arr_name[$index]'"
    eval "$arr_name=(\"\${$arr_name[@]}\")"
}

# @description Insert an element at a specific index in an array
# @arg $1 string The name of the array variable (without $)
# @arg $2 int The index at which to insert
# @arg $3 string The element to insert
# @exitcode 0 Always succeeds
# @example
#   my_array=(a b c d)
#   shlib::arr_insert my_array 2 "X"
#   # my_array is now (a b X c d)
shlib::arr_insert() {
    local arr_name="$1"
    local index="$2"
    local element="$3"
    local -a result=()
    local len idx

    eval "len=\${#$arr_name[@]}"

    # Clamp index to valid range
    [[ $index -lt 0 ]] && index=0
    [[ $index -gt $len ]] && index=$len

    # Build new array with element inserted
    for ((idx = 0; idx < index; idx++)); do
        eval "result+=(\"\${$arr_name[$idx]}\")"
    done

    result+=("$element")

    for ((idx = index; idx < len; idx++)); do
        eval "result+=(\"\${$arr_name[$idx]}\")"
    done

    eval "$arr_name=(\"\${result[@]}\")"
}

# @description Get the number of elements in an array
# @arg $1 string The name of the array variable (without $)
# @stdout The number of elements in the array
# @exitcode 0 Always succeeds
# @example
#   my_array=(a b c d e)
#   shlib::arr_len my_array  # outputs 5
shlib::arr_len() {
    eval "echo \${#$1[@]}"
}

# @description Merge multiple arrays into a destination array
# @arg $1 string The name of the destination array variable (without $)
# @arg $@ string Names of source arrays to merge (without $)
# @exitcode 0 Always succeeds
# @example
#   arr1=(a b)
#   arr2=(c d)
#   arr3=(e f)
#   shlib::arr_merge result arr1 arr2 arr3
#   # result is now (a b c d e f)
shlib::arr_merge() {
    local dest_name="$1"
    shift

    # Initialize destination as empty
    eval "$dest_name=()"

    local src_name len idx
    for src_name in "$@"; do
        eval "len=\${#$src_name[@]}"
        for ((idx = 0; idx < len; idx++)); do
            eval "$dest_name+=(\"\${$src_name[$idx]}\")"
        done
    done
}

# @description Remove the last element from an array
# @arg $1 string The name of the array variable (without $)
# @exitcode 0 Always succeeds
# @example
#   my_array=(a b c d)
#   shlib::arr_pop my_array
#   # my_array is now (a b c)
shlib::arr_pop() {
    local arr_name="$1"
    local len
    eval "len=\${#$arr_name[@]}"
    [[ $len -eq 0 ]] && return 0
    eval "unset '$arr_name[$((len - 1))]'"
}

# @description Print array elements on one line with a separator
# @arg $1 string The name of the array variable (without $)
# @arg $2 string The separator (default: " ")
# @stdout Array elements joined by separator
# @exitcode 0 Always succeeds
# @example
#   my_array=(a b c)
#   shlib::arr_print my_array      # outputs "a b c"
#   shlib::arr_print my_array ","  # outputs "a,b,c"
shlib::arr_print() {
    local arr_name="$1"
    # shellcheck disable=SC2034
    local sep="${2:- }"
    local len
    eval "len=\${#$arr_name[@]}"
    [[ $len -eq 0 ]] && return 0
    # shellcheck disable=SC2034,SC2178
    local result="" first=1 elem
    eval "for elem in \"\${$arr_name[@]}\"; do
        if [[ \$first -eq 1 ]]; then
            result=\"\$elem\"
            first=0
        else
            result=\"\$result\$sep\$elem\"
        fi
    done"
    # shellcheck disable=SC2128
    echo "$result"
}

# @description Print array elements one per line
# @arg $1 string The name of the array variable (without $)
# @stdout Each array element on its own line
# @exitcode 0 Always succeeds
# @example
#   my_array=(a b c)
#   shlib::arr_printn my_array
#   # outputs:
#   # a
#   # b
#   # c
shlib::arr_printn() {
    local arr_name="$1"
    eval "printf '%s\n' \"\${$arr_name[@]}\""
}

# @description Reverse an array in place
# @arg $1 string The name of the array variable (without $)
# @exitcode 0 Always succeeds
# @example
#   my_array=(a b c d)
#   shlib::arr_reverse my_array
#   # my_array is now (d c b a)
shlib::arr_reverse() {
    local arr_name="$1"
    # shellcheck disable=SC2034
    local -a tmp
    local i len
    eval "len=\${#$arr_name[@]}"
    for ((i = len - 1; i >= 0; i--)); do
        eval "tmp+=(\"\${$arr_name[$i]}\")"
    done
    eval "$arr_name=(\"\${tmp[@]}\")"
}

# @description Sort an array in place (lexicographic order)
# @arg $1 string The name of the array variable (without $)
# @exitcode 0 Always succeeds
# @example
#   my_array=(cherry apple banana)
#   shlib::arr_sort my_array
#   # my_array is now (apple banana cherry)
shlib::arr_sort() {
    local arr_name="$1"
    local IFS=$'\n'
    eval "$arr_name=(\$(printf '%s\n' \"\${$arr_name[@]}\" | sort))"
}

# @description Remove duplicate elements from an array (keeps first occurrence)
# @arg $1 string The name of the array variable (without $)
# @exitcode 0 Always succeeds
# @example
#   my_array=(a b a c b d)
#   shlib::arr_uniq my_array
#   # my_array is now (a b c d)
shlib::arr_uniq() {
    local arr_name="$1"
    local -a result=()
    local len idx elem found j

    eval "len=\${#$arr_name[@]}"
    [[ $len -eq 0 ]] && return 0

    for ((idx = 0; idx < len; idx++)); do
        eval "elem=\${$arr_name[$idx]}"
        found=0
        for ((j = 0; j < ${#result[@]}; j++)); do
            if [[ "${result[$j]}" == "$elem" ]]; then
                found=1
                break
            fi
        done
        if [[ $found -eq 0 ]]; then
            result+=("$elem")
        fi
    done

    eval "$arr_name=(\"\${result[@]}\")"
}

#
# Date and Time Functions
#

# @description Add time units to timestamp
# @arg $1 int Unix timestamp
# @arg $2 int Amount to add (can be negative)
# @arg $3 string Unit: seconds, minutes, hours, days, weeks
# @stdout New Unix timestamp
# @exitcode 0 Always succeeds
# @example
#   shlib::dt_add 1704067200 1 days    # add 1 day
#   shlib::dt_add 1704067200 -2 hours  # subtract 2 hours
shlib::dt_add() {
    local timestamp="$1"
    local amount="$2"
    local unit="$3"
    local multiplier=1

    case "$unit" in
        second | seconds) multiplier=1 ;;
        minute | minutes) multiplier=60 ;;
        hour | hours) multiplier=3600 ;;
        day | days) multiplier=86400 ;;
        week | weeks) multiplier=604800 ;;
        *) multiplier=1 ;;
    esac

    echo $((timestamp + amount * multiplier))
}

# @description Calculate difference between timestamps
# @arg $1 int First Unix timestamp
# @arg $2 int Second Unix timestamp
# @arg $3 string Optional unit: seconds (default), minutes, hours, days, weeks
# @stdout Difference (ts1 - ts2) in specified unit (integer division)
# @exitcode 0 Always succeeds
# @example
#   shlib::dt_diff 1704153600 1704067200          # outputs: 86400 (seconds)
#   shlib::dt_diff 1704153600 1704067200 hours    # outputs: 24
#   shlib::dt_diff 1704153600 1704067200 days     # outputs: 1
shlib::dt_diff() {
    local ts1="$1"
    local ts2="$2"
    local unit="${3:-seconds}"
    local diff=$((ts1 - ts2))
    local divisor=1

    case "$unit" in
        second | seconds) divisor=1 ;;
        minute | minutes) divisor=60 ;;
        hour | hours) divisor=3600 ;;
        day | days) divisor=86400 ;;
        week | weeks) divisor=604800 ;;
        *) divisor=1 ;;
    esac

    echo $((diff / divisor))
}

# @description Format seconds as human-readable duration
# @arg $1 int Number of seconds
# @arg $2 string Optional format: short (default), long, compact
# @stdout Human-readable duration string
# @exitcode 0 Always succeeds
# @example
#   shlib::dt_duration 90061              # outputs: 1d 1h 1m 1s
#   shlib::dt_duration 90061 long         # outputs: 1 day, 1 hour, 1 minute, 1 second
#   shlib::dt_duration 90061 compact      # outputs: 1d1h1m1s
shlib::dt_duration() {
    local seconds="$1"
    local format="${2:-short}"
    local negative=""

    # Handle negative durations
    if [[ $seconds -lt 0 ]]; then
        negative="-"
        seconds=$((-seconds))
    fi

    local days=$((seconds / 86400))
    local hours=$(((seconds % 86400) / 3600))
    local mins=$(((seconds % 3600) / 60))
    local secs=$((seconds % 60))

    local output=""

    case "$format" in
        long)
            local parts=()
            [[ $days -gt 0 ]] && parts+=("$days day$([[ $days -ne 1 ]] && echo "s")")
            [[ $hours -gt 0 ]] && parts+=("$hours hour$([[ $hours -ne 1 ]] && echo "s")")
            [[ $mins -gt 0 ]] && parts+=("$mins minute$([[ $mins -ne 1 ]] && echo "s")")
            [[ $secs -gt 0 || ${#parts[@]} -eq 0 ]] && parts+=("$secs second$([[ $secs -ne 1 ]] && echo "s")")

            local i
            for ((i = 0; i < ${#parts[@]}; i++)); do
                [[ $i -gt 0 ]] && output+=", "
                output+="${parts[$i]}"
            done
            ;;
        compact)
            [[ $days -gt 0 ]] && output+="${days}d"
            [[ $hours -gt 0 ]] && output+="${hours}h"
            [[ $mins -gt 0 ]] && output+="${mins}m"
            [[ $secs -gt 0 || -z "$output" ]] && output+="${secs}s"
            ;;
        short | *)
            [[ $days -gt 0 ]] && output+="${days}d "
            [[ $hours -gt 0 ]] && output+="${hours}h "
            [[ $mins -gt 0 ]] && output+="${mins}m "
            [[ $secs -gt 0 || -z "$output" ]] && output+="${secs}s"
            output="${output% }" # trim trailing space
            ;;
    esac

    echo "${negative}${output}"
}

# @description Format elapsed time since start timestamp
# @arg $1 int Start Unix timestamp
# @arg $2 string Optional format: short (default), long, compact
# @stdout Elapsed time as human-readable duration
# @exitcode 0 Always succeeds
# @example
#   start=$(shlib::dt_now)
#   sleep 5
#   shlib::dt_elapsed "$start"  # outputs: 5s
shlib::dt_elapsed() {
    local start="$1"
    local format="${2:-short}"
    local now
    now=$(date +%s)
    local elapsed=$((now - start))
    shlib::dt_duration "$elapsed" "$format"
}

# @description Format Unix timestamp with format string
# @arg $1 int Unix timestamp
# @arg $2 string Format string (strftime compatible)
# @stdout Formatted date/time string
# @exitcode 0 Success
# @exitcode 1 Invalid timestamp or format
# @example
#   shlib::dt_from_unix 1704067200 "%Y-%m-%d"  # outputs: 2024-01-01
#   shlib::dt_from_unix 1704067200 "%H:%M:%S"  # outputs: 12:00:00
shlib::dt_from_unix() {
    local timestamp="$1"
    local format="$2"

    # Try BSD date first (macOS)
    if date -r "$timestamp" +"$format" 2>/dev/null; then
        return 0
    fi

    # Try GNU date (Linux)
    if date -d "@$timestamp" +"$format" 2>/dev/null; then
        return 0
    fi

    return 1
}

# @description Check if timestamp A is after timestamp B
# @arg $1 int First Unix timestamp
# @arg $2 int Second Unix timestamp
# @exitcode 0 ts1 > ts2
# @exitcode 1 ts1 <= ts2
# @example
#   shlib::dt_is_after 1704153600 1704067200 && echo "later"
shlib::dt_is_after() {
    [[ "$1" -gt "$2" ]]
}

# @description Check if timestamp A is before timestamp B
# @arg $1 int First Unix timestamp
# @arg $2 int Second Unix timestamp
# @exitcode 0 ts1 < ts2
# @exitcode 1 ts1 >= ts2
# @example
#   shlib::dt_is_before 1704067200 1704153600 && echo "earlier"
shlib::dt_is_before() {
    [[ "$1" -lt "$2" ]]
}

# @description Check if date string is valid
# @arg $1 string Date string to validate
# @arg $2 string Optional format string for BSD date
# @exitcode 0 Valid date
# @exitcode 1 Invalid date
# @example
#   shlib::dt_is_valid "2024-01-01" && echo "valid"
#   shlib::dt_is_valid "not-a-date" || echo "invalid"
shlib::dt_is_valid() {
    local datestr="$1"
    local format="${2:-}"

    # Try GNU date first
    if date -d "$datestr" +%s &>/dev/null; then
        return 0
    fi

    # Try BSD date with format
    if [[ -n "$format" ]]; then
        if date -j -f "$format" "$datestr" +%s &>/dev/null; then
            return 0
        fi
    fi

    # Try common formats with BSD date
    local fmt
    for fmt in "%Y-%m-%d" "%Y-%m-%d %H:%M:%S" "%Y/%m/%d" "%m/%d/%Y"; do
        if date -j -f "$fmt" "$datestr" +%s &>/dev/null; then
            return 0
        fi
    done

    return 1
}

# @description Get current Unix timestamp
# @stdout The current Unix timestamp in seconds
# @exitcode 0 Always succeeds
# @example
#   shlib::dt_now  # outputs: 1704067200
shlib::dt_now() {
    date +%s
}

# @description Get current datetime in ISO 8601 format
# @arg $1 string Optional: "local" for local time, default is UTC
# @stdout Current datetime in ISO 8601 format
# @exitcode 0 Always succeeds
# @example
#   shlib::dt_now_iso         # outputs: 2024-01-01T12:00:00Z
#   shlib::dt_now_iso local   # outputs: 2024-01-01T07:00:00-05:00
shlib::dt_now_iso() {
    local zone="${1:-}"
    if [[ "$zone" == "local" ]]; then
        date +%Y-%m-%dT%H:%M:%S%z | sed 's/\([+-][0-9][0-9]\)\([0-9][0-9]\)$/\1:\2/'
    else
        date -u +%Y-%m-%dT%H:%M:%SZ
    fi
}

# @description Parse date string to Unix timestamp
# @arg $1 string Date string to parse
# @arg $2 string Optional format string for BSD date (e.g., "%Y-%m-%d")
# @stdout Unix timestamp
# @exitcode 0 Success
# @exitcode 1 Invalid date string
# @example
#   shlib::dt_to_unix "2024-01-01"              # outputs: 1704067200
#   shlib::dt_to_unix "01/15/2024" "%m/%d/%Y"   # with format for BSD
shlib::dt_to_unix() {
    local datestr="$1"
    local format="${2:-}"

    # Try GNU date first (more flexible parsing)
    if date -d "$datestr" +%s 2>/dev/null; then
        return 0
    fi

    # Try BSD date with format
    if [[ -n "$format" ]]; then
        if date -j -f "$format" "$datestr" +%s 2>/dev/null; then
            return 0
        fi
    fi

    # Try common formats with BSD date
    local fmt
    for fmt in "%Y-%m-%d" "%Y-%m-%d %H:%M:%S" "%Y/%m/%d" "%m/%d/%Y"; do
        if date -j -f "$fmt" "$datestr" +%s 2>/dev/null; then
            return 0
        fi
    done

    return 1
}

# @description Get current date as YYYY-MM-DD
# @stdout Current date in YYYY-MM-DD format
# @exitcode 0 Always succeeds
# @example
#   shlib::dt_today  # outputs: 2024-01-01
shlib::dt_today() {
    date +%Y-%m-%d
}

#
# Key-Value (Associative Array) Functions
#

# Note: These functions require Bash 4.0 or higher for associative array support.
# Associative arrays are declared with: declare -A myarray
#
# @description Remove all entries from an associative array
# @arg $1 string The name of the associative array variable (without $)
# @exitcode 0 Always succeeds
# @example
#   declare -A config
#   config[host]="localhost"
#   config[port]="8080"
#   shlib::kv_clear config
shlib::kv_clear() {
    local arr_name="$1"
    eval "$arr_name=()"
}

# @description Copy an associative array to another
# @arg $1 string The name of the destination associative array (without $)
# @arg $2 string The name of the source associative array (without $)
# @exitcode 0 Always succeeds
# @example
#   declare -A original
#   original[host]="localhost"
#   declare -A copy
#   shlib::kv_copy copy original
shlib::kv_copy() {
    local dest_name="$1"
    local src_name="$2"
    local -a keys
    local key

    eval "$dest_name=()"
    eval "keys=(\"\${!$src_name[@]}\")"
    for key in "${keys[@]}"; do
        local value
        eval "value=\"\${$src_name[\"\$key\"]}\""
        eval "$dest_name[\"\$key\"]=\"\$value\""
    done
}

# @description Delete a key from an associative array
# @arg $1 string The name of the associative array variable (without $)
# @arg $2 string The key to delete
# @exitcode 0 Always succeeds
# @example
#   declare -A config
#   config[host]="localhost"
#   shlib::kv_delete config "host"
shlib::kv_delete() {
    local arr_name="$1"
    local key="$2"
    eval "unset '$arr_name[\"\$key\"]'"
}

# @description Check if a key exists in an associative array
# @arg $1 string The name of the associative array variable (without $)
# @arg $2 string The key to check
# @exitcode 0 Key exists
# @exitcode 1 Key does not exist
# @example
#   declare -A config
#   config[host]="localhost"
#   shlib::kv_exists config "host" && echo "exists"
shlib::kv_exists() {
    local arr_name="$1"
    local key="$2"
    local exists
    eval "exists=\${$arr_name[\"\$key\"]+exists}"
    [[ -n "$exists" ]]
}

# @description Find all keys with a specific value
# @arg $1 string The name of the destination array variable (without $)
# @arg $2 string The name of the associative array variable (without $)
# @arg $3 string The value to search for
# @exitcode 0 Always succeeds
# @example
#   declare -A roles
#   roles[alice]="admin"
#   roles[bob]="user"
#   roles[carol]="admin"
#   shlib::kv_find admins roles "admin"
#   # admins is now: alice carol
shlib::kv_find() {
    local dest_name="$1"
    local arr_name="$2"
    local search_value="$3"
    local -a keys
    local key

    eval "$dest_name=()"
    eval "keys=(\"\${!$arr_name[@]}\")"
    for key in "${keys[@]}"; do
        local value
        eval "value=\"\${$arr_name[\"\$key\"]}\""
        if [[ "$value" == "$search_value" ]]; then
            eval "$dest_name+=(\"\$key\")"
        fi
    done
}

# @description Get a value by key from an associative array
# @arg $1 string The name of the associative array variable (without $)
# @arg $2 string The key to look up
# @stdout The value associated with the key
# @exitcode 0 Key exists
# @exitcode 1 Key not found
# @example
#   declare -A config
#   config[host]="localhost"
#   shlib::kv_get config "host"  # outputs: localhost
shlib::kv_get() {
    local arr_name="$1"
    local key="$2"
    local exists
    eval "exists=\${$arr_name[\"\$key\"]+exists}"
    if [[ -n "$exists" ]]; then
        eval "echo \"\${$arr_name[\"\$key\"]}\""
        return 0
    fi
    return 1
}

# @description Get a value by key with a fallback default
# @arg $1 string The name of the associative array variable (without $)
# @arg $2 string The key to look up
# @arg $3 string The default value if key not found
# @stdout The value associated with the key, or default if not found
# @exitcode 0 Always succeeds
# @example
#   declare -A config
#   shlib::kv_get_default config "port" "8080"  # outputs: 8080
shlib::kv_get_default() {
    local arr_name="$1"
    local key="$2"
    local default="$3"
    local exists
    eval "exists=\${$arr_name[\"\$key\"]+exists}"
    if [[ -n "$exists" ]]; then
        eval "echo \"\${$arr_name[\"\$key\"]}\""
    else
        echo "$default"
    fi
}

# @description Check if a value exists in an associative array
# @arg $1 string The name of the associative array variable (without $)
# @arg $2 string The value to search for
# @exitcode 0 Value exists
# @exitcode 1 Value does not exist
# @example
#   declare -A config
#   config[host]="localhost"
#   shlib::kv_has_value config "localhost" && echo "found"
shlib::kv_has_value() {
    local arr_name="$1"
    local search_value="$2"
    local -a keys
    local key

    eval "keys=(\"\${!$arr_name[@]}\")"
    for key in "${keys[@]}"; do
        local value
        eval "value=\"\${$arr_name[\"\$key\"]}\""
        if [[ "$value" == "$search_value" ]]; then
            return 0
        fi
    done
    return 1
}

# @description Get all keys from an associative array into a regular array
# @arg $1 string The name of the destination array variable (without $)
# @arg $2 string The name of the associative array variable (without $)
# @exitcode 0 Always succeeds
# @example
#   declare -A config
#   config[host]="localhost"
#   config[port]="8080"
#   shlib::kv_keys keys config
#   # keys is now an array of: host port (order may vary)
shlib::kv_keys() {
    local dest_name="$1"
    local arr_name="$2"
    eval "$dest_name=(\"\${!$arr_name[@]}\")"
}

# @description Get the count of entries in an associative array
# @arg $1 string The name of the associative array variable (without $)
# @stdout The number of key-value pairs
# @exitcode 0 Always succeeds
# @example
#   declare -A config
#   config[host]="localhost"
#   config[port]="8080"
#   shlib::kv_len config  # outputs: 2
shlib::kv_len() {
    eval "echo \${#$1[@]}"
}

# @description Apply a transformation command to all values
# @arg $1 string The name of the associative array variable (without $)
# @arg $2 string The command to apply (receives value via stdin, outputs to stdout)
# @exitcode 0 Always succeeds
# @example
#   declare -A data
#   data[name]="hello"
#   data[greeting]="world"
#   shlib::kv_map data 'tr a-z A-Z'
#   # data is now: name=HELLO greeting=WORLD
shlib::kv_map() {
    local arr_name="$1"
    local cmd="$2"
    local -a keys
    local key

    eval "keys=(\"\${!$arr_name[@]}\")"
    for key in "${keys[@]}"; do
        local value new_value
        eval "value=\"\${$arr_name[\"\$key\"]}\""
        # shellcheck disable=SC2034
        new_value=$(echo "$value" | eval "$cmd")
        eval "$arr_name[\"\$key\"]=\"\$new_value\""
    done
}

# @description Merge multiple associative arrays (later arrays override earlier)
# @arg $1 string The name of the destination associative array (without $)
# @arg $@ string Names of source associative arrays to merge (without $)
# @exitcode 0 Always succeeds
# @example
#   declare -A defaults
#   defaults[host]="localhost"
#   defaults[port]="80"
#   declare -A overrides
#   overrides[port]="8080"
#   declare -A result
#   shlib::kv_merge result defaults overrides
#   # result is now: host=localhost port=8080
shlib::kv_merge() {
    local dest_name="$1"
    shift

    eval "$dest_name=()"
    local src_name
    for src_name in "$@"; do
        local -a keys
        local key
        eval "keys=(\"\${!$src_name[@]}\")"
        for key in "${keys[@]}"; do
            local value
            eval "value=\"\${$src_name[\"\$key\"]}\""
            eval "$dest_name[\"\$key\"]=\"\$value\""
        done
    done
}

# @description Print key-value pairs on one line with separators
# @arg $1 string The name of the associative array variable (without $)
# @arg $2 string Key-value separator (default: "=")
# @arg $3 string Pair separator (default: " ")
# @stdout Key-value pairs joined by separators
# @exitcode 0 Always succeeds
# @example
#   declare -A config
#   config[host]="localhost"
#   config[port]="8080"
#   shlib::kv_print config           # outputs: host=localhost port=8080
#   shlib::kv_print config ":" ", "  # outputs: host:localhost, port:8080
shlib::kv_print() {
    local arr_name="$1"
    local kv_sep="${2:-=}"
    local pair_sep="${3:- }"
    local -a keys
    local key first=1 output_str=""

    eval "keys=(\"\${!$arr_name[@]}\")"
    [[ ${#keys[@]} -eq 0 ]] && return 0

    for key in "${keys[@]}"; do
        local value
        eval "value=\"\${$arr_name[\"\$key\"]}\""
        if [[ $first -eq 1 ]]; then
            output_str="${key}${kv_sep}${value}"
            first=0
        else
            output_str="${output_str}${pair_sep}${key}${kv_sep}${value}"
        fi
    done
    echo "$output_str"
}

# @description Print key-value pairs one per line
# @arg $1 string The name of the associative array variable (without $)
# @arg $2 string Key-value separator (default: "=")
# @stdout Each key-value pair on its own line
# @exitcode 0 Always succeeds
# @example
#   declare -A config
#   config[host]="localhost"
#   config[port]="8080"
#   shlib::kv_printn config
#   # outputs:
#   # host=localhost
#   # port=8080
shlib::kv_printn() {
    local arr_name="$1"
    local kv_sep="${2:-=}"
    local -a keys
    local key

    eval "keys=(\"\${!$arr_name[@]}\")"
    for key in "${keys[@]}"; do
        local value
        eval "value=\"\${$arr_name[\"\$key\"]}\""
        echo "${key}${kv_sep}${value}"
    done
}

# @description Set a key-value pair in an associative array
# @arg $1 string The name of the associative array variable (without $)
# @arg $2 string The key to set
# @arg $3 string The value to set
# @exitcode 0 Always succeeds
# @example
#   declare -A config
#   shlib::kv_set config "host" "localhost"
shlib::kv_set() {
    local arr_name="$1"
    local key="$2"
    local value="$3"
    eval "$arr_name[\"\$key\"]=\"\$value\""
}

# @description Get all values from an associative array into a regular array
# @arg $1 string The name of the destination array variable (without $)
# @arg $2 string The name of the associative array variable (without $)
# @exitcode 0 Always succeeds
# @example
#   declare -A config
#   config[host]="localhost"
#   config[port]="8080"
#   shlib::kv_values values config
#   # values is now an array of: localhost 8080 (order may vary)
shlib::kv_values() {
    local dest_name="$1"
    local arr_name="$2"
    eval "$dest_name=(\"\${$arr_name[@]}\")"
}

#
# UI Functions
#

# @description Display the 256 color palette
# @stdout The 256 color palette with standard colors, 216 colors, and grayscale
# @exitcode 0 Always succeeds
# @example
#   shlib::ansi_256_palette
shlib::ansi_256_palette() {
    local i

    printf '\033[1m%s\033[0m\n' "256 Color Palette (\\033[38;5;Nm for FG, \\033[48;5;Nm for BG)"
    echo "Standard Colors (0-15):"
    for i in {0..15}; do
        printf '\033[48;5;%sm %3s \033[0m' "$i" "$i"
        [[ $i -eq 7 ]] && echo
    done
    echo
    echo
    echo "216 Colors (16-231):"
    for i in {16..231}; do
        printf '\033[48;5;%sm %3s \033[0m' "$i" "$i"
        [[ $(((i - 15) % 18)) -eq 0 ]] && echo
    done
    echo
    echo "Grayscale (232-255):"
    for i in {232..255}; do
        printf '\033[48;5;%sm %3s \033[0m' "$i" "$i"
    done
    echo
}

# @description Display 16 background ANSI color codes (40-47, 100-107)
# @stdout A formatted table showing background colors
# @exitcode 0 Always succeeds
# @example
#   shlib::ansi_bg_colors
shlib::ansi_bg_colors() {
    local fg i

    printf '\033[1m%s\033[0m\n' "Background Colors"
    printf '%-20s %-10s %s\n' "Color" "Code" "Example"
    printf '%s\n' "-----------------------------------------------"
    for i in "${!SHLIB_ANSI_BG_CODES[@]}"; do
        # Use contrasting foreground for visibility
        if [[ ${SHLIB_ANSI_BG_CODES[$i]} -lt 44 ]] || [[ ${SHLIB_ANSI_BG_CODES[$i]} -ge 100 && ${SHLIB_ANSI_BG_CODES[$i]} -lt 104 ]]; then
            fg=97 # Bright white for dark backgrounds
        else
            fg=30 # Black for light backgrounds
        fi
        printf '%-20s \\033[%-5sm \033[%s;%sm%s\033[0m\n' "${SHLIB_ANSI_COLOR_NAMES[$i]}" "${SHLIB_ANSI_BG_CODES[$i]}" "${SHLIB_ANSI_BG_CODES[$i]}" "$fg" " Sample Text "
    done
}

# @description Display standard foreground/background color combinations matrix
# @stdout A matrix of standard FG (30-37) x BG (40-47) combinations
# @exitcode 0 Always succeeds
# @example
#   shlib::ansi_color_matrix
shlib::ansi_color_matrix() {
    local i j

    printf '\033[1m%s\033[0m\n' "Foreground / Background Combinations (Standard Colors)"
    printf '%-8s' ""
    for j in "${SHLIB_ANSI_BG_CODES[@]:0:8}"; do
        printf ' %-5s' "$j"
    done
    echo
    printf '%s\n' "--------------------------------------------------------"
    for i in "${SHLIB_ANSI_FG_CODES[@]:0:8}"; do
        printf '%-8s' "$i"
        for j in "${SHLIB_ANSI_BG_CODES[@]:0:8}"; do
            printf ' \033[%s;%sm %-3s \033[0m' "$i" "$j" "Txt"
        done
        echo
    done
}

# @description Display bright foreground/background color combinations matrix
# @stdout A matrix of bright FG (90-97) x BG (100-107) combinations
# @exitcode 0 Always succeeds
# @example
#   shlib::ansi_color_matrix_bright
shlib::ansi_color_matrix_bright() {
    local i j

    printf '\033[1m%s\033[0m\n' "Foreground / Background Combinations (Bright Colors)"
    printf '%-8s' ""
    for j in "${SHLIB_ANSI_BG_CODES[@]:8:8}"; do
        printf ' %-5s' "$j"
    done
    echo
    printf '%s\n' "----------------------------------------------------------------"
    for i in "${SHLIB_ANSI_FG_CODES[@]:8:8}"; do
        printf '%-8s' "$i"
        for j in "${SHLIB_ANSI_BG_CODES[@]:8:8}"; do
            printf ' \033[%s;%sm %-3s \033[0m' "$i" "$j" "Txt"
        done
        echo
    done
}

# @description Display 16 foreground ANSI color codes (30-37, 90-97)
# @stdout A formatted table showing foreground colors
# @exitcode 0 Always succeeds
# @example
#   shlib::ansi_fg_colors
shlib::ansi_fg_colors() {
    local i

    printf '\033[1m%s\033[0m\n' "Foreground Colors"
    printf '%-20s %-10s %s\n' "Color" "Code" "Example"
    printf '%s\n' "-----------------------------------------------"
    for i in "${!SHLIB_ANSI_FG_CODES[@]}"; do
        printf '%-20s \\033[%-5sm \033[%sm%s\033[0m\n' "${SHLIB_ANSI_COLOR_NAMES[$i]}" "${SHLIB_ANSI_FG_CODES[$i]}" "${SHLIB_ANSI_FG_CODES[$i]}" "Sample Text"
    done
}

# @description Display ANSI text styles with codes and examples
# @stdout A formatted table showing text styles
# @exitcode 0 Always succeeds
# @example
#   shlib::ansi_styles
shlib::ansi_styles() {
    local i

    printf '\033[1m%s\033[0m\n' "Text Styles"
    printf '%-15s %-10s %s\n' "Style" "Code" "Example"
    printf '%s\n' "---------------------------------------"
    for i in "${!SHLIB_ANSI_STYLE_CODES[@]}"; do
        printf '%-15s \\033[%-5sm \033[%sm%s\033[0m\n' "${SHLIB_ANSI_STYLE_NAMES[$i]}" "${SHLIB_ANSI_STYLE_CODES[$i]}" "${SHLIB_ANSI_STYLE_CODES[$i]}" "Sample Text"
    done
}

# @description Print a bold header message to stdout (without newline)
# @arg $@ string The header message to print
# @stdout The message in bold
# @exitcode 0 Always succeeds
# @example
#   shlib::header "Section Title"
shlib::header() {
    printf '\033[%sm%s\033[%sm' "${SHLIB_ANSI_STYLE_CODES[1]}" "$*" "${SHLIB_ANSI_STYLE_CODES[0]}"
}

# @description Print a bold header message to stdout (with newline)
# @arg $@ string The header message to print
# @stdout The message in bold followed by newline
# @exitcode 0 Always succeeds
# @example
#   shlib::headern "Section Title"
shlib::headern() {
    printf '\033[%sm%s\033[%sm\n' "${SHLIB_ANSI_STYLE_CODES[1]}" "$*" "${SHLIB_ANSI_STYLE_CODES[0]}"
}

# @description Draw a horizontal rule/divider line
# @arg $1 string Optional label to display in the middle
# @arg $2 int Width of the rule (default: 40)
# @arg $3 string Character to use (default: ─)
# @stdout A horizontal divider line
# @exitcode 0 Always succeeds
# @example
#   shlib::hr
#   shlib::hr "Section"
#   shlib::hr "Title" 60 "="
shlib::hr() {
    local label="${1:-}"
    local width="${2:-40}"
    local char="${3:-─}"
    local i line=""

    if [[ -z "$label" ]]; then
        # No label, just draw the line
        for ((i = 0; i < width; i++)); do
            line="${line}${char}"
        done
    else
        # Calculate padding for centered label
        local label_len=${#label}
        local padding=$(((width - label_len - 2) / 2))
        local left_pad="" right_pad=""

        for ((i = 0; i < padding; i++)); do
            left_pad="${left_pad}${char}"
        done

        # Account for odd widths
        local right_padding=$((width - padding - label_len - 2))
        for ((i = 0; i < right_padding; i++)); do
            right_pad="${right_pad}${char}"
        done

        line="${left_pad} ${label} ${right_pad}"
    fi

    printf '%s' "$line"
}

# @description Draw a horizontal rule with newline
# @arg $1 string Optional label to display in the middle
# @arg $2 int Width of the rule (default: 40)
# @arg $3 string Character to use (default: ─)
# @stdout A horizontal divider line followed by newline
# @exitcode 0 Always succeeds
# @example
#   shlib::hrn "Section Title"
shlib::hrn() {
    shlib::hr "$@"
    echo
}

# @description Run a command with a spinner animation
# @arg $1 string The message to display next to the spinner
# @arg $@ string The command and its arguments to run
# @stdout The spinner animation and message while running
# @exitcode Returns the exit code of the executed command
# @example
#   shlib::spinner "Installing packages" apt-get install -y curl
#   shlib::spinner "Building project" make -j4
shlib::spinner() {
    local message="$1"
    shift
    local -a spin_chars=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
    local spin_idx=0
    local cmd_pid
    local exit_code

    # Run command in background
    "$@" &
    cmd_pid=$!

    # Hide cursor
    printf '\033[?25l'

    # Spinner loop
    while kill -0 "$cmd_pid" 2>/dev/null; do
        printf '\r%s %s' "${spin_chars[$spin_idx]}" "$message"
        spin_idx=$(((spin_idx + 1) % ${#spin_chars[@]}))
        sleep 0.1
    done

    # Wait for command and get exit code
    wait "$cmd_pid"
    exit_code=$?

    # Clear spinner line and show cursor
    printf '\r\033[K\033[?25h'

    return $exit_code
}

# @description Print a failure status indicator (without newline)
# @arg $@ string The message to print
# @stdout Red X followed by message
# @exitcode 0 Always succeeds
# @example
#   shlib::status_fail "Task failed"
shlib::status_fail() {
    printf '\033[31m✖\033[0m  %s' "$*"
}

# @description Print a failure status indicator (with newline)
# @arg $@ string The message to print
# @stdout Red X followed by message and newline
# @exitcode 0 Always succeeds
# @example
#   shlib::status_failn "Task failed"
shlib::status_failn() {
    shlib::status_fail "$@"
    echo
}

# @description Print a success status indicator (without newline)
# @arg $@ string The message to print
# @stdout Green checkmark followed by message
# @exitcode 0 Always succeeds
# @example
#   shlib::status_ok "Task completed"
shlib::status_ok() {
    printf '\033[32m✔\033[0m  %s' "$*"
}

# @description Print a success status indicator (with newline)
# @arg $@ string The message to print
# @stdout Green checkmark followed by message and newline
# @exitcode 0 Always succeeds
# @example
#   shlib::status_okn "Task completed"
shlib::status_okn() {
    shlib::status_ok "$@"
    echo
}

# @description Print a pending status indicator (without newline)
# @arg $@ string The message to print
# @stdout Yellow hourglass followed by message
# @exitcode 0 Always succeeds
# @example
#   shlib::status_pending "Waiting..."
shlib::status_pending() {
    printf '\033[33m⏳\033[0m %s' "$*"
}

# @description Print a pending status indicator (with newline)
# @arg $@ string The message to print
# @stdout Yellow hourglass followed by message and newline
# @exitcode 0 Always succeeds
# @example
#   shlib::status_pendingn "Waiting..."
shlib::status_pendingn() {
    shlib::status_pending "$@"
    echo
}
