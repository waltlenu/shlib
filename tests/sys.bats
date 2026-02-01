#!/usr/bin/env bats

setup() {
    load 'test_helper'
}

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
    echo "0" > "$tmpfile"

    # Command that fails twice then succeeds
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
