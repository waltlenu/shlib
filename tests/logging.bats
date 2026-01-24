#!/usr/bin/env bats

setup() {
    load 'test_helper'
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
