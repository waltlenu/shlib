@test "shlib::warn outputs with timestamp to stderr" {
    run shlib::warn "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] warning: test message" ]]
}

@test "shlib::warn with empty message" {
    run shlib::warn ""
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] warning: " ]]
}

@test "shlib::warn with multiple arguments concatenates" {
    run shlib::warn "a" "b" "c"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] warning: a b c" ]]
}

@test "shlib::warnn outputs with timestamp to stderr" {
    run shlib::warnn "test message"
    check_timestamp_prefix "$output"
    [[ "${output}" == *"] warning: test message" ]]
}
