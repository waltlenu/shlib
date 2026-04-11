@test "shlib::time_elapsed returns elapsed time short format" {
    local start
    start=$(shlib::time_now)
    run shlib::time_elapsed "$start"
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ ^[0-9]+s$ ]]
}

@test "shlib::time_elapsed with compact format" {
    local start
    start=$(shlib::time_now)
    run shlib::time_elapsed "$start" compact
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ ^[0-9]+s$ ]]
}

@test "shlib::time_elapsed with future timestamp long format" {
    local start
    start=$(($(shlib::time_now) + 90))
    run shlib::time_elapsed "$start" long
    [[ "$status" -eq 0 ]]
    [[ "$output" == "-1 minute, 30 seconds" ]]
}

@test "shlib::time_elapsed with future timestamp shows negative" {
    local start
    start=$(($(shlib::time_now) + 90))
    run shlib::time_elapsed "$start"
    [[ "$status" -eq 0 ]]
    [[ "$output" == "-1m 30s" ]]
}

@test "shlib::time_elapsed with long format" {
    local start
    start=$(shlib::time_now)
    run shlib::time_elapsed "$start" long
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ second ]]
}

@test "shlib::time_elapsed with past timestamp" {
    local start
    start=$(($(shlib::time_now) - 3661))
    run shlib::time_elapsed "$start"
    [[ "$status" -eq 0 ]]
    [[ "$output" == "1h 1m 1s" ]]
}
