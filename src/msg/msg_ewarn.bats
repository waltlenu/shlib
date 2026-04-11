@test "shlib::msg_ewarn outputs emoji warning with timestamp" {
    run shlib::msg_ewarn "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] ⚠️  test message" ]]
}

@test "shlib::msg_ewarnn outputs emoji warning with timestamp" {
    run shlib::msg_ewarnn "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] ⚠️  test message" ]]
}
