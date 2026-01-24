#!/usr/bin/env bash
#
# Example: Basic usage of shlib
#

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source the library
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../shlib.sh"

# Print version
echo "shlib version: $(shlib::version)"
echo

#
# Core Functions
#
shlib::headern "Core Functions"

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
echo

# List all library functions
echo "shlib::list_functions (first 10):"
shlib::list_functions | head -10
echo "... ($(shlib::list_functions | wc -l | tr -d ' ') total functions)"
echo

#
# Logging Functions
#
shlib::headern "Logging Functions"

# With newline
shlib::infon "This is an info message (with newline)"
shlib::warnn "This is a warning message (with newline)"
shlib::errorn "This is an error message (with newline)"

# Without newline (need to add our own)
shlib::info "This is an info message (no newline)"
echo " <- manually added newline"
shlib::warn "This is a warning message (no newline)"
echo " <- manually added newline"
shlib::error "This is an error message (no newline)"
echo " <- manually added newline" >&2
echo

#
# Colorized Logging Functions
#
shlib::headern "Colorized Logging Functions"

# With newline
shlib::cinfon "This is a colorized info message (with newline)"
shlib::cwarnn "This is a colorized warning message (with newline)"
shlib::cerrorn "This is a colorized error message (with newline)"

# Without newline
shlib::cinfo "Colorized info (no newline)"
echo " <- added newline"
shlib::cwarn "Colorized warning (no newline)"
echo " <- added newline"
shlib::cerror "Colorized error (no newline)"
echo " <- added newline" >&2
echo

#
# Emoji Logging Functions
#
shlib::headern "Emoji Logging Functions"

# With newline
shlib::einfon "This is an emoji info message (with newline)"
shlib::ewarnn "This is an emoji warning message (with newline)"
shlib::eerrorn "This is an emoji error message (with newline)"

# Without newline
shlib::einfo "Emoji info (no newline)"
echo " <- added newline"
shlib::ewarn "Emoji warning (no newline)"
echo " <- added newline"
shlib::eerror "Emoji error (no newline)"
echo " <- added newline" >&2
echo

#
# Header Functions
#
shlib::headern "Header Functions"
shlib::header "This is a header without newline"
echo " <- see?"
shlib::headern "This is a header with newline"
echo

#
# String Manipulation Functions
#
shlib::headern "String Manipulation Functions"

# Trimming
input="  hello world  "
echo "Original string: [$input]"
echo "str_trim:   [$(shlib::str_trim "$input")]"
echo "str_ltrim:  [$(shlib::str_ltrim "$input")]"
echo "str_rtrim:  [$(shlib::str_rtrim "$input")]"
echo

# Length
str="hello"
echo "str_len \"$str\": $(shlib::str_len "$str")"
echo

# Empty check
if shlib::str_is_empty "   "; then
    echo "str_is_empty \"   \": true (whitespace only)"
fi
if ! shlib::str_is_empty "hello"; then
    echo "str_is_empty \"hello\": false (has content)"
fi
echo

# Case conversion
echo "str_to_upper \"hello\": $(shlib::str_to_upper "hello")"
echo "str_to_lower \"HELLO\": $(shlib::str_to_lower "HELLO")"
echo

# String searching
if shlib::str_contains "hello world" "world"; then
    echo "str_contains \"hello world\" \"world\": true"
fi
if shlib::str_startswith "hello world" "hello"; then
    echo "str_startswith \"hello world\" \"hello\": true"
fi
if shlib::str_endswith "hello world" "world"; then
    echo "str_endswith \"hello world\" \"world\": true"
fi
echo

# Padding
echo "str_padleft \"42\" 6 \"0\": [$(shlib::str_padleft "42" 6 "0")]"
echo "str_padright \"hi\" 6 \"-\": [$(shlib::str_padright "hi" 6 "-")]"
echo

# Splitting
csv="apple,banana,cherry"
echo "str_split \"$csv\" by \",\":"
shlib::str_split fruits_split "$csv" ","
echo "  Result: (${fruits_split[*]})"
echo "  Count: ${#fruits_split[@]}"

# Split with default space separator
sentence="one two three"
shlib::str_split words "$sentence"
echo "str_split \"$sentence\" by space: (${words[*]})"

# Split into characters
shlib::str_split chars "abc" ""
echo "str_split \"abc\" into chars: (${chars[*]})"
echo

#
# Array Functions
#
shlib::headern "Array Functions"

# Create an array
fruits=(apple banana cherry)
echo "Original array: (${fruits[*]})"
echo "arr_len: $(shlib::arr_len fruits)"
echo

# Append elements
shlib::arr_append fruits "date" "elderberry"
echo "After arr_append \"date\" \"elderberry\": (${fruits[*]})"
echo

# Delete element at index
shlib::arr_delete fruits 1
echo "After arr_delete at index 1: (${fruits[*]})"
echo

# Pop last element
shlib::arr_pop fruits
echo "After arr_pop: (${fruits[*]})"
echo

# Insert element at index
letters=(a b d e)
echo "Before arr_insert: (${letters[*]})"
shlib::arr_insert letters 2 "c"
echo "After arr_insert 2 \"c\": (${letters[*]})"
echo

# Sort array
colors=(red green blue yellow)
echo "Before arr_sort: (${colors[*]})"
shlib::arr_sort colors
echo "After arr_sort:  (${colors[*]})"
echo

# Reverse array
numbers=(1 2 3 4 5)
echo "Before arr_reverse: (${numbers[*]})"
shlib::arr_reverse numbers
echo "After arr_reverse:  (${numbers[*]})"
echo

# Remove duplicates
duplicates=(a b a c b d a)
echo "Before arr_uniq: (${duplicates[*]})"
shlib::arr_uniq duplicates
echo "After arr_uniq:  (${duplicates[*]})"
echo

# Merge arrays
arr1=(a b c)
arr2=(d e)
arr3=(f g h)
echo "arr1: (${arr1[*]})"
echo "arr2: (${arr2[*]})"
echo "arr3: (${arr3[*]})"
shlib::arr_merge merged arr1 arr2 arr3
echo "After arr_merge: (${merged[*]})"
echo

# Print array with separator
# shellcheck disable=SC2034
items=(one two three)
echo "arr_print with space: $(shlib::arr_print items)"
echo "arr_print with comma: $(shlib::arr_print items ",")"
echo "arr_print with ' | ': $(shlib::arr_print items " | ")"
echo

# Print array one per line
echo "arr_printn:"
shlib::arr_printn items
echo

#
# UI Functions
#
shlib::headern "UI Functions"

# ANSI color reference functions
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
echo

# Spinner - runs a command while showing an animation
echo "Running a command with spinner..."
if shlib::spinner "Simulating work" sleep 3; then
    shlib::einfon "Command completed successfully"
else
    shlib::eerrorn "Command failed"
fi
echo

shlib::einfon "All examples completed!"
