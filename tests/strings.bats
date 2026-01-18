#!/usr/bin/env bats

setup() {
    load 'test_helper'
}

@test "shlib::trim removes leading and trailing whitespace" {
    run shlib::trim "  hello world  "
    [[ "${output}" == "hello world" ]]
}

@test "shlib::trim handles tabs and mixed whitespace" {
    run shlib::trim $'\t  hello world  \t'
    [[ "${output}" == "hello world" ]]
}

@test "shlib::trim returns empty for whitespace-only input" {
    run shlib::trim "   "
    [[ "${output}" == "" ]]
}

@test "shlib::trim handles empty string" {
    run shlib::trim ""
    [[ "${output}" == "" ]]
}

@test "shlib::ltrim removes leading whitespace only" {
    run shlib::ltrim "  hello world  "
    [[ "${output}" == "hello world  " ]]
}

@test "shlib::ltrim preserves trailing whitespace" {
    run shlib::ltrim "hello  "
    [[ "${output}" == "hello  " ]]
}

@test "shlib::rtrim removes trailing whitespace only" {
    run shlib::rtrim "  hello world  "
    [[ "${output}" == "  hello world" ]]
}

@test "shlib::rtrim preserves leading whitespace" {
    run shlib::rtrim "  hello"
    [[ "${output}" == "  hello" ]]
}

@test "shlib::strlen returns correct length" {
    run shlib::strlen "hello"
    [[ "${output}" == "5" ]]
}

@test "shlib::strlen returns 0 for empty string" {
    run shlib::strlen ""
    [[ "${output}" == "0" ]]
}

@test "shlib::strlen counts spaces" {
    run shlib::strlen "hello world"
    [[ "${output}" == "11" ]]
}

@test "shlib::is_empty returns 0 for empty string" {
    shlib::is_empty ""
}

@test "shlib::is_empty returns 0 for whitespace-only string" {
    shlib::is_empty "   "
}

@test "shlib::is_empty returns 1 for non-empty string" {
    ! shlib::is_empty "hello"
}

@test "shlib::is_empty returns 1 for string with content and whitespace" {
    ! shlib::is_empty "  hello  "
}

@test "shlib::to_upper converts to uppercase" {
    run shlib::to_upper "hello"
    [[ "${output}" == "HELLO" ]]
}

@test "shlib::to_upper handles mixed case" {
    run shlib::to_upper "HeLLo WoRLd"
    [[ "${output}" == "HELLO WORLD" ]]
}

@test "shlib::to_upper preserves non-alpha characters" {
    run shlib::to_upper "hello123!"
    [[ "${output}" == "HELLO123!" ]]
}

@test "shlib::to_lower converts to lowercase" {
    run shlib::to_lower "HELLO"
    [[ "${output}" == "hello" ]]
}

@test "shlib::to_lower handles mixed case" {
    run shlib::to_lower "HeLLo WoRLd"
    [[ "${output}" == "hello world" ]]
}

@test "shlib::to_lower preserves non-alpha characters" {
    run shlib::to_lower "HELLO123!"
    [[ "${output}" == "hello123!" ]]
}
