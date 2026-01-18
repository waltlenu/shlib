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

@test "SHLIB_DIR is set to correct path" {
    [[ -n "${SHLIB_DIR}" ]]
    [[ -d "${SHLIB_DIR}" ]]
    [[ -f "${SHLIB_DIR}/shlib.sh" ]]
}

@test "SHLIB_COLOR_RED is set" {
    [[ "${SHLIB_COLOR_RED}" == '\033[0;31m' ]]
}

@test "SHLIB_COLOR_YELLOW is set" {
    [[ "${SHLIB_COLOR_YELLOW}" == '\033[0;33m' ]]
}

@test "SHLIB_COLOR_BLUE is set" {
    [[ "${SHLIB_COLOR_BLUE}" == '\033[0;34m' ]]
}

@test "SHLIB_COLOR_RESET is set" {
    [[ "${SHLIB_COLOR_RESET}" == '\033[0m' ]]
}

@test "SHLIB_COLOR_BOLD is set" {
    [[ "${SHLIB_COLOR_BOLD}" == '\033[1m' ]]
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
