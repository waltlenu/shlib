@test "shlib::dt_today matches current date" {
    run shlib::dt_today
    local expected
    expected=$(date +%Y-%m-%d)
    [[ "$output" == "$expected" ]]
}

@test "shlib::dt_today returns YYYY-MM-DD format" {
    run shlib::dt_today
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]
}
