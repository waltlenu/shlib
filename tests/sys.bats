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
