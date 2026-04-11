check_timestamp_prefix() {
    local output="$1"
    [[ "$output" =~ ^\[[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}[+-][0-9]{2}:[0-9]{2}\] ]]
}

@test "shlib::msg_cerror outputs colorized error with timestamp to stderr" {
    run shlib::msg_cerror "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *$'] \033[31merror:\033[0m test message' ]]
}

@test "shlib::msg_cerror with empty message" {
    run shlib::msg_cerror ""
    check_timestamp_prefix "$output"
    [[ "${output}" == *$'] \033[31merror:\033[0m ' ]]
}

@test "shlib::msg_cerrorn outputs colorized error with timestamp to stderr" {
    run shlib::msg_cerrorn "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *$'] \033[31merror:\033[0m test message' ]]
}
