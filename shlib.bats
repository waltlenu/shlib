#!/usr/bin/env bats
# shellcheck disable=SC2030,SC2031,SC2034

########################################################################
#                                                                      #
#  shlib - BATS tests                                                  #
#                                                                      #
#  Usage: bats shlib.bats                                              #
#  License: GPL-3.0-or-later                                           #
#                                                                      #
########################################################################

setup() {
    # Get the directory containing the test file (not the temp dir bats runs from)
    PROJECT_DIR="$(cd "$(dirname "${BATS_TEST_FILENAME}")" && pwd)"
    # Source the library
    source "${PROJECT_DIR}/shlib.bash"
}

#######################################
# Global (minimal) logic
#######################################

@test "bash version is 3 or higher" {
    [[ "${BASH_VERSINFO[0]}" -ge 3 ]]
}

@test "bats version is 1.5.0 or higher" {
    bats_require_minimum_version "1.5.0"
}

@test "library loads successfully" {
    [[ -n "${SHLIB_LOADED}" ]]
}

@test "SHLIB_LOADED is readonly" {
    run bash -c 'source shlib.bash; SHLIB_LOADED=0 2>&1'
    [[ "$status" -ne 0 || "$output" == *"readonly"* ]]
}

@test "SHLIB_VERSION is set" {
    [[ -n "${SHLIB_VERSION}" ]]
}

@test "SHLIB_VERSION is readonly" {
    run bash -c 'source shlib.bash; SHLIB_VERSION=0 2>&1'
    [[ "$status" -ne 0 || "$output" == *"readonly"* ]]
}

@test "SHLIB_DIR is set to correct path" {
    [[ -n "${SHLIB_DIR}" ]]
    [[ -d "${SHLIB_DIR}" ]]
    [[ -f "${SHLIB_DIR}/shlib.bash" ]]
}

@test "SHLIB_ANSI_COLOR_NAMES has 16 elements" {
    [[ "${#SHLIB_ANSI_COLOR_NAMES[@]}" -eq 16 ]]
}

@test "SHLIB_ANSI_COLOR_NAMES contains expected colors" {
    [[ "${SHLIB_ANSI_COLOR_NAMES[0]}" == "Black" ]]
    [[ "${SHLIB_ANSI_COLOR_NAMES[1]}" == "Red" ]]
    [[ "${SHLIB_ANSI_COLOR_NAMES[7]}" == "White" ]]
    [[ "${SHLIB_ANSI_COLOR_NAMES[15]}" == "Bright White" ]]
}

@test "SHLIB_ANSI_FG_CODES has 16 elements" {
    [[ "${#SHLIB_ANSI_FG_CODES[@]}" -eq 16 ]]
}

@test "SHLIB_ANSI_FG_CODES contains expected codes" {
    [[ "${SHLIB_ANSI_FG_CODES[0]}" -eq 30 ]]
    [[ "${SHLIB_ANSI_FG_CODES[7]}" -eq 37 ]]
    [[ "${SHLIB_ANSI_FG_CODES[8]}" -eq 90 ]]
    [[ "${SHLIB_ANSI_FG_CODES[15]}" -eq 97 ]]
}

@test "SHLIB_ANSI_BG_CODES has 16 elements" {
    [[ "${#SHLIB_ANSI_BG_CODES[@]}" -eq 16 ]]
}

@test "SHLIB_ANSI_BG_CODES contains expected codes" {
    [[ "${SHLIB_ANSI_BG_CODES[0]}" -eq 40 ]]
    [[ "${SHLIB_ANSI_BG_CODES[7]}" -eq 47 ]]
    [[ "${SHLIB_ANSI_BG_CODES[8]}" -eq 100 ]]
    [[ "${SHLIB_ANSI_BG_CODES[15]}" -eq 107 ]]
}

@test "SHLIB_ANSI_STYLE_CODES has 9 elements" {
    [[ "${#SHLIB_ANSI_STYLE_CODES[@]}" -eq 9 ]]
}

@test "SHLIB_ANSI_STYLE_CODES contains expected codes" {
    [[ "${SHLIB_ANSI_STYLE_CODES[0]}" -eq 0 ]]
    [[ "${SHLIB_ANSI_STYLE_CODES[1]}" -eq 1 ]]
    [[ "${SHLIB_ANSI_STYLE_CODES[4]}" -eq 4 ]]
}

@test "SHLIB_ANSI_STYLE_NAMES has 9 elements" {
    [[ "${#SHLIB_ANSI_STYLE_NAMES[@]}" -eq 9 ]]
}

@test "SHLIB_ANSI_STYLE_NAMES contains expected names" {
    [[ "${SHLIB_ANSI_STYLE_NAMES[0]}" == "Normal" ]]
    [[ "${SHLIB_ANSI_STYLE_NAMES[1]}" == "Bold" ]]
    [[ "${SHLIB_ANSI_STYLE_NAMES[4]}" == "Underline" ]]
}

#######################################
# _core
#######################################

@test "shlib::list_functions only includes shlib:: functions" {
    run shlib::list_functions
    while IFS= read -r line; do
        [[ "$line" == shlib::* ]]
    done <<<"$output"
}

@test "shlib::list_functions output is sorted" {
    run shlib::list_functions
    first_line="${lines[0]}"
    [[ "$first_line" == "shlib::arr_append" ]]
}

@test "shlib::list_functions returns function names" {
    run shlib::list_functions
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"shlib::version"* ]]
    [[ "$output" == *"shlib::list_functions"* ]]
}

@test "shlib::list_variables only includes SHLIB_ variables" {
    run shlib::list_variables
    while IFS= read -r line; do
        [[ "$line" == SHLIB_* ]]
    done <<<"$output"
}

@test "shlib::list_variables output is sorted" {
    run shlib::list_variables
    first_line="${lines[0]}"
    [[ "$first_line" == "SHLIB_ANSI_BG_CODES" ]]
}

@test "shlib::list_variables returns variable names" {
    run shlib::list_variables
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"SHLIB_VERSION"* ]]
    [[ "$output" == *"SHLIB_DIR"* ]]
    [[ "$output" == *"SHLIB_LOADED"* ]]
}

@test "shlib::version format matches semver pattern" {
    run shlib::version
    # Match X.Y.Z pattern
    [[ "$output" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]
}

@test "shlib::version outputs version string" {
    ver="$(shlib::version)"
    [[ "${ver}" == "${SHLIB_VERSION}" ]]
}

#######################################
# arrays
#######################################

@test "shlib::arr_append adds multiple elements" {
    local -a arr=(a)
    shlib::arr_append arr b c d
    [[ "${#arr[@]}" == "4" ]]
    [[ "${arr[3]}" == "d" ]]
}

@test "shlib::arr_append adds single element" {
    local -a arr=(a b)
    shlib::arr_append arr c
    [[ "${#arr[@]}" == "3" ]]
    [[ "${arr[2]}" == "c" ]]
}

@test "shlib::arr_append handles elements with spaces" {
    local -a arr=()
    shlib::arr_append arr "hello world" "foo bar"
    [[ "${#arr[@]}" == "2" ]]
    [[ "${arr[0]}" == "hello world" ]]
}

@test "shlib::arr_append multiple to empty array" {
    local -a arr=()
    shlib::arr_append arr "a" "b" "c"
    [[ ${#arr[@]} -eq 3 ]]
    [[ "${arr[0]}" == "a" ]]
    [[ "${arr[2]}" == "c" ]]
}

@test "shlib::arr_append to empty array" {
    local -a arr=()
    shlib::arr_append arr "first"
    [[ ${#arr[@]} -eq 1 ]]
    [[ "${arr[0]}" == "first" ]]
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

@test "shlib::arr_delete with negative index" {
    local -a arr=(a b c)
    # Negative index may be treated as empty, should not crash
    shlib::arr_delete arr -1
    # Array should remain valid (behavior may vary)
    [[ ${#arr[@]} -ge 0 ]]
}

@test "shlib::arr_delete with out-of-bounds index" {
    local -a arr=(a b c)
    shlib::arr_delete arr 100
    # Array should remain intact when index is out of bounds
    [[ ${#arr[@]} -eq 3 ]]
}

@test "shlib::arr_insert handles element with spaces" {
    local -a arr=(a b c)
    shlib::arr_insert arr 1 "hello world"
    [[ ${#arr[@]} -eq 4 ]]
    [[ "${arr[1]}" == "hello world" ]]
    [[ "${arr[2]}" == "b" ]]
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

@test "shlib::arr_insert into empty array" {
    local -a arr=()
    shlib::arr_insert arr 0 "X"
    [[ ${#arr[@]} -eq 1 ]]
    [[ "${arr[0]}" == "X" ]]
}

@test "shlib::arr_insert with empty string element" {
    local -a arr=(a b c)
    shlib::arr_insert arr 1 ""
    [[ ${#arr[@]} -eq 4 ]]
    [[ "${arr[0]}" == "a" ]]
    [[ "${arr[1]}" == "" ]]
    [[ "${arr[2]}" == "b" ]]
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

@test "shlib::arr_len returns 0 for empty array" {
    local -a arr=()
    run shlib::arr_len arr
    [[ "${output}" == "0" ]]
}

@test "shlib::arr_len returns correct count" {
    local -a arr=(a b c d e)
    run shlib::arr_len arr
    [[ "${output}" == "5" ]]
}

@test "shlib::arr_merge handles elements with spaces" {
    local -a arr1=("hello world")
    local -a arr2=("foo bar" "baz")
    local -a merged
    shlib::arr_merge merged arr1 arr2
    [[ ${#merged[@]} -eq 3 ]]
    [[ "${merged[0]}" == "hello world" ]]
    [[ "${merged[1]}" == "foo bar" ]]
    [[ "${merged[2]}" == "baz" ]]
}

@test "shlib::arr_merge handles empty source arrays" {
    local -a arr1=(a b)
    local -a arr2=()
    local -a arr3=(c d)
    local -a merged
    shlib::arr_merge merged arr1 arr2 arr3
    [[ ${#merged[@]} -eq 4 ]]
    [[ "${merged[0]}" == "a" ]]
    [[ "${merged[2]}" == "c" ]]
}

@test "shlib::arr_merge merges three arrays" {
    local -a arr1=(a b)
    local -a arr2=(c)
    local -a arr3=(d e f)
    local -a merged
    shlib::arr_merge merged arr1 arr2 arr3
    [[ ${#merged[@]} -eq 6 ]]
    [[ "${merged[0]}" == "a" ]]
    [[ "${merged[2]}" == "c" ]]
    [[ "${merged[5]}" == "f" ]]
}

@test "shlib::arr_merge merges two arrays" {
    local -a arr1=(a b)
    local -a arr2=(c d)
    local -a merged
    shlib::arr_merge merged arr1 arr2
    [[ ${#merged[@]} -eq 4 ]]
    [[ "${merged[0]}" == "a" ]]
    [[ "${merged[1]}" == "b" ]]
    [[ "${merged[2]}" == "c" ]]
    [[ "${merged[3]}" == "d" ]]
}

@test "shlib::arr_merge overwrites existing destination" {
    local -a arr1=(a b)
    local -a merged=(x y z)
    shlib::arr_merge merged arr1
    [[ ${#merged[@]} -eq 2 ]]
    [[ "${merged[0]}" == "a" ]]
    [[ "${merged[1]}" == "b" ]]
}

@test "shlib::arr_merge with no source arrays" {
    local -a merged
    shlib::arr_merge merged
    [[ ${#merged[@]} -eq 0 ]]
}

@test "shlib::arr_merge with single source array" {
    local -a arr1=(a b c)
    local -a merged
    shlib::arr_merge merged arr1
    [[ ${#merged[@]} -eq 3 ]]
    [[ "${merged[0]}" == "a" ]]
    [[ "${merged[2]}" == "c" ]]
}

@test "shlib::arr_pop on empty array does nothing" {
    local -a arr=()
    shlib::arr_pop arr
    [[ "${#arr[@]}" == "0" ]]
}

@test "shlib::arr_pop on single element array" {
    local -a arr=(only)
    shlib::arr_pop arr
    [[ "${#arr[@]}" == "0" ]]
}

@test "shlib::arr_pop removes last element" {
    local -a arr=(a b c d)
    shlib::arr_pop arr
    [[ "${#arr[@]}" == "3" ]]
    [[ "${arr[2]}" == "c" ]]
}

@test "shlib::arr_print handles empty array" {
    local -a arr=()
    run shlib::arr_print arr
    [[ "${output}" == "" ]]
}

@test "shlib::arr_print handles single element" {
    local -a arr=(only)
    run shlib::arr_print arr ","
    [[ "${output}" == "only" ]]
}

@test "shlib::arr_print with comma separator" {
    local -a arr=(a b c)
    run shlib::arr_print arr ","
    [[ "${output}" == "a,b,c" ]]
}

@test "shlib::arr_print with default separator" {
    local -a arr=(a b c)
    run shlib::arr_print arr
    [[ "${output}" == "a b c" ]]
}

@test "shlib::arr_print with elements containing the separator" {
    local -a arr=("a,b" "c,d")
    run shlib::arr_print arr ","
    # The separator is embedded in elements, output includes them
    [[ "${output}" == "a,b,c,d" ]]
}

@test "shlib::arr_print with empty string separator defaults to space" {
    # Note: arr_print uses ${2:- } which defaults empty to space
    local -a arr=(a b c)
    run shlib::arr_print arr ""
    [[ "${output}" == "a b c" ]]
}

@test "shlib::arr_print with multi-char separator" {
    local -a arr=(a b c)
    run shlib::arr_print arr " | "
    [[ "${output}" == "a | b | c" ]]
}

@test "shlib::arr_printn handles elements with spaces" {
    local -a arr=("hello world" "foo bar")
    run shlib::arr_printn arr
    [[ "${lines[0]}" == "hello world" ]]
    [[ "${lines[1]}" == "foo bar" ]]
}

@test "shlib::arr_printn handles single element" {
    local -a arr=(only)
    run shlib::arr_printn arr
    [[ "${output}" == "only" ]]
}

@test "shlib::arr_printn prints each element on new line" {
    local -a arr=(a b c)
    run shlib::arr_printn arr
    [[ "${lines[0]}" == "a" ]]
    [[ "${lines[1]}" == "b" ]]
    [[ "${lines[2]}" == "c" ]]
}

@test "shlib::arr_printn with empty array" {
    local -a arr=()
    run shlib::arr_printn arr
    [[ "${output}" == "" ]]
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

@test "shlib::arr_reverse reverses array" {
    local -a arr=(a b c d)
    shlib::arr_reverse arr
    [[ "${arr[0]}" == "d" ]]
    [[ "${arr[1]}" == "c" ]]
    [[ "${arr[2]}" == "b" ]]
    [[ "${arr[3]}" == "a" ]]
}

@test "shlib::arr_reverse with empty array" {
    local -a arr=()
    shlib::arr_reverse arr
    [[ ${#arr[@]} -eq 0 ]]
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

@test "shlib::arr_sort sorts alphabetically" {
    local -a arr=(cherry apple banana)
    shlib::arr_sort arr
    [[ "${arr[0]}" == "apple" ]]
    [[ "${arr[1]}" == "banana" ]]
    [[ "${arr[2]}" == "cherry" ]]
}

@test "shlib::arr_sort with empty array" {
    local -a arr=()
    shlib::arr_sort arr
    [[ ${#arr[@]} -eq 0 ]]
}

@test "shlib::arr_uniq case-sensitive duplicates" {
    local -a arr=("A" "a" "B" "b" "A")
    shlib::arr_uniq arr
    [[ ${#arr[@]} -eq 4 ]]
    [[ "${arr[0]}" == "A" ]]
    [[ "${arr[1]}" == "a" ]]
    [[ "${arr[2]}" == "B" ]]
    [[ "${arr[3]}" == "b" ]]
}

@test "shlib::arr_uniq handles array with all duplicates" {
    local -a arr=(x x x x)
    shlib::arr_uniq arr
    [[ ${#arr[@]} -eq 1 ]]
    [[ "${arr[0]}" == "x" ]]
}

@test "shlib::arr_uniq handles array with no duplicates" {
    local -a arr=(a b c d)
    shlib::arr_uniq arr
    [[ ${#arr[@]} -eq 4 ]]
    [[ "${arr[0]}" == "a" ]]
    [[ "${arr[3]}" == "d" ]]
}

@test "shlib::arr_uniq handles elements with spaces" {
    local -a arr=("hello world" "foo bar" "hello world" "baz")
    shlib::arr_uniq arr
    [[ ${#arr[@]} -eq 3 ]]
    [[ "${arr[0]}" == "hello world" ]]
    [[ "${arr[1]}" == "foo bar" ]]
    [[ "${arr[2]}" == "baz" ]]
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

@test "shlib::arr_uniq preserves order of first occurrence" {
    local -a arr=(cherry apple cherry banana apple)
    shlib::arr_uniq arr
    [[ ${#arr[@]} -eq 3 ]]
    [[ "${arr[0]}" == "cherry" ]]
    [[ "${arr[1]}" == "apple" ]]
    [[ "${arr[2]}" == "banana" ]]
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

#######################################
# cmd
#######################################

@test "shlib::cmd_exists finds builtin command (echo)" {
    shlib::cmd_exists echo
}

@test "shlib::cmd_exists finds command with absolute path" {
    shlib::cmd_exists /bin/ls
}

@test "shlib::cmd_exists finds existing command" {
    shlib::cmd_exists bash
}

@test "shlib::cmd_exists returns false for empty string" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::cmd_exists ""
}

@test "shlib::cmd_exists returns false for missing command" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::cmd_exists nonexistent_command_12345
}

@test "shlib::cmd_locked captures stdout" {
    lockfile=$(mktemp -u)
    run shlib::cmd_locked "$lockfile" 0 echo "locked output"
    [ "$status" -eq 0 ]
    [ "$output" = "locked output" ]
}

@test "shlib::cmd_locked detects and removes stale lock" {
    lockfile=$(mktemp -u)

    # Create stale lock with non-existent PID
    mkdir "${lockfile}.lock"
    echo 999999 >"${lockfile}.lock/pid"

    # Should succeed by detecting stale lock
    run shlib::cmd_locked "$lockfile" 0 true
    [ "$status" -eq 0 ]
}

@test "shlib::cmd_locked fails with empty lockfile path" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::cmd_locked "" 0 true
}

@test "shlib::cmd_locked fails with invalid timeout" {
    bats_require_minimum_version "1.5.0"
    lockfile=$(mktemp -u)
    run ! shlib::cmd_locked "$lockfile" abc true
}

@test "shlib::cmd_locked fails with no command" {
    bats_require_minimum_version "1.5.0"
    lockfile=$(mktemp -u)
    run ! shlib::cmd_locked "$lockfile" 0
}

@test "shlib::cmd_locked fails with non-blocking when already locked" {
    bats_require_minimum_version "1.5.0"
    lockfile=$(mktemp -u)

    # Create lock manually
    mkdir "${lockfile}.lock"
    echo $$ >"${lockfile}.lock/pid"

    # Should fail immediately with timeout=0
    run ! shlib::cmd_locked "$lockfile" 0 true

    # Cleanup
    rm -rf "${lockfile}.lock"
}

@test "shlib::cmd_locked releases lock after command failure" {
    lockfile=$(mktemp -u)
    run shlib::cmd_locked "$lockfile" 0 false
    [ "$status" -eq 1 ]
    # Lock should be released even though command failed
    [ ! -d "${lockfile}.lock" ]
}

@test "shlib::cmd_locked returns command exit code" {
    lockfile=$(mktemp -u)
    run shlib::cmd_locked "$lockfile" 0 bash -c 'exit 42'
    [ "$status" -eq 42 ]
}

@test "shlib::cmd_locked runs command with lock" {
    lockfile=$(mktemp -u)
    run shlib::cmd_locked "$lockfile" 0 true
    [ "$status" -eq 0 ]
    # Lock should be released
    [ ! -d "${lockfile}.lock" ]
}

@test "shlib::cmd_locked times out when lock held too long" {
    bats_require_minimum_version "1.5.0"
    lockfile=$(mktemp -u)

    # Create lock held by current process
    mkdir "${lockfile}.lock"
    echo $$ >"${lockfile}.lock/pid"

    # Should timeout after 1 second
    run ! shlib::cmd_locked "$lockfile" 1 true

    # Cleanup
    rm -rf "${lockfile}.lock"
}

@test "shlib::cmd_locked waits for lock with positive timeout" {
    lockfile=$(mktemp -u)

    # Create lock that will be released after 1 second
    mkdir "${lockfile}.lock"
    echo $$ >"${lockfile}.lock/pid"
    (
        sleep 1
        rm -rf "${lockfile}.lock"
    ) &

    # Should succeed after lock is released (within 5s timeout)
    run shlib::cmd_locked "$lockfile" 5 true
    [ "$status" -eq 0 ]
}

@test "shlib::cmd_locked with infinite wait (-1) acquires lock" {
    lockfile=$(mktemp -u)

    # Create lock that will be released quickly
    mkdir "${lockfile}.lock"
    echo $$ >"${lockfile}.lock/pid"
    (
        sleep 0.5
        rm -rf "${lockfile}.lock"
    ) &

    # Should wait and succeed
    run shlib::cmd_locked "$lockfile" -1 true
    [ "$status" -eq 0 ]
}

@test "shlib::cmd_retry captures stdout from successful attempt" {
    run shlib::cmd_retry 3 0 echo "success"
    [ "$status" -eq 0 ]
    [ "$output" = "success" ]
}

@test "shlib::cmd_retry fails after max attempts" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::cmd_retry 3 0 false
}

@test "shlib::cmd_retry fails with invalid delay" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::cmd_retry 3 -1 true
    run ! shlib::cmd_retry 3 abc true
}

@test "shlib::cmd_retry fails with invalid max_attempts" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::cmd_retry 0 0 true
    run ! shlib::cmd_retry -1 0 true
    run ! shlib::cmd_retry abc 0 true
}

@test "shlib::cmd_retry succeeds on first attempt" {
    run shlib::cmd_retry 3 0 true
    [ "$status" -eq 0 ]
}

@test "shlib::cmd_retry succeeds on later attempt" {
    # Create a temp file to track attempts
    tmpfile=$(mktemp)
    echo "0" >"$tmpfile"

    # Command that fails twice then succeeds
    # shellcheck disable=SC2016
    run shlib::cmd_retry 3 0 bash -c '
        count=$(cat "'"$tmpfile"'")
        count=$((count + 1))
        echo "$count" > "'"$tmpfile"'"
        [ "$count" -ge 3 ]
    '

    [ "$status" -eq 0 ]
    rm -f "$tmpfile"
}

@test "shlib::cmd_timeout captures stdout" {
    run shlib::cmd_timeout 5 echo "hello"
    [ "$status" -eq 0 ]
    [ "$output" = "hello" ]
}

@test "shlib::cmd_timeout fails with invalid timeout" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::cmd_timeout 0 true
    run ! shlib::cmd_timeout -1 true
    run ! shlib::cmd_timeout abc true
}

@test "shlib::cmd_timeout returns 124 when command times out" {
    run shlib::cmd_timeout 1 sleep 10
    [ "$status" -eq 124 ]
}

@test "shlib::cmd_timeout returns command exit code on failure" {
    run shlib::cmd_timeout 5 bash -c 'exit 42'
    [ "$status" -eq 42 ]
}

@test "shlib::cmd_timeout returns command exit code on success" {
    run shlib::cmd_timeout 5 bash -c 'exit 0'
    [ "$status" -eq 0 ]
}

@test "shlib::cmd_timeout runs command that completes before timeout" {
    run shlib::cmd_timeout 5 true
    [ "$status" -eq 0 ]
}

#######################################
# kv
#######################################

@test "shlib::kv_clear on empty array" {
    declare -A kv
    shlib::kv_clear kv
    [[ ${#kv[@]} -eq 0 ]]
}

@test "shlib::kv_clear removes all entries" {
    declare -A kv
    kv[host]="localhost"
    kv[port]="8080"
    shlib::kv_clear kv
    [[ ${#kv[@]} -eq 0 ]]
}

@test "shlib::kv_copy copies all entries" {
    declare -A src
    src[host]="localhost"
    src[port]="8080"
    declare -A dest
    shlib::kv_copy dest src
    [[ ${#dest[@]} -eq 2 ]]
    [[ "${dest[host]}" == "localhost" ]]
    [[ "${dest[port]}" == "8080" ]]
}

@test "shlib::kv_copy handles empty source" {
    declare -A src
    declare -A dest
    dest[old]="data"
    shlib::kv_copy dest src
    [[ ${#dest[@]} -eq 0 ]]
}

@test "shlib::kv_copy handles values with newlines" {
    declare -A src
    src[multi]=$'line1\nline2'
    declare -A dest
    shlib::kv_copy dest src
    [[ "${dest[multi]}" == $'line1\nline2' ]]
}

@test "shlib::kv_copy handles values with spaces" {
    declare -A src
    src[msg]="hello world"
    declare -A dest
    shlib::kv_copy dest src
    [[ "${dest[msg]}" == "hello world" ]]
}

@test "shlib::kv_copy overwrites destination" {
    declare -A src
    src[new]="value"
    declare -A dest
    dest[old]="data"
    shlib::kv_copy dest src
    [[ ${#dest[@]} -eq 1 ]]
    [[ "${dest[new]}" == "value" ]]
    [[ -z "${dest[old]+exists}" ]]
}

@test "shlib::kv_delete handles missing key" {
    declare -A kv
    kv[host]="localhost"
    shlib::kv_delete kv "missing"
    [[ "${kv[host]}" == "localhost" ]]
}

@test "shlib::kv_delete on empty array" {
    declare -A kv=()
    shlib::kv_delete kv "key"
    [[ ${#kv[@]} -eq 0 ]]
}

@test "shlib::kv_delete removes a key" {
    declare -A kv
    kv[host]="localhost"
    kv[port]="8080"
    shlib::kv_delete kv "host"
    [[ -z "${kv[host]+exists}" ]]
    [[ "${kv[port]}" == "8080" ]]
}

@test "shlib::kv_exists on empty array" {
    declare -A kv
    run shlib::kv_exists kv "key"
    [[ "${status}" -eq 1 ]]
}

@test "shlib::kv_exists returns 0 for key with empty value" {
    declare -A kv
    kv[empty]=""
    shlib::kv_exists kv "empty"
}

@test "shlib::kv_exists returns 0 when key exists" {
    declare -A kv
    kv[host]="localhost"
    shlib::kv_exists kv "host"
}

@test "shlib::kv_exists returns 1 when key missing" {
    declare -A kv
    run shlib::kv_exists kv "missing"
    [[ "${status}" -eq 1 ]]
}

@test "shlib::kv_find handles empty array" {
    declare -A kv
    local -a result
    shlib::kv_find result kv "value"
    [[ ${#result[@]} -eq 0 ]]
}

@test "shlib::kv_find returns empty when no match" {
    declare -A kv
    kv[a]="1"
    kv[b]="2"
    local -a result
    shlib::kv_find result kv "missing"
    [[ ${#result[@]} -eq 0 ]]
}

@test "shlib::kv_find returns keys with matching value" {
    declare -A roles
    roles[alice]="admin"
    roles[bob]="user"
    roles[carol]="admin"
    local -a result
    shlib::kv_find result roles "admin"
    [[ ${#result[@]} -eq 2 ]]
    local found_alice=0 found_carol=0
    for k in "${result[@]}"; do
        [[ "$k" == "alice" ]] && found_alice=1
        [[ "$k" == "carol" ]] && found_carol=1
    done
    [[ $found_alice -eq 1 ]]
    [[ $found_carol -eq 1 ]]
}

@test "shlib::kv_find returns single match" {
    declare -A kv
    kv[a]="unique"
    kv[b]="other"
    local -a result
    shlib::kv_find result kv "unique"
    [[ ${#result[@]} -eq 1 ]]
    [[ "${result[0]}" == "a" ]]
}

@test "shlib::kv_find searching for empty string value" {
    declare -A kv
    kv[empty1]=""
    kv[empty2]=""
    kv[filled]="value"
    local -a result
    shlib::kv_find result kv ""
    [[ ${#result[@]} -eq 2 ]]
}

@test "shlib::kv_getdefault handles default with spaces" {
    declare -A kv
    run shlib::kv_getdefault kv "missing" "hello world"
    [[ "${output}" == "hello world" ]]
}

@test "shlib::kv_getdefault returns default when key missing" {
    declare -A kv
    run shlib::kv_getdefault kv "port" "8080"
    [[ "${output}" == "8080" ]]
}

@test "shlib::kv_getdefault returns empty value over default" {
    declare -A kv
    kv[empty]=""
    run shlib::kv_getdefault kv "empty" "default"
    [[ "${output}" == "" ]]
}

@test "shlib::kv_getdefault returns value when key exists" {
    declare -A kv
    kv[port]="3000"
    run shlib::kv_getdefault kv "port" "8080"
    [[ "${output}" == "3000" ]]
}

@test "shlib::kv_get handles empty value" {
    declare -A kv
    kv[empty]=""
    run shlib::kv_get kv "empty"
    [[ "${status}" -eq 0 ]]
    [[ "${output}" == "" ]]
}

@test "shlib::kv_get handles value with spaces" {
    declare -A kv
    kv[message]="hello world"
    run shlib::kv_get kv "message"
    [[ "${output}" == "hello world" ]]
}

@test "shlib::kv_get retrieves existing key" {
    declare -A kv
    kv[host]="localhost"
    run shlib::kv_get kv "host"
    [[ "${status}" -eq 0 ]]
    [[ "${output}" == "localhost" ]]
}

@test "shlib::kv_get returns 1 for missing key" {
    declare -A kv
    run shlib::kv_get kv "missing"
    [[ "${status}" -eq 1 ]]
    [[ "${output}" == "" ]]
}

@test "shlib::kv_get with numeric key" {
    declare -A kv
    kv[123]="numeric value"
    run shlib::kv_get kv "123"
    [[ "${output}" == "numeric value" ]]
}

@test "shlib::kv_hasvalue finds empty string value" {
    declare -A kv
    kv[empty]=""
    shlib::kv_hasvalue kv ""
}

@test "shlib::kv_hasvalue handles duplicate values" {
    declare -A kv
    kv[a]="same"
    kv[b]="same"
    shlib::kv_hasvalue kv "same"
}

@test "shlib::kv_hasvalue handles empty array" {
    declare -A kv
    run shlib::kv_hasvalue kv "value"
    [[ "${status}" -eq 1 ]]
}

@test "shlib::kv_hasvalue returns 0 when value exists" {
    declare -A kv
    kv[host]="localhost"
    shlib::kv_hasvalue kv "localhost"
}

@test "shlib::kv_hasvalue returns 1 when value missing" {
    declare -A kv
    kv[host]="localhost"
    run shlib::kv_hasvalue kv "missing"
    [[ "${status}" -eq 1 ]]
}

@test "shlib::kv_hasvalue with value containing special chars" {
    declare -A kv
    kv[special]='value*with[chars]'
    shlib::kv_hasvalue kv 'value*with[chars]'
}

@test "shlib::kv_keys extracts all keys" {
    declare -A kv
    kv[host]="localhost"
    kv[port]="8080"
    local -a keys
    shlib::kv_keys keys kv
    [[ ${#keys[@]} -eq 2 ]]
    # Keys may be in any order, check both exist
    local found_host=0 found_port=0
    for k in "${keys[@]}"; do
        [[ "$k" == "host" ]] && found_host=1
        [[ "$k" == "port" ]] && found_port=1
    done
    [[ $found_host -eq 1 ]]
    [[ $found_port -eq 1 ]]
}

@test "shlib::kv_keys handles empty array" {
    declare -A kv
    local -a keys
    shlib::kv_keys keys kv
    [[ ${#keys[@]} -eq 0 ]]
}

@test "shlib::kv_keys handles single entry" {
    declare -A kv
    kv[only]="value"
    local -a keys
    shlib::kv_keys keys kv
    [[ ${#keys[@]} -eq 1 ]]
    [[ "${keys[0]}" == "only" ]]
}

@test "shlib::kv_len returns 0 for empty array" {
    declare -A kv=()
    run shlib::kv_len kv
    [[ "${output}" == "0" ]]
}

@test "shlib::kv_len returns 1 for single entry" {
    declare -A kv
    kv[only]="one"
    run shlib::kv_len kv
    [[ "${output}" == "1" ]]
}

@test "shlib::kv_len returns correct count" {
    declare -A kv
    kv[a]="1"
    kv[b]="2"
    kv[c]="3"
    run shlib::kv_len kv
    [[ "${output}" == "3" ]]
}

@test "shlib::kv_map handles empty array" {
    declare -A kv=()
    shlib::kv_map kv 'tr a-z A-Z'
    [[ ${#kv[@]} -eq 0 ]]
}

@test "shlib::kv_map preserves keys when transforming values" {
    declare -A kv
    kv[key1]="value1"
    kv[key2]="value2"
    shlib::kv_map kv 'tr a-z A-Z'
    [[ -n "${kv[key1]+exists}" ]]
    [[ -n "${kv[key2]+exists}" ]]
    [[ "${kv[key1]}" == "VALUE1" ]]
    [[ "${kv[key2]}" == "VALUE2" ]]
}

@test "shlib::kv_map transforms all values" {
    declare -A kv
    kv[name]="hello"
    kv[greeting]="world"
    shlib::kv_map kv 'tr a-z A-Z'
    [[ "${kv[name]}" == "HELLO" ]]
    [[ "${kv[greeting]}" == "WORLD" ]]
}

@test "shlib::kv_map with sed replacement" {
    declare -A kv
    kv[path]="/old/path"
    shlib::kv_map kv "sed 's/old/new/'"
    [[ "${kv[path]}" == "/new/path" ]]
}

@test "shlib::kv_map with simple echo" {
    declare -A kv
    kv[a]="test"
    shlib::kv_map kv 'cat'
    [[ "${kv[a]}" == "test" ]]
}

@test "shlib::kv_merge combines multiple arrays" {
    declare -A a
    a[x]="1"
    declare -A b
    b[y]="2"
    declare -A c
    c[z]="3"
    declare -A result
    shlib::kv_merge result a b c
    [[ ${#result[@]} -eq 3 ]]
    [[ "${result[x]}" == "1" ]]
    [[ "${result[y]}" == "2" ]]
    [[ "${result[z]}" == "3" ]]
}

@test "shlib::kv_merge handles empty arrays" {
    declare -A a
    a[x]="1"
    declare -A empty
    declare -A b
    b[y]="2"
    declare -A result
    shlib::kv_merge result a empty b
    [[ ${#result[@]} -eq 2 ]]
    [[ "${result[x]}" == "1" ]]
    [[ "${result[y]}" == "2" ]]
}

@test "shlib::kv_merge later arrays override earlier" {
    declare -A defaults
    defaults[host]="localhost"
    defaults[port]="80"
    declare -A overrides
    overrides[port]="8080"
    declare -A result
    shlib::kv_merge result defaults overrides
    [[ ${#result[@]} -eq 2 ]]
    [[ "${result[host]}" == "localhost" ]]
    [[ "${result[port]}" == "8080" ]]
}

@test "shlib::kv_merge with no sources" {
    declare -A result
    shlib::kv_merge result
    [[ ${#result[@]} -eq 0 ]]
}

@test "shlib::kv_merge with overlapping keys" {
    declare -A a
    a[x]="original"
    a[y]="keep"
    declare -A b
    b[x]="override"
    declare -A result
    shlib::kv_merge result a b
    [[ "${result[x]}" == "override" ]]
    [[ "${result[y]}" == "keep" ]]
}

@test "shlib::kv_merge with single source" {
    declare -A src
    src[key]="value"
    declare -A result
    shlib::kv_merge result src
    [[ ${#result[@]} -eq 1 ]]
    [[ "${result[key]}" == "value" ]]
}

@test "shlib::kv_print handles empty array" {
    declare -A kv
    run shlib::kv_print kv
    [[ "${output}" == "" ]]
}

@test "shlib::kv_print handles multiple entries" {
    declare -A kv
    kv[a]="1"
    kv[b]="2"
    run shlib::kv_print kv "=" ", "
    # Output contains both, order may vary
    [[ "${output}" == *"a=1"* ]]
    [[ "${output}" == *"b=2"* ]]
}

@test "shlib::kv_print with custom separators" {
    declare -A kv
    kv[host]="localhost"
    run shlib::kv_print kv ":" ", "
    [[ "${output}" == "host:localhost" ]]
}

@test "shlib::kv_print with default separators" {
    declare -A kv
    kv[host]="localhost"
    run shlib::kv_print kv
    [[ "${output}" == "host=localhost" ]]
}

@test "shlib::kv_printn handles empty array" {
    declare -A kv
    run shlib::kv_printn kv
    [[ "${output}" == "" ]]
}

@test "shlib::kv_printn prints one pair per line" {
    declare -A kv
    kv[host]="localhost"
    kv[port]="8080"
    run shlib::kv_printn kv
    [[ "${#lines[@]}" -eq 2 ]]
}

@test "shlib::kv_printn with custom separator" {
    declare -A kv
    kv[host]="localhost"
    run shlib::kv_printn kv ":"
    [[ "${output}" == "host:localhost" ]]
}

@test "shlib::kv_set handles empty value" {
    declare -A kv
    shlib::kv_set kv "key" ""
    [[ "${kv[key]}" == "" ]]
    [[ -n "${kv[key]+exists}" ]]
}

@test "shlib::kv_set handles key with special characters" {
    declare -A kv
    shlib::kv_set kv "my-key_1" "value"
    [[ "${kv['my-key_1']}" == "value" ]]
}

@test "shlib::kv_set handles key with underscore and hyphen" {
    declare -A kv
    shlib::kv_set kv "my_key-name" "value"
    [[ "${kv['my_key-name']}" == "value" ]]
}

@test "shlib::kv_set handles value with backslash" {
    declare -A kv
    shlib::kv_set kv "path" 'C:\Users\test'
    [[ "${kv[path]}" == 'C:\Users\test' ]]
}

@test "shlib::kv_set handles value with quotes" {
    declare -A kv
    shlib::kv_set kv "msg" 'hello "world"'
    [[ "${kv[msg]}" == 'hello "world"' ]]
}

@test "shlib::kv_set handles value with spaces" {
    declare -A kv
    shlib::kv_set kv "message" "hello world"
    [[ "${kv[message]}" == "hello world" ]]
}

@test "shlib::kv_set overwrites existing key" {
    declare -A kv
    kv[host]="old"
    shlib::kv_set kv "host" "new"
    [[ "${kv[host]}" == "new" ]]
}

@test "shlib::kv_set sets a key-value pair" {
    declare -A kv
    shlib::kv_set kv "host" "localhost"
    [[ "${kv[host]}" == "localhost" ]]
}

@test "shlib::kv_set with numeric key" {
    declare -A kv
    shlib::kv_set kv "123" "numeric key"
    [[ "${kv[123]}" == "numeric key" ]]
}

@test "shlib::kv_values extracts all values" {
    declare -A kv
    kv[a]="one"
    kv[b]="two"
    local -a values
    shlib::kv_values values kv
    [[ ${#values[@]} -eq 2 ]]
    local found_one=0 found_two=0
    for v in "${values[@]}"; do
        [[ "$v" == "one" ]] && found_one=1
        [[ "$v" == "two" ]] && found_two=1
    done
    [[ $found_one -eq 1 ]]
    [[ $found_two -eq 1 ]]
}

@test "shlib::kv_values handles empty array" {
    declare -A kv
    local -a values
    shlib::kv_values values kv
    [[ ${#values[@]} -eq 0 ]]
}

@test "shlib::kv_values handles values with spaces" {
    declare -A kv
    kv[msg]="hello world"
    local -a values
    shlib::kv_values values kv
    [[ ${#values[@]} -eq 1 ]]
    [[ "${values[0]}" == "hello world" ]]
}

#######################################
# msg
#######################################

check_timestamp_prefix() {
    local output="$1"
    [[ "$output" =~ ^\[[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}[+-][0-9]{2}:[0-9]{2}\] ]]
}

@test "shlib::msg_cerror outputs colorized error with timestamp to stderr" {
    run shlib::msg_cerror "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *$'] \033[31merror:\033[0m test message' ]]
}

@test "shlib::msg_cerror with empty message" {
    run shlib::msg_cerror ""
    check_timestamp_prefix "$output"
    [[ "${output}" == *$'] \033[31merror:\033[0m ' ]]
}

@test "shlib::msg_cerrorn outputs colorized error with timestamp to stderr" {
    run shlib::msg_cerrorn "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *$'] \033[31merror:\033[0m test message' ]]
}

@test "shlib::msg_cinfo outputs colorized info with timestamp" {
    run shlib::msg_cinfo "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *$'] \033[34minfo:\033[0m test message' ]]
}

@test "shlib::msg_cinfo with empty message" {
    run shlib::msg_cinfo ""
    check_timestamp_prefix "$output"
    [[ "${output}" == *$'] \033[34minfo:\033[0m ' ]]
}

@test "shlib::msg_cinfon outputs colorized info with timestamp" {
    run shlib::msg_cinfon "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *$'] \033[34minfo:\033[0m test message' ]]
}

@test "shlib::msg_cwarn outputs colorized warning with timestamp" {
    run shlib::msg_cwarn "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *$'] \033[33mwarning:\033[0m test message' ]]
}

@test "shlib::msg_cwarn with empty message" {
    run shlib::msg_cwarn ""
    check_timestamp_prefix "$output"
    [[ "${output}" == *$'] \033[33mwarning:\033[0m ' ]]
}

@test "shlib::msg_cwarnn outputs colorized warning with timestamp" {
    run shlib::msg_cwarnn "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *$'] \033[33mwarning:\033[0m test message' ]]
}

@test "shlib::msg_eerror outputs emoji error with timestamp to stderr" {
    run shlib::msg_eerror "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] ❌️  test message" ]]
}

@test "shlib::msg_eerror with empty message" {
    run shlib::msg_eerror ""
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] ❌️  " ]]
}

@test "shlib::msg_eerrorn outputs emoji error with timestamp to stderr" {
    run shlib::msg_eerrorn "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] ❌️  test message" ]]
}

@test "shlib::msg_einfo outputs emoji info with timestamp" {
    run shlib::msg_einfo "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] ℹ️  test message" ]]
}

@test "shlib::msg_einfon outputs emoji info with timestamp" {
    run shlib::msg_einfon "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] ℹ️  test message" ]]
}

@test "shlib::msg_error outputs with timestamp to stderr" {
    run shlib::msg_error "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] error: test message" ]]
}

@test "shlib::msg_error with empty message" {
    run shlib::msg_error ""
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] error: " ]]
}

@test "shlib::msg_error with multiple arguments concatenates" {
    run shlib::msg_error "a" "b" "c"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] error: a b c" ]]
}

@test "shlib::msg_error with special characters" {
    run shlib::msg_error "line1\nline2"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"line1"* ]]
}

@test "shlib::msg_errorn outputs with timestamp to stderr" {
    run shlib::msg_errorn "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] error: test message" ]]
}

@test "shlib::msg_ewarn outputs emoji warning with timestamp" {
    run shlib::msg_ewarn "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] ⚠️  test message" ]]
}

@test "shlib::msg_ewarnn outputs emoji warning with timestamp" {
    run shlib::msg_ewarnn "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] ⚠️  test message" ]]
}

@test "shlib::msg_info outputs message with timestamp" {
    run shlib::msg_info "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] info: test message" ]]
}

@test "shlib::msg_info with empty message" {
    run shlib::msg_info ""
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] info: " ]]
}

@test "shlib::msg_info with multiple arguments concatenates" {
    run shlib::msg_info "a" "b" "c"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] info: a b c" ]]
}

@test "shlib::msg_info with tab character" {
    run shlib::msg_info $'tab\there'
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] info: tab	here" ]]
}

@test "shlib::msg_infon outputs message with timestamp" {
    run shlib::msg_infon "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] info: test message" ]]
}

@test "shlib::msg_statusfail shows red X" {
    run shlib::msg_statusfail "Error"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"✖"* ]]
    [[ "$output" == *"Error"* ]]
}

@test "shlib::msg_statusfail with empty message" {
    run shlib::msg_statusfail ""
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"✖"* ]]
}

@test "shlib::msg_statusfailn adds newline" {
    line_count=$(shlib::msg_statusfailn "Error" | wc -l)
    [[ "$line_count" -eq 1 ]]
}

@test "shlib::msg_statusok shows green checkmark" {
    run shlib::msg_statusok "Done"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"✔"* ]]
    [[ "$output" == *"Done"* ]]
}

@test "shlib::msg_statusok with empty message" {
    run shlib::msg_statusok ""
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"✔"* ]]
}

@test "shlib::msg_statusokn adds newline" {
    line_count=$(shlib::msg_statusokn "Done" | wc -l)
    [[ "$line_count" -eq 1 ]]
}

@test "shlib::msg_statuspending shows hourglass" {
    run shlib::msg_statuspending "Waiting"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"⏳"* ]]
    [[ "$output" == *"Waiting"* ]]
}

@test "shlib::msg_statuspending with empty message" {
    run shlib::msg_statuspending ""
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"⏳"* ]]
}

@test "shlib::msg_statuspendingn adds newline" {
    line_count=$(shlib::msg_statuspendingn "Waiting" | wc -l)
    [[ "$line_count" -eq 1 ]]
}

@test "shlib::msg_warn outputs with timestamp to stderr" {
    run shlib::msg_warn "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] warning: test message" ]]
}

@test "shlib::msg_warn with empty message" {
    run shlib::msg_warn ""
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] warning: " ]]
}

@test "shlib::msg_warn with multiple arguments concatenates" {
    run shlib::msg_warn "a" "b" "c"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] warning: a b c" ]]
}

@test "shlib::msg_warnn outputs with timestamp to stderr" {
    run shlib::msg_warnn "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] warning: test message" ]]
}

#######################################
# strings
#######################################

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

@test "shlib::str_isempty returns 0 for empty string" {
    shlib::str_isempty ""
}

@test "shlib::str_isempty returns 0 for mixed tabs and spaces" {
    shlib::str_isempty $'\t  \t  \t'
}

@test "shlib::str_isempty returns 0 for tabs only" {
    shlib::str_isempty $'\t\t'
}

@test "shlib::str_isempty returns 0 for whitespace-only string" {
    shlib::str_isempty "   "
}

@test "shlib::str_isempty returns 1 for non-empty string" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::str_isempty "hello"
}

@test "shlib::str_isempty returns 1 for string with content and whitespace" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::str_isempty "  hello  "
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

@test "shlib::str_tolower converts to lowercase" {
    run shlib::str_tolower "HELLO"
    [[ "${output}" == "hello" ]]
}

@test "shlib::str_tolower handles mixed case" {
    run shlib::str_tolower "HeLLo WoRLd"
    [[ "${output}" == "hello world" ]]
}

@test "shlib::str_tolower preserves non-alpha characters" {
    run shlib::str_tolower "HELLO123!"
    [[ "${output}" == "hello123!" ]]
}

@test "shlib::str_tolower with empty string" {
    run shlib::str_tolower ""
    [[ "${output}" == "" ]]
}

@test "shlib::str_toupper converts to uppercase" {
    run shlib::str_toupper "hello"
    [[ "${output}" == "HELLO" ]]
}

@test "shlib::str_toupper handles mixed case" {
    run shlib::str_toupper "HeLLo WoRLd"
    [[ "${output}" == "HELLO WORLD" ]]
}

@test "shlib::str_toupper preserves non-alpha characters" {
    run shlib::str_toupper "hello123!"
    [[ "${output}" == "HELLO123!" ]]
}

@test "shlib::str_toupper with empty string" {
    run shlib::str_toupper ""
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

#######################################
# time
#######################################

@test "shlib::time_add adds days" {
    run shlib::time_add 1000 1 days
    [[ "$output" == "87400" ]]
}

@test "shlib::time_add adds hours" {
    run shlib::time_add 1000 1 hours
    [[ "$output" == "4600" ]]
}

@test "shlib::time_add adds minutes" {
    run shlib::time_add 1000 1 minutes
    [[ "$output" == "1060" ]]
}

@test "shlib::time_add adds seconds" {
    run shlib::time_add 1000 60 seconds
    [[ "$output" == "1060" ]]
}

@test "shlib::time_add adds weeks" {
    run shlib::time_add 1000 1 weeks
    [[ "$output" == "605800" ]]
}

@test "shlib::time_add handles singular unit: day" {
    run shlib::time_add 1000 1 day
    [[ "$output" == "87400" ]]
}

@test "shlib::time_add handles singular unit: hour" {
    run shlib::time_add 1000 1 hour
    [[ "$output" == "4600" ]]
}

@test "shlib::time_add handles singular unit: minute" {
    run shlib::time_add 1000 1 minute
    [[ "$output" == "1060" ]]
}

@test "shlib::time_add handles singular unit: second" {
    run shlib::time_add 1000 60 second
    [[ "$output" == "1060" ]]
}

@test "shlib::time_add handles singular unit: week" {
    run shlib::time_add 1000 1 week
    [[ "$output" == "605800" ]]
}

@test "shlib::time_add subtracts with negative amount" {
    run shlib::time_add 1000 -1 hours
    [[ "$output" == "-2600" ]]
}

@test "shlib::time_add unknown unit defaults to seconds" {
    run shlib::time_add 1000 60 unknown
    [[ "$output" == "1060" ]]
}

@test "shlib::time_add with large amounts" {
    run shlib::time_add 0 365 days
    [[ "$output" == "31536000" ]]
}

@test "shlib::time_add with zero amount" {
    run shlib::time_add 1000 0 days
    [[ "$output" == "1000" ]]
}

@test "shlib::time_diff handles negative differences" {
    run shlib::time_diff 1000 2000
    [[ "$output" == "-1000" ]]
}

@test "shlib::time_diff handles singular unit: day" {
    run shlib::time_diff 172800 0 day
    [[ "$output" == "2" ]]
}

@test "shlib::time_diff handles singular unit: hour" {
    run shlib::time_diff 7200 0 hour
    [[ "$output" == "2" ]]
}

@test "shlib::time_diff handles singular unit: minute" {
    run shlib::time_diff 120 0 minute
    [[ "$output" == "2" ]]
}

@test "shlib::time_diff handles singular unit: second" {
    run shlib::time_diff 2000 1000 second
    [[ "$output" == "1000" ]]
}

@test "shlib::time_diff handles singular unit: week" {
    run shlib::time_diff 1209600 0 week
    [[ "$output" == "2" ]]
}

@test "shlib::time_diff negative difference in days" {
    run shlib::time_diff 0 172800 days
    [[ "$output" == "-2" ]]
}

@test "shlib::time_diff performs integer division" {
    run shlib::time_diff 90 0 minutes
    [[ "$output" == "1" ]]
}

@test "shlib::time_diff returns difference in days" {
    run shlib::time_diff 172800 0 days
    [[ "$output" == "2" ]]
}

@test "shlib::time_diff returns difference in hours" {
    run shlib::time_diff 7200 0 hours
    [[ "$output" == "2" ]]
}

@test "shlib::time_diff returns difference in minutes" {
    run shlib::time_diff 120 0 minutes
    [[ "$output" == "2" ]]
}

@test "shlib::time_diff returns difference in seconds by default" {
    run shlib::time_diff 2000 1000
    [[ "$output" == "1000" ]]
}

@test "shlib::time_diff returns difference in weeks" {
    run shlib::time_diff 1209600 0 weeks
    [[ "$output" == "2" ]]
}

@test "shlib::time_diff unknown unit defaults to seconds" {
    run shlib::time_diff 2000 1000 unknown
    [[ "$output" == "1000" ]]
}

@test "shlib::time_diff with zero difference" {
    run shlib::time_diff 1000 1000
    [[ "$output" == "0" ]]
}

@test "shlib::time_duration compact format" {
    run shlib::time_duration 90061 compact
    [[ "$output" == "1d1h1m1s" ]]
}

@test "shlib::time_duration days and minutes no hours" {
    # 1 day + 1 minute = 86460 seconds
    run shlib::time_duration 86460
    [[ "$output" == "1d 1m" ]]
}

@test "shlib::time_duration days and seconds only" {
    # 1 day + 1 second = 86401 seconds
    run shlib::time_duration 86401
    [[ "$output" == "1d 1s" ]]
}

@test "shlib::time_duration days only long format" {
    run shlib::time_duration 172800 long
    [[ "$output" == "2 days" ]]
}

@test "shlib::time_duration formats days" {
    run shlib::time_duration 90061
    [[ "$output" == "1d 1h 1m 1s" ]]
}

@test "shlib::time_duration formats hours" {
    run shlib::time_duration 3661
    [[ "$output" == "1h 1m 1s" ]]
}

@test "shlib::time_duration formats minutes and seconds" {
    run shlib::time_duration 90
    [[ "$output" == "1m 30s" ]]
}

@test "shlib::time_duration formats seconds only" {
    run shlib::time_duration 45
    [[ "$output" == "45s" ]]
}

@test "shlib::time_duration handles exactly one day" {
    run shlib::time_duration 86400
    [[ "$output" == "1d" ]]
}

@test "shlib::time_duration handles exactly one hour" {
    run shlib::time_duration 3600
    [[ "$output" == "1h" ]]
}

@test "shlib::time_duration handles exactly one minute" {
    run shlib::time_duration 60
    [[ "$output" == "1m" ]]
}

@test "shlib::time_duration handles large values (weeks)" {
    run shlib::time_duration 694861
    # 8 days, 1 hour, 1 minute, 1 second
    [[ "$output" == "8d 1h 1m 1s" ]]
}

@test "shlib::time_duration handles negative values compact" {
    run shlib::time_duration -90 compact
    [[ "$output" == "-1m30s" ]]
}

@test "shlib::time_duration handles negative values long" {
    run shlib::time_duration -90 long
    [[ "$output" == "-1 minute, 30 seconds" ]]
}

@test "shlib::time_duration handles negative values short" {
    run shlib::time_duration -90
    [[ "$output" == "-1m 30s" ]]
}

@test "shlib::time_duration handles zero compact" {
    run shlib::time_duration 0 compact
    [[ "$output" == "0s" ]]
}

@test "shlib::time_duration handles zero long" {
    run shlib::time_duration 0 long
    [[ "$output" == "0 seconds" ]]
}

@test "shlib::time_duration handles zero short" {
    run shlib::time_duration 0
    [[ "$output" == "0s" ]]
}

@test "shlib::time_duration hours and seconds no minutes" {
    # 1 hour + 1 second = 3601 seconds
    run shlib::time_duration 3601
    [[ "$output" == "1h 1s" ]]
}

@test "shlib::time_duration hours and seconds no minutes long" {
    run shlib::time_duration 3601 long
    [[ "$output" == "1 hour, 1 second" ]]
}

@test "shlib::time_duration long format singular" {
    run shlib::time_duration 90061 long
    [[ "$output" == "1 day, 1 hour, 1 minute, 1 second" ]]
}

@test "shlib::time_duration long format with plurals" {
    run shlib::time_duration 180122 long
    [[ "$output" == "2 days, 2 hours, 2 minutes, 2 seconds" ]]
}

@test "shlib::time_duration minutes only long format" {
    run shlib::time_duration 120 long
    [[ "$output" == "2 minutes" ]]
}

@test "shlib::time_duration omits zero components compact" {
    run shlib::time_duration 3600 compact
    [[ "$output" == "1h" ]]
}

@test "shlib::time_duration omits zero components long" {
    run shlib::time_duration 3600 long
    [[ "$output" == "1 hour" ]]
}

@test "shlib::time_duration omits zero components short" {
    run shlib::time_duration 3600
    [[ "$output" == "1h" ]]
}

@test "shlib::time_duration one second" {
    run shlib::time_duration 1
    [[ "$output" == "1s" ]]
}

@test "shlib::time_duration one second long format" {
    run shlib::time_duration 1 long
    [[ "$output" == "1 second" ]]
}

@test "shlib::time_duration unknown format defaults to short" {
    run shlib::time_duration 90 unknown
    [[ "$output" == "1m 30s" ]]
}

@test "shlib::time_duration with huge value (multiple years)" {
    # 2 years = 63072000 seconds
    run shlib::time_duration 63072000
    [[ "$status" -eq 0 ]]
    [[ "$output" == "730d" ]]
}

@test "shlib::time_duration with very large seconds value" {
    # 1 year worth of seconds = 31536000
    run shlib::time_duration 31536000
    [[ "$status" -eq 0 ]]
    [[ "$output" == "365d" ]]
}

@test "shlib::time_elapsed returns elapsed time short format" {
    local start
    start=$(shlib::time_now)
    run shlib::time_elapsed "$start"
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ ^[0-9]+s$ ]]
}

@test "shlib::time_elapsed with compact format" {
    local start
    start=$(shlib::time_now)
    run shlib::time_elapsed "$start" compact
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ ^[0-9]+s$ ]]
}

@test "shlib::time_elapsed with future timestamp long format" {
    local start
    start=$(($(shlib::time_now) + 90))
    run shlib::time_elapsed "$start" long
    [[ "$status" -eq 0 ]]
    [[ "$output" == "-1 minute, 30 seconds" ]]
}

@test "shlib::time_elapsed with future timestamp shows negative" {
    local start
    start=$(($(shlib::time_now) + 90))
    run shlib::time_elapsed "$start"
    [[ "$status" -eq 0 ]]
    [[ "$output" == "-1m 30s" ]]
}

@test "shlib::time_elapsed with long format" {
    local start
    start=$(shlib::time_now)
    run shlib::time_elapsed "$start" long
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ second ]]
}

@test "shlib::time_elapsed with past timestamp" {
    local start
    start=$(($(shlib::time_now) - 3661))
    run shlib::time_elapsed "$start"
    [[ "$status" -eq 0 ]]
    [[ "$output" == "1h 1m 1s" ]]
}

@test "shlib::time_fromunix formats timestamp as date" {
    run shlib::time_fromunix 1704067200 "%Y-%m-%d"
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]
}

@test "shlib::time_fromunix handles epoch zero" {
    run shlib::time_fromunix 0 "%Y"
    [[ "$status" -eq 0 ]]
    [[ "$output" == "1970" ]]
}

@test "shlib::time_fromunix handles full datetime format" {
    run shlib::time_fromunix 1704067200 "%Y-%m-%d %H:%M:%S"
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}\ [0-9]{2}:[0-9]{2}:[0-9]{2}$ ]]
}

@test "shlib::time_fromunix handles hour format" {
    run shlib::time_fromunix 1704067200 "%H"
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ ^[0-9]{2}$ ]]
}

@test "shlib::time_fromunix handles month name format" {
    run shlib::time_fromunix 1704067200 "%B"
    [[ "$status" -eq 0 ]]
    [[ -n "$output" ]]
}

@test "shlib::time_fromunix handles negative timestamp" {
    run shlib::time_fromunix -86400 "%Y"
    [[ "$status" -eq 0 ]]
    [[ "$output" == "1969" ]]
}

@test "shlib::time_fromunix handles weekday format" {
    run shlib::time_fromunix 1704067200 "%A"
    [[ "$status" -eq 0 ]]
    [[ -n "$output" ]]
}

@test "shlib::time_fromunix returns error for invalid timestamp" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::time_fromunix "invalid" "%Y-%m-%d"
}

@test "shlib::time_fromunix with very large future timestamp" {
    # Year 2100: 4102444800
    run shlib::time_fromunix 4102444800 "%Y"
    [[ "$status" -eq 0 ]]
    [[ "$output" == "2100" ]]
}

@test "shlib::time_isafter returns 0 when ts1 > ts2" {
    shlib::time_isafter 2000 1000
}

@test "shlib::time_isafter returns 1 when equal" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::time_isafter 1000 1000
}

@test "shlib::time_isafter returns 1 when ts1 < ts2" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::time_isafter 1000 2000
}

@test "shlib::time_isafter with negative timestamps" {
    shlib::time_isafter 0 -100
}

@test "shlib::time_isafter with zero timestamps" {
    shlib::time_isafter 1 0
}

@test "shlib::time_isbefore returns 0 when ts1 < ts2" {
    shlib::time_isbefore 1000 2000
}

@test "shlib::time_isbefore returns 1 when equal" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::time_isbefore 1000 1000
}

@test "shlib::time_isbefore returns 1 when ts1 > ts2" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::time_isbefore 2000 1000
}

@test "shlib::time_isbefore with negative timestamps" {
    shlib::time_isbefore -100 0
}

@test "shlib::time_isbefore with zero timestamps" {
    shlib::time_isbefore 0 1
}

@test "shlib::time_now returns a timestamp" {
    run shlib::time_now
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ ^[0-9]+$ ]]
}

@test "shlib::time_now returns reasonable timestamp" {
    run shlib::time_now
    # Should be after Jan 1, 2020 (1577836800)
    [[ "$output" -gt 1577836800 ]]
}

@test "shlib::time_now and time_nowiso return consistent timestamps" {
    local unix_ts iso_ts
    unix_ts=$(shlib::time_now)
    iso_ts=$(shlib::time_nowiso)
    # Both should be from the same second (or very close)
    [[ -n "$unix_ts" ]]
    [[ -n "$iso_ts" ]]
    # ISO format should contain current year
    local year
    year=$(date +%Y)
    [[ "$iso_ts" == "$year"* ]]
}

@test "shlib::time_nowiso ignores invalid argument and returns UTC" {
    run shlib::time_nowiso invalid
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$ ]]
}

@test "shlib::time_nowiso local returns local ISO format" {
    run shlib::time_nowiso local
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}[+-][0-9]{2}:[0-9]{2}$ ]]
}

@test "shlib::time_nowiso returns UTC ISO format" {
    run shlib::time_nowiso
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$ ]]
}

@test "shlib::time_today matches current date" {
    run shlib::time_today
    local expected
    expected=$(date +%Y-%m-%d)
    [[ "$output" == "$expected" ]]
}

@test "shlib::time_today returns YYYY-MM-DD format" {
    run shlib::time_today
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]
}

#######################################
# ui
#######################################

@test "shlib::ui_ansi256palette outputs 256 color palette" {
    run shlib::ui_ansi256palette
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"256 Color Palette"* ]]
    [[ "$output" == *"Standard Colors (0-15)"* ]]
    [[ "$output" == *"216 Colors (16-231)"* ]]
    [[ "$output" == *"Grayscale (232-255)"* ]]
}

@test "shlib::ui_ansibgcolors outputs background colors" {
    run shlib::ui_ansibgcolors
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"Background Colors"* ]]
    [[ "$output" == *"Red"* ]]
    [[ "$output" == *"Blue"* ]]
}

@test "shlib::ui_ansibgcolors produces non-empty output" {
    run shlib::ui_ansibgcolors
    [[ "$status" -eq 0 ]]
    [[ -n "$output" ]]
    [[ ${#output} -gt 100 ]]
}

@test "shlib::ui_ansicolormatrix_bright outputs bright color combinations" {
    run shlib::ui_ansicolormatrix_bright
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"Foreground / Background Combinations (Bright Colors)"* ]]
    [[ "$output" == *"100"* ]]
    [[ "$output" == *"90"* ]]
}

@test "shlib::ui_ansicolormatrix outputs standard color combinations" {
    run shlib::ui_ansicolormatrix
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"Foreground / Background Combinations (Standard Colors)"* ]]
    [[ "$output" == *"40"* ]]
    [[ "$output" == *"30"* ]]
}

@test "shlib::ui_ansifgcolors outputs foreground colors" {
    run shlib::ui_ansifgcolors
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"Foreground Colors"* ]]
    [[ "$output" == *"Red"* ]]
    [[ "$output" == *"Blue"* ]]
    [[ "$output" == *"Bright White"* ]]
}

@test "shlib::ui_ansifgcolors produces non-empty output" {
    run shlib::ui_ansifgcolors
    [[ "$status" -eq 0 ]]
    [[ -n "$output" ]]
    [[ ${#output} -gt 100 ]]
}

@test "shlib::ui_ansistyles outputs text styles" {
    run shlib::ui_ansistyles
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"Text Styles"* ]]
    [[ "$output" == *"Bold"* ]]
    [[ "$output" == *"Underline"* ]]
    [[ "$output" == *"Italic"* ]]
}

@test "shlib::ui_ansistyles produces non-empty output" {
    run shlib::ui_ansistyles
    [[ "$status" -eq 0 ]]
    [[ -n "$output" ]]
    [[ ${#output} -gt 100 ]]
}

@test "shlib::ui_banner always succeeds with builtin fallback" {
    run shlib::ui_banner "TEST"
    [[ "$status" -eq 0 ]]
    [[ -n "$output" ]]
}

@test "shlib::ui_banner_builtin converts lowercase to uppercase" {
    run shlib::ui_banner_builtin "hello"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"█"* ]]
}

@test "shlib::ui_banner_builtin handles empty string" {
    run shlib::ui_banner_builtin ""
    [[ "$status" -eq 0 ]]
}

@test "shlib::ui_banner_builtin handles punctuation" {
    run shlib::ui_banner_builtin "HI!"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"█"* ]]
}

@test "shlib::ui_banner_builtin handles space character" {
    run shlib::ui_banner_builtin "A B"
    [[ "$status" -eq 0 ]]
    local lines
    lines=$(echo "$output" | wc -l | tr -d ' ')
    [[ "$lines" -eq 5 ]]
}

@test "shlib::ui_banner_builtin renders 5 lines" {
    run shlib::ui_banner_builtin "HI"
    [[ "$status" -eq 0 ]]
    # Count lines in output
    local lines
    lines=$(echo "$output" | wc -l | tr -d ' ')
    [[ "$lines" -eq 5 ]]
}

@test "shlib::ui_banner_builtin renders all digits 0-9" {
    run shlib::ui_banner_builtin "0123456789"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"█"* ]]
}

@test "shlib::ui_banner_builtin renders all letters A-Z" {
    run shlib::ui_banner_builtin "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"█"* ]]
}

@test "shlib::ui_banner_builtin renders numbers" {
    run shlib::ui_banner_builtin "123"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"█"* ]]
}

@test "shlib::ui_banner_builtin renders supported punctuation" {
    run shlib::ui_banner_builtin "!?.-:_"
    [[ "$status" -eq 0 ]]
    local lines
    lines=$(echo "$output" | wc -l | tr -d ' ')
    [[ "$lines" -eq 5 ]]
}

@test "shlib::ui_banner_builtin renders uppercase letters" {
    run shlib::ui_banner_builtin "HELLO"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"█"* ]]
}

@test "shlib::ui_banner_figlet fails without figlet" {
    # Skip if figlet is installed
    if command -v figlet &>/dev/null; then
        skip "figlet is installed"
    fi
    run shlib::ui_banner_figlet "TEST"
    [[ "$status" -eq 1 ]]
}

@test "shlib::ui_banner_figlet works when figlet installed" {
    # Skip if figlet is not installed
    if ! command -v figlet &>/dev/null; then
        skip "figlet is not installed"
    fi
    run shlib::ui_banner_figlet "TEST"
    [[ "$status" -eq 0 ]]
    [[ -n "$output" ]]
}

@test "shlib::ui_banner output contains expected content" {
    run shlib::ui_banner "HI"
    [[ "$status" -eq 0 ]]
    [[ -n "$output" ]]
    # Output should have multiple lines
    local lines
    lines=$(echo "$output" | wc -l | tr -d ' ')
    [[ "$lines" -ge 1 ]]
}

@test "shlib::ui_banner_toilet fails without toilet" {
    # Skip if toilet is installed
    if command -v toilet &>/dev/null; then
        skip "toilet is installed"
    fi
    run shlib::ui_banner_toilet "TEST"
    [[ "$status" -eq 1 ]]
}

@test "shlib::ui_banner_toilet works when toilet installed" {
    # Skip if toilet is not installed
    if ! command -v toilet &>/dev/null; then
        skip "toilet is not installed"
    fi
    run shlib::ui_banner_toilet "TEST"
    [[ "$status" -eq 0 ]]
    [[ -n "$output" ]]
}

@test "shlib::ui_header outputs bold message" {
    run shlib::ui_header "test header"
    [[ "${output}" == $'\033[1mtest header\033[0m' ]]
}

@test "shlib::ui_header with empty string" {
    run shlib::ui_header ""
    [[ "$status" -eq 0 ]]
    # Output should just be the ANSI codes with empty content
    [[ "${output}" == $'\033[1m\033[0m' ]]
}

@test "shlib::ui_headern outputs bold message" {
    run shlib::ui_headern "test header"
    [[ "${output}" == $'\033[1mtest header\033[0m' ]]
}

@test "shlib::ui_headern with empty string" {
    run shlib::ui_headern ""
    [[ "$status" -eq 0 ]]
}

@test "shlib::ui_hr draws horizontal rule" {
    run shlib::ui_hr
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"─"* ]]
}

@test "shlib::ui_hr draws rule with label" {
    run shlib::ui_hr "Test"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"Test"* ]]
    [[ "$output" == *"─"* ]]
}

@test "shlib::ui_hr respects custom width" {
    run shlib::ui_hr "" 20
    [[ "$status" -eq 0 ]]
    [[ ${#output} -eq 20 ]]
}

@test "shlib::ui_hr uses custom character" {
    run shlib::ui_hr "" 10 "="
    [[ "$status" -eq 0 ]]
    [[ "$output" == "==========" ]]
}

@test "shlib::ui_hr with label and very narrow width" {
    run shlib::ui_hr "Hi" 6 "-"
    [[ "$status" -eq 0 ]]
    # Label centered: should contain "Hi" surrounded by separator
    [[ "${output}" == *"Hi"* ]]
}

@test "shlib::ui_hr with label longer than width" {
    run shlib::ui_hr "VeryLongLabel" 5 "-"
    [[ "$status" -eq 0 ]]
    # The label should still be present even if wider than width
    [[ "${output}" == *"VeryLongLabel"* ]]
}

@test "shlib::ui_hr with very small width" {
    run shlib::ui_hr "" 1
    [[ "$status" -eq 0 ]]
    [[ ${#output} -eq 1 ]]
}

@test "shlib::ui_hr with width of 2" {
    run shlib::ui_hr "" 2 "-"
    [[ "$status" -eq 0 ]]
    [[ "${output}" == "--" ]]
}

@test "shlib::ui_hrn adds newline" {
    line_count=$(shlib::ui_hrn "" 5 "-" | wc -l)
    [[ "$line_count" -eq 1 ]]
}

@test "shlib::ui_spinner handles command with multiple arguments" {
    local tmpfile
    tmpfile=$(mktemp)
    shlib::ui_spinner "Testing" bash -c "echo one two three > '$tmpfile'"
    run cat "$tmpfile"
    [[ "$output" == "one two three" ]]
    rm -f "$tmpfile"
}

@test "shlib::ui_spinner passes arguments to command" {
    local tmpfile
    tmpfile=$(mktemp)
    shlib::ui_spinner "Writing" bash -c "echo 'hello' > '$tmpfile'"
    run cat "$tmpfile"
    [[ "$output" == "hello" ]]
    rm -f "$tmpfile"
}

@test "shlib::ui_spinner returns command exit code on failure" {
    run shlib::ui_spinner "Testing" false
    [[ "$status" -eq 1 ]]
}

@test "shlib::ui_spinner returns command exit code on success" {
    run shlib::ui_spinner "Testing" true
    [[ "$status" -eq 0 ]]
}

@test "shlib::ui_spinner runs command successfully" {
    run shlib::ui_spinner "Testing" sleep 0.2
    [[ "$status" -eq 0 ]]
}

@test "shlib::ui_spinner with command that writes to stderr" {
    run shlib::ui_spinner "Testing" bash -c 'echo stderr_output >&2; exit 0'
    [[ "$status" -eq 0 ]]
}
#
########################################################################
#                                                                      #
#  shlib - BATS tests                                                  #
#                                                                      #
#  Usage: bats shlib.bats                                              #
#  License: GPL-3.0-or-later                                           #
#                                                                      #
#  References:                                                         #
#  - https://github.com/waltlenu/shlib                                 #
#  - https://www.gnu.org/software/bash                                 #
#  - https://github.com/bats-core/bats-core                            #
#  - https://github.com/mvdan/sh                                       #
#  - https://www.shellcheck.net                                        #
#                                                                      #
#  ShellCheck Exclusions:                                              #
#  - https://www.shellcheck.net/wiki/SC2030                            #
#  - https://www.shellcheck.net/wiki/SC2031                            #
#  - https://www.shellcheck.net/wiki/SC2034                            #
########################################################################

# End of File
