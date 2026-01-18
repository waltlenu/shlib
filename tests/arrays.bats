#!/usr/bin/env bats

setup() {
    load 'test_helper'
}

@test "shlib::arr_len returns correct count" {
    local -a arr=(a b c d e)
    run shlib::arr_len arr
    [[ "${output}" == "5" ]]
}

@test "shlib::arr_len returns 0 for empty array" {
    local -a arr=()
    run shlib::arr_len arr
    [[ "${output}" == "0" ]]
}

@test "shlib::arr_len handles array with spaces in elements" {
    local -a arr=("hello world" "foo bar" "baz")
    run shlib::arr_len arr
    [[ "${output}" == "3" ]]
}

@test "shlib::arr_len handles single element array" {
    local -a arr=("only one")
    run shlib::arr_len arr
    [[ "${output}" == "1" ]]
}
