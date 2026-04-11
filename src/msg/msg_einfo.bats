@test "shlib::msg_einfo outputs emoji info with timestamp" {
    run shlib::msg_einfo "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] ℹ️  test message" ]]
}

@test "shlib::msg_einfon outputs emoji info with timestamp" {
    run shlib::msg_einfon "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] ℹ️  test message" ]]
}
