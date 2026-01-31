#!/usr/bin/env bash

#
# Example: Array functions from shlib
#

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source the library
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../shlib.sh"

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
# shellcheck disable=SC2154
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
