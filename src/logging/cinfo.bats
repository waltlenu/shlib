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
