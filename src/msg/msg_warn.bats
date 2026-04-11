@test "shlib::msg_warn outputs with timestamp to stderr" {
    run shlib::msg_warn "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] warning: test message" ]]
}

@test "shlib::msg_warn with empty message" {
    run shlib::msg_warn ""
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] warning: " ]]
}

@test "shlib::msg_warn with multiple arguments concatenates" {
    run shlib::msg_warn "a" "b" "c"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] warning: a b c" ]]
}

@test "shlib::msg_warnn outputs with timestamp to stderr" {
    run shlib::msg_warnn "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] warning: test message" ]]
}
