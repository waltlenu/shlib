#!/usr/bin/env bats

setup() {
    load 'test_helper'
}

@test "library loads successfully" {
    [[ -n "${SHLIB_LOADED}" ]]
}

@test "SHLIB_VERSION is set" {
    [[ -n "${SHLIB_VERSION}" ]]
}

@test "shlib::version outputs version string" {
    result="$(shlib::version)"
    [[ "${result}" == "${SHLIB_VERSION}" ]]
}

@test "shlib::command_exists finds existing command" {
    shlib::command_exists bash
}

@test "shlib::command_exists returns false for missing command" {
    ! shlib::command_exists nonexistent_command_12345
}

@test "shlib::error outputs to stderr" {
    run shlib::error "test message"
    [[ "${output}" == "error: test message" ]]
}

@test "shlib::warn outputs to stderr" {
    run shlib::warn "test message"
    [[ "${output}" == "warning: test message" ]]
}

@test "shlib::info outputs message" {
    run shlib::info "test message"
    [[ "${output}" == "info: test message" ]]
}

@test "shlib::errorn outputs to stderr" {
    run shlib::errorn "test message"
    [[ "${output}" == "error: test message" ]]
}

@test "shlib::warnn outputs to stderr" {
    run shlib::warnn "test message"
    [[ "${output}" == "warning: test message" ]]
}

@test "shlib::infon outputs message" {
    run shlib::infon "test message"
    [[ "${output}" == "info: test message" ]]
}
