#!/usr/bin/env bats

setup() {
    load 'test_helper'
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
    [[ "${output}" == $'\033[31merror:\033[0m test message' ]]
}

@test "shlib::cerrorn outputs colorized error to stderr" {
    run shlib::cerrorn "test message"
    [[ "${output}" == $'\033[31merror:\033[0m test message' ]]
}

@test "shlib::cwarn outputs colorized warning" {
    run shlib::cwarn "test message"
    [[ "${output}" == $'\033[33mwarning:\033[0m test message' ]]
}

@test "shlib::cwarnn outputs colorized warning" {
    run shlib::cwarnn "test message"
    [[ "${output}" == $'\033[33mwarning:\033[0m test message' ]]
}

@test "shlib::cinfo outputs colorized info" {
    run shlib::cinfo "test message"
    [[ "${output}" == $'\033[34minfo:\033[0m test message' ]]
}

@test "shlib::cinfon outputs colorized info" {
    run shlib::cinfon "test message"
    [[ "${output}" == $'\033[34minfo:\033[0m test message' ]]
}

@test "shlib::eerror outputs emoji error to stderr" {
    run shlib::eerror "test message"
    [[ "${output}" == "❌️  test message" ]]
}

@test "shlib::eerrorn outputs emoji error to stderr" {
    run shlib::eerrorn "test message"
    [[ "${output}" == "❌️  test message" ]]
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

@test "shlib::error with empty message" {
    run shlib::error ""
    [[ "${output}" == "error: " ]]
}

@test "shlib::warn with empty message" {
    run shlib::warn ""
    [[ "${output}" == "warning: " ]]
}

@test "shlib::info with empty message" {
    run shlib::info ""
    [[ "${output}" == "info: " ]]
}

@test "shlib::error with multiple arguments concatenates" {
    run shlib::error "a" "b" "c"
    [[ "${output}" == "error: a b c" ]]
}

@test "shlib::warn with multiple arguments concatenates" {
    run shlib::warn "a" "b" "c"
    [[ "${output}" == "warning: a b c" ]]
}

@test "shlib::info with multiple arguments concatenates" {
    run shlib::info "a" "b" "c"
    [[ "${output}" == "info: a b c" ]]
}

@test "shlib::error with special characters" {
    run shlib::error "line1\nline2"
    [[ "${output}" == *"line1"* ]]
}

@test "shlib::info with tab character" {
    run shlib::info $'tab\there'
    [[ "${output}" == "info: tab	here" ]]
}

@test "shlib::cerror with empty message" {
    run shlib::cerror ""
    [[ "${output}" == $'\033[31merror:\033[0m ' ]]
}

@test "shlib::cwarn with empty message" {
    run shlib::cwarn ""
    [[ "${output}" == $'\033[33mwarning:\033[0m ' ]]
}

@test "shlib::cinfo with empty message" {
    run shlib::cinfo ""
    [[ "${output}" == $'\033[34minfo:\033[0m ' ]]
}

@test "shlib::eerror with empty message" {
    run shlib::eerror ""
    [[ "${output}" == "❌️  " ]]
}
