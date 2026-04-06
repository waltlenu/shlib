@test "shlib::dt_elapsed returns elapsed time short format" {
    local start
    start=$(shlib::dt_now)
    run shlib::dt_elapsed "$start"
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ ^[0-9]+s$ ]]
}

@test "shlib::dt_elapsed with compact format" {
    local start
    start=$(shlib::dt_now)
    run shlib::dt_elapsed "$start" compact
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ ^[0-9]+s$ ]]
}

@test "shlib::dt_elapsed with future timestamp long format" {
    local start
    start=$(($(shlib::dt_now) + 90))
    run shlib::dt_elapsed "$start" long
    [[ "$status" -eq 0 ]]
    [[ "$output" == "-1 minute, 30 seconds" ]]
}

@test "shlib::dt_elapsed with future timestamp shows negative" {
    local start
    start=$(($(shlib::dt_now) + 90))
    run shlib::dt_elapsed "$start"
    [[ "$status" -eq 0 ]]
    [[ "$output" == "-1m 30s" ]]
}

@test "shlib::dt_elapsed with long format" {
    local start
    start=$(shlib::dt_now)
    run shlib::dt_elapsed "$start" long
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ second ]]
}

@test "shlib::dt_elapsed with past timestamp" {
    local start
    start=$(($(shlib::dt_now) - 3661))
    run shlib::dt_elapsed "$start"
    [[ "$status" -eq 0 ]]
    [[ "$output" == "1h 1m 1s" ]]
}
