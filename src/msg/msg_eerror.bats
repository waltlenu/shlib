@test "shlib::msg_eerror outputs emoji error with timestamp to stderr" {
    run shlib::msg_eerror "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] ❌️  test message" ]]
}

@test "shlib::msg_eerror with empty message" {
    run shlib::msg_eerror ""
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] ❌️  " ]]
}

@test "shlib::msg_eerrorn outputs emoji error with timestamp to stderr" {
    run shlib::msg_eerrorn "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] ❌️  test message" ]]
}
