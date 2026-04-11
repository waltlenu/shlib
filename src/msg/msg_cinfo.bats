@test "shlib::msg_cinfo outputs colorized info with timestamp" {
    run shlib::msg_cinfo "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *$'] \033[34minfo:\033[0m test message' ]]
}

@test "shlib::msg_cinfo with empty message" {
    run shlib::msg_cinfo ""
    check_timestamp_prefix "$output"
    [[ "${output}" == *$'] \033[34minfo:\033[0m ' ]]
}

@test "shlib::msg_cinfon outputs colorized info with timestamp" {
    run shlib::msg_cinfon "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *$'] \033[34minfo:\033[0m test message' ]]
}
