#!/usr/bin/env bats

setup() {
    load 'test_helper'
}

@test "shlib::str_trim removes leading and trailing whitespace" {
    run shlib::str_trim "  hello world  "
    [[ "${output}" == "hello world" ]]
}

@test "shlib::str_trim handles tabs and mixed whitespace" {
    run shlib::str_trim $'\t  hello world  \t'
    [[ "${output}" == "hello world" ]]
}

@test "shlib::str_trim returns empty for whitespace-only input" {
    run shlib::str_trim "   "
    [[ "${output}" == "" ]]
}

@test "shlib::str_trim handles empty string" {
    run shlib::str_trim ""
    [[ "${output}" == "" ]]
}

@test "shlib::str_ltrim removes leading whitespace only" {
    run shlib::str_ltrim "  hello world  "
    [[ "${output}" == "hello world  " ]]
}

@test "shlib::str_ltrim preserves trailing whitespace" {
    run shlib::str_ltrim "hello  "
    [[ "${output}" == "hello  " ]]
}

@test "shlib::str_rtrim removes trailing whitespace only" {
    run shlib::str_rtrim "  hello world  "
    [[ "${output}" == "  hello world" ]]
}

@test "shlib::str_rtrim preserves leading whitespace" {
    run shlib::str_rtrim "  hello"
    [[ "${output}" == "  hello" ]]
}

@test "shlib::str_len returns correct length" {
    run shlib::str_len "hello"
    [[ "${output}" == "5" ]]
}

@test "shlib::str_len returns 0 for empty string" {
    run shlib::str_len ""
    [[ "${output}" == "0" ]]
}

@test "shlib::str_len counts spaces" {
    run shlib::str_len "hello world"
    [[ "${output}" == "11" ]]
}

@test "shlib::str_is_empty returns 0 for empty string" {
    shlib::str_is_empty ""
}

@test "shlib::str_is_empty returns 0 for whitespace-only string" {
    shlib::str_is_empty "   "
}

@test "shlib::str_is_empty returns 1 for non-empty string" {
    ! shlib::str_is_empty "hello"
}

@test "shlib::str_is_empty returns 1 for string with content and whitespace" {
    ! shlib::str_is_empty "  hello  "
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

@test "shlib::str_contains returns 0 when substring found" {
    shlib::str_contains "hello world" "world"
}

@test "shlib::str_contains returns 1 when substring not found" {
    ! shlib::str_contains "hello world" "foo"
}

@test "shlib::str_contains handles empty substring" {
    shlib::str_contains "hello" ""
}

@test "shlib::str_startswith returns 0 when prefix matches" {
    shlib::str_startswith "hello world" "hello"
}

@test "shlib::str_startswith returns 1 when prefix does not match" {
    ! shlib::str_startswith "hello world" "world"
}

@test "shlib::str_startswith handles empty prefix" {
    shlib::str_startswith "hello" ""
}

@test "shlib::str_endswith returns 0 when suffix matches" {
    shlib::str_endswith "hello world" "world"
}

@test "shlib::str_endswith returns 1 when suffix does not match" {
    ! shlib::str_endswith "hello world" "hello"
}

@test "shlib::str_endswith handles empty suffix" {
    shlib::str_endswith "hello" ""
}

@test "shlib::str_padleft pads with zeros" {
    run shlib::str_padleft "42" 5 "0"
    [[ "${output}" == "00042" ]]
}

@test "shlib::str_padleft pads with default space" {
    run shlib::str_padleft "hi" 5
    [[ "${output}" == "   hi" ]]
}

@test "shlib::str_padleft does not truncate longer strings" {
    run shlib::str_padleft "hello" 3 "0"
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

@test "shlib::str_padright does not truncate longer strings" {
    run shlib::str_padright "hello" 3 "-"
    [[ "${output}" == "hello" ]]
}

@test "shlib::str_split splits by comma" {
    shlib::str_split result "a,b,c" ","
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

@test "shlib::str_split handles empty string" {
    shlib::str_split result ""
    [[ ${#result[@]} -eq 0 ]]
}

@test "shlib::str_split handles string with no separator" {
    shlib::str_split result "hello" ","
    [[ ${#result[@]} -eq 1 ]]
    [[ "${result[0]}" == "hello" ]]
}

@test "shlib::str_split handles leading separator" {
    shlib::str_split result ",a,b" ","
    [[ ${#result[@]} -eq 3 ]]
    [[ "${result[0]}" == "" ]]
    [[ "${result[1]}" == "a" ]]
    [[ "${result[2]}" == "b" ]]
}

@test "shlib::str_split handles trailing separator" {
    shlib::str_split result "a,b," ","
    [[ ${#result[@]} -eq 3 ]]
    [[ "${result[0]}" == "a" ]]
    [[ "${result[1]}" == "b" ]]
    [[ "${result[2]}" == "" ]]
}

@test "shlib::str_split with empty separator splits into characters" {
    shlib::str_split result "abc" ""
    [[ ${#result[@]} -eq 3 ]]
    [[ "${result[0]}" == "a" ]]
    [[ "${result[1]}" == "b" ]]
    [[ "${result[2]}" == "c" ]]
}

@test "shlib::str_split handles multi-character separator" {
    shlib::str_split result "a::b::c" "::"
    [[ ${#result[@]} -eq 3 ]]
    [[ "${result[0]}" == "a" ]]
    [[ "${result[1]}" == "b" ]]
    [[ "${result[2]}" == "c" ]]
}
