@test "shlib::msg_cwarn outputs colorized warning with timestamp" {
    run shlib::msg_cwarn "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *$'] \033[33mwarning:\033[0m test message' ]]
}

@test "shlib::msg_cwarn with empty message" {
    run shlib::msg_cwarn ""
    check_timestamp_prefix "$output"
    [[ "${output}" == *$'] \033[33mwarning:\033[0m ' ]]
}

@test "shlib::msg_cwarnn outputs colorized warning with timestamp" {
    run shlib::msg_cwarnn "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *$'] \033[33mwarning:\033[0m test message' ]]
}
