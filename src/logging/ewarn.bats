@test "shlib::ewarn outputs emoji warning with timestamp" {
    run shlib::ewarn "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] ⚠️  test message" ]]
}

@test "shlib::ewarnn outputs emoji warning with timestamp" {
    run shlib::ewarnn "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] ⚠️  test message" ]]
}
