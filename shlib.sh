#!/usr/bin/env bash
#
# shlib - A shell library of reusable functions
#
# Usage:
#   source /path/to/shlib/shlib.sh
#

# Prevent double-sourcing
[[ -n "${SHLIB_LOADED:-}" ]] && return 0

# Require bash version 3 or higher
if [[ "${BASH_VERSINFO[0]}" -lt 3 ]]; then
    echo "shlib: requires bash version 3 or higher (found ${BASH_VERSION})" >&2
    return 1
fi

readonly SHLIB_LOADED=1

# Library version
readonly SHLIB_VERSION="0.1.2"

# Detect library directory
# shellcheck disable=SC2034,SC2155
readonly SHLIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Enable strict mode (can be disabled by the caller if needed)
set -euo pipefail

#
# Core Functions
#

# @description Print the library version
# @stdout The version string
# @exitcode 0 Always succeeds
# @example
#   shlib::version
shlib::version() {
    echo "${SHLIB_VERSION}"
}

# @description Check if a command exists in PATH
# @arg $1 string The command name to check
# @exitcode 0 Command exists
# @exitcode 1 Command not found
# @example
#   shlib::command_exists git
shlib::command_exists() {
    command -v "$1" &>/dev/null
}

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

#
# ANSI Color Arrays
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
# Logging Functions
#

# @description Print an error message to stderr (without newline)
# @arg $@ string The error message to print
# @stderr The message prefixed with "error: "
# @exitcode 0 Always succeeds
# @example
#   shlib::error "Something went wrong"
shlib::error() {
    echo -n "error: $*" >&2
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

# @description Print an info message to stdout (without newline)
# @arg $@ string The info message to print
# @stdout The message prefixed with "info: "
# @exitcode 0 Always succeeds
# @example
#   shlib::info "Processing file"
shlib::info() {
    echo -n "info: $*"
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

# @description Print a warning message to stdout (with newline)
# @arg $@ string The warning message to print
# @stdout The message prefixed with "warning: " followed by newline
# @exitcode 0 Always succeeds
# @example
#   shlib::warnn "This might cause issues"
shlib::warnn() {
    echo "warning: $*"
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

#
# Colorized Logging Functions
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

# @description Print a colorized warning message to stdout (without newline)
# @arg $@ string The warning message to print
# @stdout The message prefixed with yellow "warning: "
# @exitcode 0 Always succeeds
# @example
#   shlib::cwarn "This might cause issues"
shlib::cwarn() {
    printf '\033[%sm%s\033[%sm %s' "${SHLIB_ANSI_FG_CODES[3]}" "warning:" "${SHLIB_ANSI_STYLE_CODES[0]}" "$*"
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

# @description Print a colorized error message to stderr (with newline)
# @arg $@ string The error message to print
# @stderr The message prefixed with red "error: " followed by newline
# @exitcode 0 Always succeeds
# @example
#   shlib::cerrorn "Something went wrong"
shlib::cerrorn() {
    printf '\033[%sm%s\033[%sm %s\n' "${SHLIB_ANSI_FG_CODES[1]}" "error:" "${SHLIB_ANSI_STYLE_CODES[0]}" "$*" >&2
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

# @description Print a colorized info message to stdout (with newline)
# @arg $@ string The info message to print
# @stdout The message prefixed with blue "info: " followed by newline
# @exitcode 0 Always succeeds
# @example
#   shlib::cinfon "Processing complete"
shlib::cinfon() {
    printf '\033[%sm%s\033[%sm %s\n' "${SHLIB_ANSI_FG_CODES[4]}" "info:" "${SHLIB_ANSI_STYLE_CODES[0]}" "$*"
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

#
# Emoji Logging Functions
#

# @description Print an emoji error message to stderr (without newline)
# @arg $@ string The error message to print
# @stderr The message prefixed with "❌ "
# @exitcode 0 Always succeeds
# @example
#   shlib::eerror "Something went wrong"
shlib::eerror() {
    echo -n "❌ $*" >&2
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

# @description Print an emoji info message to stdout (without newline)
# @arg $@ string The info message to print
# @stdout The message prefixed with "ℹ️ "
# @exitcode 0 Always succeeds
# @example
#   shlib::einfo "Processing file"
shlib::einfo() {
    echo -n "ℹ️  $*"
}

# @description Print an emoji error message to stderr (with newline)
# @arg $@ string The error message to print
# @stderr The message prefixed with "❌ " followed by newline
# @exitcode 0 Always succeeds
# @example
#   shlib::eerrorn "Something went wrong"
shlib::eerrorn() {
    echo "❌ $*" >&2
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

# @description Print an emoji info message to stdout (with newline)
# @arg $@ string The info message to print
# @stdout The message prefixed with "ℹ️ " followed by newline
# @exitcode 0 Always succeeds
# @example
#   shlib::einfon "Processing complete"
shlib::einfon() {
    echo "ℹ️  $*"
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
    # shellcheck disable=SC1087
    eval "unset '$arr_name[$index]'"
    # shellcheck disable=SC1087
    eval "$arr_name=(\"\${$arr_name[@]}\")"
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
    # shellcheck disable=SC1087
    eval "len=\${#$arr_name[@]}"
    [[ $len -eq 0 ]] && return 0
    # shellcheck disable=SC1087
    eval "unset '$arr_name[$((len - 1))]'"
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

    # shellcheck disable=SC1087
    eval "len=\${#$arr_name[@]}"

    # Clamp index to valid range
    [[ $index -lt 0 ]] && index=0
    [[ $index -gt $len ]] && index=$len

    # Build new array with element inserted
    for ((idx = 0; idx < index; idx++)); do
        # shellcheck disable=SC1087
        eval "result+=(\"\${$arr_name[$idx]}\")"
    done

    result+=("$element")

    for ((idx = index; idx < len; idx++)); do
        # shellcheck disable=SC1087
        eval "result+=(\"\${$arr_name[$idx]}\")"
    done

    eval "$arr_name=(\"\${result[@]}\")"
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
    # shellcheck disable=SC1087
    eval "len=\${#$arr_name[@]}"
    [[ $len -eq 0 ]] && return 0
    # shellcheck disable=SC2034,SC2178
    local result="" first=1 elem
    # shellcheck disable=SC1087
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
    # shellcheck disable=SC1087
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
    # shellcheck disable=SC1087
    eval "len=\${#$arr_name[@]}"
    for ((i = len - 1; i >= 0; i--)); do
        # shellcheck disable=SC1087
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
    # shellcheck disable=SC1087
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

    # shellcheck disable=SC1087
    eval "len=\${#$arr_name[@]}"
    [[ $len -eq 0 ]] && return 0

    for ((idx = 0; idx < len; idx++)); do
        # shellcheck disable=SC1087
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
        # shellcheck disable=SC1087
        eval "len=\${#$src_name[@]}"
        for ((idx = 0; idx < len; idx++)); do
            # shellcheck disable=SC1087
            eval "$dest_name+=(\"\${$src_name[$idx]}\")"
        done
    done
}

#
# UI Functions
#

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
