#!/usr/bin/env bats

setup() {
    load 'test_helper'
}

# Helper to check ISO8601 timestamp format at start of output
# Format: [YYYY-MM-DDTHH:MM:SS±HH:MM]
check_timestamp_prefix() {
    local output="$1"
    [[ "$output" =~ ^\[[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}[+-][0-9]{2}:[0-9]{2}\] ]]
}

@test "shlib::cerror outputs colorized error with timestamp to stderr" {
    run shlib::cerror "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *$'] \033[31merror:\033[0m test message' ]]
}

@test "shlib::cerror with empty message" {
    run shlib::cerror ""
    check_timestamp_prefix "$output"
    [[ "${output}" == *$'] \033[31merror:\033[0m ' ]]
}

@test "shlib::cerrorn outputs colorized error with timestamp to stderr" {
    run shlib::cerrorn "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *$'] \033[31merror:\033[0m test message' ]]
}

@test "shlib::cinfo outputs colorized info with timestamp" {
    run shlib::cinfo "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *$'] \033[34minfo:\033[0m test message' ]]
}

@test "shlib::cinfo with empty message" {
    run shlib::cinfo ""
    check_timestamp_prefix "$output"
    [[ "${output}" == *$'] \033[34minfo:\033[0m ' ]]
}

@test "shlib::cinfon outputs colorized info with timestamp" {
    run shlib::cinfon "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *$'] \033[34minfo:\033[0m test message' ]]
}

@test "shlib::cwarn outputs colorized warning with timestamp" {
    run shlib::cwarn "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *$'] \033[33mwarning:\033[0m test message' ]]
}

@test "shlib::cwarn with empty message" {
    run shlib::cwarn ""
    check_timestamp_prefix "$output"
    [[ "${output}" == *$'] \033[33mwarning:\033[0m ' ]]
}

@test "shlib::cwarnn outputs colorized warning with timestamp" {
    run shlib::cwarnn "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *$'] \033[33mwarning:\033[0m test message' ]]
}

@test "shlib::eerror outputs emoji error with timestamp to stderr" {
    run shlib::eerror "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] ❌️  test message" ]]
}

@test "shlib::eerror with empty message" {
    run shlib::eerror ""
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] ❌️  " ]]
}

@test "shlib::eerrorn outputs emoji error with timestamp to stderr" {
    run shlib::eerrorn "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] ❌️  test message" ]]
}

@test "shlib::einfo outputs emoji info with timestamp" {
    run shlib::einfo "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] ℹ️  test message" ]]
}

@test "shlib::einfon outputs emoji info with timestamp" {
    run shlib::einfon "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] ℹ️  test message" ]]
}

@test "shlib::error outputs with timestamp to stderr" {
    run shlib::error "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] error: test message" ]]
}

@test "shlib::error with empty message" {
    run shlib::error ""
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] error: " ]]
}

@test "shlib::error with multiple arguments concatenates" {
    run shlib::error "a" "b" "c"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] error: a b c" ]]
}

@test "shlib::error with special characters" {
    run shlib::error "line1\nline2"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"line1"* ]]
}

@test "shlib::errorn outputs with timestamp to stderr" {
    run shlib::errorn "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] error: test message" ]]
}

@test "shlib::ewarn outputs emoji warning with timestamp" {
    run shlib::ewarn "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] ⚠️  test message" ]]
}

@test "shlib::ewarnn outputs emoji warning with timestamp" {
    run shlib::ewarnn "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] ⚠️  test message" ]]
}

@test "shlib::info outputs message with timestamp" {
    run shlib::info "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] info: test message" ]]
}

@test "shlib::info with empty message" {
    run shlib::info ""
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] info: " ]]
}

@test "shlib::info with multiple arguments concatenates" {
    run shlib::info "a" "b" "c"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] info: a b c" ]]
}

@test "shlib::info with tab character" {
    run shlib::info $'tab\there'
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] info: tab	here" ]]
}

@test "shlib::infon outputs message with timestamp" {
    run shlib::infon "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] info: test message" ]]
}

@test "shlib::warn outputs with timestamp to stderr" {
    run shlib::warn "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] warning: test message" ]]
}

@test "shlib::warn with empty message" {
    run shlib::warn ""
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] warning: " ]]
}

@test "shlib::warn with multiple arguments concatenates" {
    run shlib::warn "a" "b" "c"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] warning: a b c" ]]
}

@test "shlib::warnn outputs with timestamp to stderr" {
    run shlib::warnn "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] warning: test message" ]]
}
