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
