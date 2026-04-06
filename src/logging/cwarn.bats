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
