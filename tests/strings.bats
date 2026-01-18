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
