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

@test "shlib::header outputs bold message" {
    run shlib::header "test header"
    [[ "${output}" == $'\033[1mtest header\033[0m' ]]
}

@test "shlib::headern outputs bold message" {
    run shlib::headern "test header"
    [[ "${output}" == $'\033[1mtest header\033[0m' ]]
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

@test "shlib::cerror outputs colorized error to stderr" {
    run shlib::cerror "test message"
    [[ "${output}" == $'\033[0;31merror:\033[0m test message' ]]
}

@test "shlib::cerrorn outputs colorized error to stderr" {
    run shlib::cerrorn "test message"
    [[ "${output}" == $'\033[0;31merror:\033[0m test message' ]]
}

@test "shlib::cwarn outputs colorized warning" {
    run shlib::cwarn "test message"
    [[ "${output}" == $'\033[0;33mwarning:\033[0m test message' ]]
}

@test "shlib::cwarnn outputs colorized warning" {
    run shlib::cwarnn "test message"
    [[ "${output}" == $'\033[0;33mwarning:\033[0m test message' ]]
}

@test "shlib::cinfo outputs colorized info" {
    run shlib::cinfo "test message"
    [[ "${output}" == $'\033[0;34minfo:\033[0m test message' ]]
}

@test "shlib::cinfon outputs colorized info" {
    run shlib::cinfon "test message"
    [[ "${output}" == $'\033[0;34minfo:\033[0m test message' ]]
}

@test "shlib::eerror outputs emoji error to stderr" {
    run shlib::eerror "test message"
    [[ "${output}" == "❌ test message" ]]
}

@test "shlib::eerrorn outputs emoji error to stderr" {
    run shlib::eerrorn "test message"
    [[ "${output}" == "❌ test message" ]]
}

@test "shlib::ewarn outputs emoji warning" {
    run shlib::ewarn "test message"
    [[ "${output}" == "⚠️  test message" ]]
}

@test "shlib::ewarnn outputs emoji warning" {
    run shlib::ewarnn "test message"
    [[ "${output}" == "⚠️  test message" ]]
}

@test "shlib::einfo outputs emoji info" {
    run shlib::einfo "test message"
    [[ "${output}" == "ℹ️  test message" ]]
}

@test "shlib::einfon outputs emoji info" {
    run shlib::einfon "test message"
    [[ "${output}" == "ℹ️  test message" ]]
}
