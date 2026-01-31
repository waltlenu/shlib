#!/usr/bin/env bash

#
# Example: String manipulation functions from shlib
#

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source the library
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../shlib.sh"

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

# Repeating
echo "str_repeat \"ab\" 3: $(shlib::str_repeat "ab" 3)"
echo "str_repeat \"-\" 10: $(shlib::str_repeat "-" 10)"
echo

# Splitting
csv="apple,banana,cherry"
echo "str_split \"$csv\" by \",\":"
shlib::str_split fruits_split "$csv" ","
# shellcheck disable=SC2154
echo "  Result: (${fruits_split[*]})"
echo "  Count: ${#fruits_split[@]}"

# Split with default space separator
sentence="one two three"
shlib::str_split words "$sentence"
# shellcheck disable=SC2154
echo "str_split \"$sentence\" by space: (${words[*]})"

# Split into characters
shlib::str_split chars "abc" ""
# shellcheck disable=SC2154
echo "str_split \"abc\" into chars: (${chars[*]})"
