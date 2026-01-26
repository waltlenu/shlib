#!/usr/bin/env bats

# ShellCheck Exclusions:
# - https://www.shellcheck.net/wiki/SC2034
# shellcheck disable=SC2034

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

@test "shlib::arr_pop removes last element" {
    local -a arr=(a b c d)
    shlib::arr_pop arr
    [[ "${#arr[@]}" == "3" ]]
    [[ "${arr[2]}" == "c" ]]
}

@test "shlib::arr_pop on single element array" {
    local -a arr=(only)
    shlib::arr_pop arr
    [[ "${#arr[@]}" == "0" ]]
}

@test "shlib::arr_pop on empty array does nothing" {
    local -a arr=()
    shlib::arr_pop arr
    [[ "${#arr[@]}" == "0" ]]
}

@test "shlib::arr_insert inserts at middle" {
    local -a arr=(a b c d)
    shlib::arr_insert arr 2 "X"
    [[ ${#arr[@]} -eq 5 ]]
    [[ "${arr[0]}" == "a" ]]
    [[ "${arr[1]}" == "b" ]]
    [[ "${arr[2]}" == "X" ]]
    [[ "${arr[3]}" == "c" ]]
    [[ "${arr[4]}" == "d" ]]
}

@test "shlib::arr_insert inserts at beginning" {
    local -a arr=(a b c)
    shlib::arr_insert arr 0 "X"
    [[ ${#arr[@]} -eq 4 ]]
    [[ "${arr[0]}" == "X" ]]
    [[ "${arr[1]}" == "a" ]]
}

@test "shlib::arr_insert inserts at end" {
    local -a arr=(a b c)
    shlib::arr_insert arr 3 "X"
    [[ ${#arr[@]} -eq 4 ]]
    [[ "${arr[2]}" == "c" ]]
    [[ "${arr[3]}" == "X" ]]
}

@test "shlib::arr_insert handles index beyond array length" {
    local -a arr=(a b)
    shlib::arr_insert arr 10 "X"
    [[ ${#arr[@]} -eq 3 ]]
    [[ "${arr[2]}" == "X" ]]
}

@test "shlib::arr_insert handles negative index" {
    local -a arr=(a b c)
    shlib::arr_insert arr -5 "X"
    [[ ${#arr[@]} -eq 4 ]]
    [[ "${arr[0]}" == "X" ]]
    [[ "${arr[1]}" == "a" ]]
}

@test "shlib::arr_insert into empty array" {
    local -a arr=()
    shlib::arr_insert arr 0 "X"
    [[ ${#arr[@]} -eq 1 ]]
    [[ "${arr[0]}" == "X" ]]
}

@test "shlib::arr_insert handles element with spaces" {
    local -a arr=(a b c)
    shlib::arr_insert arr 1 "hello world"
    [[ ${#arr[@]} -eq 4 ]]
    [[ "${arr[1]}" == "hello world" ]]
    [[ "${arr[2]}" == "b" ]]
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

@test "shlib::arr_print with default separator" {
    local -a arr=(a b c)
    run shlib::arr_print arr
    [[ "${output}" == "a b c" ]]
}

@test "shlib::arr_print with comma separator" {
    local -a arr=(a b c)
    run shlib::arr_print arr ","
    [[ "${output}" == "a,b,c" ]]
}

@test "shlib::arr_print with multi-char separator" {
    local -a arr=(a b c)
    run shlib::arr_print arr " | "
    [[ "${output}" == "a | b | c" ]]
}

@test "shlib::arr_print handles single element" {
    local -a arr=(only)
    run shlib::arr_print arr ","
    [[ "${output}" == "only" ]]
}

@test "shlib::arr_print handles empty array" {
    local -a arr=()
    run shlib::arr_print arr
    [[ "${output}" == "" ]]
}

@test "shlib::arr_printn prints each element on new line" {
    local -a arr=(a b c)
    run shlib::arr_printn arr
    [[ "${lines[0]}" == "a" ]]
    [[ "${lines[1]}" == "b" ]]
    [[ "${lines[2]}" == "c" ]]
}

@test "shlib::arr_printn handles single element" {
    local -a arr=(only)
    run shlib::arr_printn arr
    [[ "${output}" == "only" ]]
}

@test "shlib::arr_printn handles elements with spaces" {
    local -a arr=("hello world" "foo bar")
    run shlib::arr_printn arr
    [[ "${lines[0]}" == "hello world" ]]
    [[ "${lines[1]}" == "foo bar" ]]
}

@test "shlib::arr_uniq removes duplicates" {
    local -a arr=(a b a c b d)
    shlib::arr_uniq arr
    [[ ${#arr[@]} -eq 4 ]]
    [[ "${arr[0]}" == "a" ]]
    [[ "${arr[1]}" == "b" ]]
    [[ "${arr[2]}" == "c" ]]
    [[ "${arr[3]}" == "d" ]]
}

@test "shlib::arr_uniq preserves order of first occurrence" {
    local -a arr=(cherry apple cherry banana apple)
    shlib::arr_uniq arr
    [[ ${#arr[@]} -eq 3 ]]
    [[ "${arr[0]}" == "cherry" ]]
    [[ "${arr[1]}" == "apple" ]]
    [[ "${arr[2]}" == "banana" ]]
}

@test "shlib::arr_uniq handles array with no duplicates" {
    local -a arr=(a b c d)
    shlib::arr_uniq arr
    [[ ${#arr[@]} -eq 4 ]]
    [[ "${arr[0]}" == "a" ]]
    [[ "${arr[3]}" == "d" ]]
}

@test "shlib::arr_uniq handles array with all duplicates" {
    local -a arr=(x x x x)
    shlib::arr_uniq arr
    [[ ${#arr[@]} -eq 1 ]]
    [[ "${arr[0]}" == "x" ]]
}

@test "shlib::arr_uniq handles empty array" {
    local -a arr=()
    shlib::arr_uniq arr
    [[ ${#arr[@]} -eq 0 ]]
}

@test "shlib::arr_uniq handles single element" {
    local -a arr=(only)
    shlib::arr_uniq arr
    [[ ${#arr[@]} -eq 1 ]]
    [[ "${arr[0]}" == "only" ]]
}

@test "shlib::arr_uniq handles elements with spaces" {
    local -a arr=("hello world" "foo bar" "hello world" "baz")
    shlib::arr_uniq arr
    [[ ${#arr[@]} -eq 3 ]]
    [[ "${arr[0]}" == "hello world" ]]
    [[ "${arr[1]}" == "foo bar" ]]
    [[ "${arr[2]}" == "baz" ]]
}

@test "shlib::arr_merge merges two arrays" {
    local -a arr1=(a b)
    local -a arr2=(c d)
    local -a result
    shlib::arr_merge result arr1 arr2
    [[ ${#result[@]} -eq 4 ]]
    [[ "${result[0]}" == "a" ]]
    [[ "${result[1]}" == "b" ]]
    [[ "${result[2]}" == "c" ]]
    [[ "${result[3]}" == "d" ]]
}

@test "shlib::arr_merge merges three arrays" {
    local -a arr1=(a b)
    local -a arr2=(c)
    local -a arr3=(d e f)
    local -a result
    shlib::arr_merge result arr1 arr2 arr3
    [[ ${#result[@]} -eq 6 ]]
    [[ "${result[0]}" == "a" ]]
    [[ "${result[2]}" == "c" ]]
    [[ "${result[5]}" == "f" ]]
}

@test "shlib::arr_merge handles empty source arrays" {
    local -a arr1=(a b)
    local -a arr2=()
    local -a arr3=(c d)
    local -a result
    shlib::arr_merge result arr1 arr2 arr3
    [[ ${#result[@]} -eq 4 ]]
    [[ "${result[0]}" == "a" ]]
    [[ "${result[2]}" == "c" ]]
}

@test "shlib::arr_merge with single source array" {
    local -a arr1=(a b c)
    local -a result
    shlib::arr_merge result arr1
    [[ ${#result[@]} -eq 3 ]]
    [[ "${result[0]}" == "a" ]]
    [[ "${result[2]}" == "c" ]]
}

@test "shlib::arr_merge with no source arrays" {
    local -a result
    shlib::arr_merge result
    [[ ${#result[@]} -eq 0 ]]
}

@test "shlib::arr_merge handles elements with spaces" {
    local -a arr1=("hello world")
    local -a arr2=("foo bar" "baz")
    local -a result
    shlib::arr_merge result arr1 arr2
    [[ ${#result[@]} -eq 3 ]]
    [[ "${result[0]}" == "hello world" ]]
    [[ "${result[1]}" == "foo bar" ]]
    [[ "${result[2]}" == "baz" ]]
}

@test "shlib::arr_merge overwrites existing destination" {
    local -a arr1=(a b)
    local -a result=(x y z)
    shlib::arr_merge result arr1
    [[ ${#result[@]} -eq 2 ]]
    [[ "${result[0]}" == "a" ]]
    [[ "${result[1]}" == "b" ]]
}
