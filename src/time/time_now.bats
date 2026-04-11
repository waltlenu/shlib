@test "shlib::time_now returns a timestamp" {
    run shlib::time_now
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ ^[0-9]+$ ]]
}

@test "shlib::time_now returns reasonable timestamp" {
    run shlib::time_now
    # Should be after Jan 1, 2020 (1577836800)
    [[ "$output" -gt 1577836800 ]]
}
