#!/usr/bin/env bats
# shellcheck disable=SC2154

# ShellCheck Exclusions:
# - https://www.shellcheck.net/wiki/SC2154

setup() {
    load 'test_helper'
}

@test "shlib::str_contains empty string in empty string" {
    shlib::str_contains "" ""
}

@test "shlib::str_contains handles empty substring" {
    shlib::str_contains "hello" ""
}

@test "shlib::str_contains returns 0 when substring found" {
    shlib::str_contains "hello world" "world"
}

@test "shlib::str_contains returns 1 when substring not found" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::str_contains "hello world" "foo"
}

@test "shlib::str_contains string equals substring" {
    shlib::str_contains "hello" "hello"
}

@test "shlib::str_endswith full string match" {
    shlib::str_endswith "hello" "hello"
}

@test "shlib::str_endswith handles empty suffix" {
    shlib::str_endswith "hello" ""
}

@test "shlib::str_endswith returns 0 when suffix matches" {
    shlib::str_endswith "hello world" "world"
}

@test "shlib::str_endswith returns 1 when suffix does not match" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::str_endswith "hello world" "hello"
}

@test "shlib::str_is_empty returns 0 for empty string" {
    shlib::str_is_empty ""
}

@test "shlib::str_is_empty returns 0 for mixed tabs and spaces" {
    shlib::str_is_empty $'\t  \t  \t'
}

@test "shlib::str_is_empty returns 0 for tabs only" {
    shlib::str_is_empty $'\t\t'
}

@test "shlib::str_is_empty returns 0 for whitespace-only string" {
    shlib::str_is_empty "   "
}

@test "shlib::str_is_empty returns 1 for non-empty string" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::str_is_empty "hello"
}

@test "shlib::str_is_empty returns 1 for string with content and whitespace" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::str_is_empty "  hello  "
}

@test "shlib::str_len counts byte length (not unicode codepoints)" {
    # Note: Bash ${#var} returns byte count for multibyte chars in some versions
    run shlib::str_len "abc"
    [[ "${output}" == "3" ]]
}

@test "shlib::str_len counts spaces" {
    run shlib::str_len "hello world"
    [[ "${output}" == "11" ]]
}

@test "shlib::str_len returns 0 for empty string" {
    run shlib::str_len ""
    [[ "${output}" == "0" ]]
}

@test "shlib::str_len returns correct length" {
    run shlib::str_len "hello"
    [[ "${output}" == "5" ]]
}

@test "shlib::str_ltrim preserves trailing whitespace" {
    run shlib::str_ltrim "hello  "
    [[ "${output}" == "hello  " ]]
}

@test "shlib::str_ltrim removes leading whitespace only" {
    run shlib::str_ltrim "  hello world  "
    [[ "${output}" == "hello world  " ]]
}

@test "shlib::str_ltrim with tabs only" {
    run shlib::str_ltrim $'\t\thello'
    [[ "${output}" == "hello" ]]
}

@test "shlib::str_padleft does not truncate longer strings" {
    run shlib::str_padleft "hello" 3 "0"
    [[ "${output}" == "hello" ]]
}

@test "shlib::str_padleft pads with default space" {
    run shlib::str_padleft "hi" 5
    [[ "${output}" == "   hi" ]]
}

@test "shlib::str_padleft pads with zeros" {
    run shlib::str_padleft "42" 5 "0"
    [[ "${output}" == "00042" ]]
}

@test "shlib::str_padleft with exact length string returns unchanged" {
    run shlib::str_padleft "hello" 5 "0"
    [[ "${output}" == "hello" ]]
}

@test "shlib::str_padleft with multi-character pad string" {
    run shlib::str_padleft "x" 5 "ab"
    # With multi-char pad, each iteration adds the whole string
    [[ "${#output}" -ge 5 ]]
    [[ "${output}" == *"x" ]]
}

@test "shlib::str_padright does not truncate longer strings" {
    run shlib::str_padright "hello" 3 "-"
    [[ "${output}" == "hello" ]]
}

@test "shlib::str_padright pads with dashes" {
    run shlib::str_padright "hi" 5 "-"
    [[ "${output}" == "hi---" ]]
}

@test "shlib::str_padright pads with default space" {
    run shlib::str_padright "hi" 5
    [[ "${output}" == "hi   " ]]
}

@test "shlib::str_padright with exact length string returns unchanged" {
    run shlib::str_padright "hello" 5 "-"
    [[ "${output}" == "hello" ]]
}

@test "shlib::str_padright with multi-character pad string" {
    run shlib::str_padright "x" 5 "ab"
    [[ "${#output}" -ge 5 ]]
    [[ "${output}" == "x"* ]]
}

@test "shlib::str_repeat handles empty string" {
    run shlib::str_repeat "" 5
    [[ "${output}" == "" ]]
}

@test "shlib::str_repeat handles string with spaces" {
    run shlib::str_repeat "a b" 2
    [[ "${output}" == "a ba b" ]]
}

@test "shlib::str_repeat repeats string N times" {
    run shlib::str_repeat "ab" 3
    [[ "${output}" == "ababab" ]]
}

@test "shlib::str_repeat with count 0" {
    run shlib::str_repeat "hello" 0
    [[ "${output}" == "" ]]
}

@test "shlib::str_repeat with count 1" {
    run shlib::str_repeat "hello" 1
    [[ "${output}" == "hello" ]]
}

@test "shlib::str_repeat with default count" {
    run shlib::str_repeat "test"
    [[ "${output}" == "test" ]]
}

@test "shlib::str_repeat with negative count returns empty" {
    run shlib::str_repeat "hello" -1
    [[ "${output}" == "" ]]
}

@test "shlib::str_repeat with single character" {
    run shlib::str_repeat "-" 5
    [[ "${output}" == "-----" ]]
}

@test "shlib::str_rtrim preserves leading whitespace" {
    run shlib::str_rtrim "  hello"
    [[ "${output}" == "  hello" ]]
}

@test "shlib::str_rtrim removes trailing whitespace only" {
    run shlib::str_rtrim "  hello world  "
    [[ "${output}" == "  hello world" ]]
}

@test "shlib::str_rtrim with tabs only" {
    run shlib::str_rtrim $'hello\t\t'
    [[ "${output}" == "hello" ]]
}

@test "shlib::str_split handles empty string" {
    shlib::str_split result ""
    [[ ${#result[@]} -eq 0 ]]
}

@test "shlib::str_split handles leading separator" {
    shlib::str_split result ",a,b" ","
    [[ ${#result[@]} -eq 3 ]]
    [[ "${result[0]}" == "" ]]
    [[ "${result[1]}" == "a" ]]
    [[ "${result[2]}" == "b" ]]
}

@test "shlib::str_split handles multi-character separator" {
    shlib::str_split result "a::b::c" "::"
    [[ ${#result[@]} -eq 3 ]]
    [[ "${result[0]}" == "a" ]]
    [[ "${result[1]}" == "b" ]]
    [[ "${result[2]}" == "c" ]]
}

@test "shlib::str_split handles string with no separator" {
    shlib::str_split result "hello" ","
    [[ ${#result[@]} -eq 1 ]]
    [[ "${result[0]}" == "hello" ]]
}

@test "shlib::str_split handles trailing separator" {
    shlib::str_split result "a,b," ","
    [[ ${#result[@]} -eq 3 ]]
    [[ "${result[0]}" == "a" ]]
    [[ "${result[1]}" == "b" ]]
    [[ "${result[2]}" == "" ]]
}

@test "shlib::str_split splits by comma" {
    shlib::str_split result "a,b,c" ","
    # shellcheck disable=SC2154
    [[ ${#result[@]} -eq 3 ]]
    [[ "${result[0]}" == "a" ]]
    [[ "${result[1]}" == "b" ]]
    [[ "${result[2]}" == "c" ]]
}

@test "shlib::str_split uses space as default separator" {
    shlib::str_split result "hello world foo"
    [[ ${#result[@]} -eq 3 ]]
    [[ "${result[0]}" == "hello" ]]
    [[ "${result[1]}" == "world" ]]
    [[ "${result[2]}" == "foo" ]]
}

@test "shlib::str_split with consecutive separators" {
    shlib::str_split result "a,,b" ","
    [[ ${#result[@]} -eq 3 ]]
    [[ "${result[0]}" == "a" ]]
    [[ "${result[1]}" == "" ]]
    [[ "${result[2]}" == "b" ]]
}

@test "shlib::str_split with empty separator splits into characters" {
    shlib::str_split result "abc" ""
    [[ ${#result[@]} -eq 3 ]]
    [[ "${result[0]}" == "a" ]]
    [[ "${result[1]}" == "b" ]]
    [[ "${result[2]}" == "c" ]]
}

@test "shlib::str_split with separator at both ends" {
    shlib::str_split result ",a,b," ","
    [[ ${#result[@]} -eq 4 ]]
    [[ "${result[0]}" == "" ]]
    [[ "${result[1]}" == "a" ]]
    [[ "${result[2]}" == "b" ]]
    [[ "${result[3]}" == "" ]]
}

@test "shlib::str_startswith full string match" {
    shlib::str_startswith "hello" "hello"
}

@test "shlib::str_startswith handles empty prefix" {
    shlib::str_startswith "hello" ""
}

@test "shlib::str_startswith returns 0 when prefix matches" {
    shlib::str_startswith "hello world" "hello"
}

@test "shlib::str_startswith returns 1 when prefix does not match" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::str_startswith "hello world" "world"
}

@test "shlib::str_to_lower converts to lowercase" {
    run shlib::str_to_lower "HELLO"
    [[ "${output}" == "hello" ]]
}

@test "shlib::str_to_lower handles mixed case" {
    run shlib::str_to_lower "HeLLo WoRLd"
    [[ "${output}" == "hello world" ]]
}

@test "shlib::str_to_lower preserves non-alpha characters" {
    run shlib::str_to_lower "HELLO123!"
    [[ "${output}" == "hello123!" ]]
}

@test "shlib::str_to_lower with empty string" {
    run shlib::str_to_lower ""
    [[ "${output}" == "" ]]
}

@test "shlib::str_to_upper converts to uppercase" {
    run shlib::str_to_upper "hello"
    [[ "${output}" == "HELLO" ]]
}

@test "shlib::str_to_upper handles mixed case" {
    run shlib::str_to_upper "HeLLo WoRLd"
    [[ "${output}" == "HELLO WORLD" ]]
}

@test "shlib::str_to_upper preserves non-alpha characters" {
    run shlib::str_to_upper "hello123!"
    [[ "${output}" == "HELLO123!" ]]
}

@test "shlib::str_to_upper with empty string" {
    run shlib::str_to_upper ""
    [[ "${output}" == "" ]]
}

@test "shlib::str_trim handles empty string" {
    run shlib::str_trim ""
    [[ "${output}" == "" ]]
}

@test "shlib::str_trim handles tabs and mixed whitespace" {
    run shlib::str_trim $'\t  hello world  \t'
    [[ "${output}" == "hello world" ]]
}

@test "shlib::str_trim removes leading and trailing whitespace" {
    run shlib::str_trim "  hello world  "
    [[ "${output}" == "hello world" ]]
}

@test "shlib::str_trim returns empty for whitespace-only input" {
    run shlib::str_trim "   "
    [[ "${output}" == "" ]]
}
