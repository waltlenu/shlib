#!/usr/bin/env bats

setup() {
    load 'test_helper'
}

@test "shlib::command_exists finds existing command" {
    shlib::command_exists bash
}

@test "shlib::command_exists returns false for missing command" {
    ! shlib::command_exists nonexistent_command_12345
}
