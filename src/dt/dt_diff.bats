@test "shlib::dt_diff handles negative differences" {
    run shlib::dt_diff 1000 2000
    [[ "$output" == "-1000" ]]
}

@test "shlib::dt_diff handles singular unit: day" {
    run shlib::dt_diff 172800 0 day
    [[ "$output" == "2" ]]
}

@test "shlib::dt_diff handles singular unit: hour" {
    run shlib::dt_diff 7200 0 hour
    [[ "$output" == "2" ]]
}

@test "shlib::dt_diff handles singular unit: minute" {
    run shlib::dt_diff 120 0 minute
    [[ "$output" == "2" ]]
}

@test "shlib::dt_diff handles singular unit: second" {
    run shlib::dt_diff 2000 1000 second
    [[ "$output" == "1000" ]]
}

@test "shlib::dt_diff handles singular unit: week" {
    run shlib::dt_diff 1209600 0 week
    [[ "$output" == "2" ]]
}

@test "shlib::dt_diff negative difference in days" {
    run shlib::dt_diff 0 172800 days
    [[ "$output" == "-2" ]]
}

@test "shlib::dt_diff performs integer division" {
    run shlib::dt_diff 90 0 minutes
    [[ "$output" == "1" ]]
}

@test "shlib::dt_diff returns difference in days" {
    run shlib::dt_diff 172800 0 days
    [[ "$output" == "2" ]]
}

@test "shlib::dt_diff returns difference in hours" {
    run shlib::dt_diff 7200 0 hours
    [[ "$output" == "2" ]]
}

@test "shlib::dt_diff returns difference in minutes" {
    run shlib::dt_diff 120 0 minutes
    [[ "$output" == "2" ]]
}

@test "shlib::dt_diff returns difference in seconds by default" {
    run shlib::dt_diff 2000 1000
    [[ "$output" == "1000" ]]
}

@test "shlib::dt_diff returns difference in weeks" {
    run shlib::dt_diff 1209600 0 weeks
    [[ "$output" == "2" ]]
}

@test "shlib::dt_diff unknown unit defaults to seconds" {
    run shlib::dt_diff 2000 1000 unknown
    [[ "$output" == "1000" ]]
}

@test "shlib::dt_diff with zero difference" {
    run shlib::dt_diff 1000 1000
    [[ "$output" == "0" ]]
}
