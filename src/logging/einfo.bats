@test "shlib::einfo outputs emoji info with timestamp" {
    run shlib::einfo "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] ℹ️  test message" ]]
}

@test "shlib::einfon outputs emoji info with timestamp" {
    run shlib::einfon "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] ℹ️  test message" ]]
}
