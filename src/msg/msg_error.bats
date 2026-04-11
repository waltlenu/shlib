@test "shlib::msg_error outputs with timestamp to stderr" {
    run shlib::msg_error "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] error: test message" ]]
}

@test "shlib::msg_error with empty message" {
    run shlib::msg_error ""
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] error: " ]]
}

@test "shlib::msg_error with multiple arguments concatenates" {
    run shlib::msg_error "a" "b" "c"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] error: a b c" ]]
}

@test "shlib::msg_error with special characters" {
    run shlib::msg_error "line1\nline2"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"line1"* ]]
}

@test "shlib::msg_errorn outputs with timestamp to stderr" {
    run shlib::msg_errorn "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] error: test message" ]]
}
