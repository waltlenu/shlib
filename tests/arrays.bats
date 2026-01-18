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

@test "shlib::arr_append adds single element" {
    local -a arr=(a b)
    shlib::arr_append arr c
    [[ "${#arr[@]}" == "3" ]]
    [[ "${arr[2]}" == "c" ]]
}

@test "shlib::arr_append adds multiple elements" {
    local -a arr=(a)
    shlib::arr_append arr b c d
    [[ "${#arr[@]}" == "4" ]]
    [[ "${arr[3]}" == "d" ]]
}

@test "shlib::arr_append handles elements with spaces" {
    local -a arr=()
    shlib::arr_append arr "hello world" "foo bar"
    [[ "${#arr[@]}" == "2" ]]
    [[ "${arr[0]}" == "hello world" ]]
}

@test "shlib::arr_delete removes element by index" {
    local -a arr=(a b c d)
    shlib::arr_delete arr 1
    [[ "${#arr[@]}" == "3" ]]
    [[ "${arr[0]}" == "a" ]]
    [[ "${arr[1]}" == "c" ]]
    [[ "${arr[2]}" == "d" ]]
}

@test "shlib::arr_delete removes first element" {
    local -a arr=(a b c)
    shlib::arr_delete arr 0
    [[ "${#arr[@]}" == "2" ]]
    [[ "${arr[0]}" == "b" ]]
}

@test "shlib::arr_delete removes last element" {
    local -a arr=(a b c)
    shlib::arr_delete arr 2
    [[ "${#arr[@]}" == "2" ]]
    [[ "${arr[1]}" == "b" ]]
}

@test "shlib::arr_sort sorts alphabetically" {
    local -a arr=(cherry apple banana)
    shlib::arr_sort arr
    [[ "${arr[0]}" == "apple" ]]
    [[ "${arr[1]}" == "banana" ]]
    [[ "${arr[2]}" == "cherry" ]]
}

@test "shlib::arr_sort handles numbers as strings" {
    local -a arr=(10 2 1 20)
    shlib::arr_sort arr
    [[ "${arr[0]}" == "1" ]]
    [[ "${arr[1]}" == "10" ]]
    [[ "${arr[2]}" == "2" ]]
    [[ "${arr[3]}" == "20" ]]
}

@test "shlib::arr_sort handles single element" {
    local -a arr=(only)
    shlib::arr_sort arr
    [[ "${arr[0]}" == "only" ]]
}

@test "shlib::arr_reverse reverses array" {
    local -a arr=(a b c d)
    shlib::arr_reverse arr
    [[ "${arr[0]}" == "d" ]]
    [[ "${arr[1]}" == "c" ]]
    [[ "${arr[2]}" == "b" ]]
    [[ "${arr[3]}" == "a" ]]
}

@test "shlib::arr_reverse handles single element" {
    local -a arr=(only)
    shlib::arr_reverse arr
    [[ "${arr[0]}" == "only" ]]
}

@test "shlib::arr_reverse handles two elements" {
    local -a arr=(first second)
    shlib::arr_reverse arr
    [[ "${arr[0]}" == "second" ]]
    [[ "${arr[1]}" == "first" ]]
}
