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
