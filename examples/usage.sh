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

#
# Logging Functions
#
shlib::headern "Logging Functions"
shlib::infon "This is an info message"
shlib::warnn "This is a warning message"
shlib::errorn "This is an error message"
echo

#
# Colorized Logging Functions
#
shlib::headern "Colorized Logging Functions"
shlib::cinfon "This is a colorized info message"
shlib::cwarnn "This is a colorized warning message"
shlib::cerrorn "This is a colorized error message"
echo

#
# Emoji Logging Functions
#
shlib::headern "Emoji Logging Functions"
shlib::einfon "This is an emoji info message"
shlib::ewarnn "This is an emoji warning message"
shlib::eerrorn "This is an emoji error message"
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

# Spinner - runs a command while showing an animation
echo "Running a command with spinner..."
if shlib::spinner "Simulating work" sleep 1; then
  shlib::einfon "Command completed successfully"
else
  shlib::eerrorn "Command failed"
fi
echo

# Color table - display all ANSI colors and escape codes
echo "Color table (showing first few lines):"
shlib::color_table
echo

shlib::einfon "All examples completed!"
