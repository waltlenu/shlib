@test "shlib::msg_info outputs message with timestamp" {
    run shlib::msg_info "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] info: test message" ]]
}

@test "shlib::msg_info with empty message" {
    run shlib::msg_info ""
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] info: " ]]
}

@test "shlib::msg_info with multiple arguments concatenates" {
    run shlib::msg_info "a" "b" "c"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] info: a b c" ]]
}

@test "shlib::msg_info with tab character" {
    run shlib::msg_info $'tab\there'
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] info: tab	here" ]]
}

@test "shlib::msg_infon outputs message with timestamp" {
    run shlib::msg_infon "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] info: test message" ]]
}
