@test "shlib::info outputs message with timestamp" {
    run shlib::info "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] info: test message" ]]
}

@test "shlib::info with empty message" {
    run shlib::info ""
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] info: " ]]
}

@test "shlib::info with multiple arguments concatenates" {
    run shlib::info "a" "b" "c"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] info: a b c" ]]
}

@test "shlib::info with tab character" {
    run shlib::info $'tab\there'
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] info: tab	here" ]]
}

@test "shlib::infon outputs message with timestamp" {
    run shlib::infon "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] info: test message" ]]
}
