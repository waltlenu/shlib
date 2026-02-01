#!/usr/bin/env bats

setup() {
    load 'test_helper'
}

@test "shlib::command_exists finds builtin command (echo)" {
    shlib::command_exists echo
}

@test "shlib::command_exists finds command with absolute path" {
    shlib::command_exists /bin/ls
}

@test "shlib::command_exists finds existing command" {
    shlib::command_exists bash
}

@test "shlib::command_exists returns false for empty string" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::command_exists ""
}

@test "shlib::command_exists returns false for missing command" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::command_exists nonexistent_command_12345
}
