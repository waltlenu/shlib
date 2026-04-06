@test "shlib::dt_add adds days" {
    run shlib::dt_add 1000 1 days
    [[ "$output" == "87400" ]]
}

@test "shlib::dt_add adds hours" {
    run shlib::dt_add 1000 1 hours
    [[ "$output" == "4600" ]]
}

@test "shlib::dt_add adds minutes" {
    run shlib::dt_add 1000 1 minutes
    [[ "$output" == "1060" ]]
}

@test "shlib::dt_add adds seconds" {
    run shlib::dt_add 1000 60 seconds
    [[ "$output" == "1060" ]]
}

@test "shlib::dt_add adds weeks" {
    run shlib::dt_add 1000 1 weeks
    [[ "$output" == "605800" ]]
}

@test "shlib::dt_add handles singular unit: day" {
    run shlib::dt_add 1000 1 day
    [[ "$output" == "87400" ]]
}

@test "shlib::dt_add handles singular unit: hour" {
    run shlib::dt_add 1000 1 hour
    [[ "$output" == "4600" ]]
}

@test "shlib::dt_add handles singular unit: minute" {
    run shlib::dt_add 1000 1 minute
    [[ "$output" == "1060" ]]
}

@test "shlib::dt_add handles singular unit: second" {
    run shlib::dt_add 1000 60 second
    [[ "$output" == "1060" ]]
}

@test "shlib::dt_add handles singular unit: week" {
    run shlib::dt_add 1000 1 week
    [[ "$output" == "605800" ]]
}

@test "shlib::dt_add subtracts with negative amount" {
    run shlib::dt_add 1000 -1 hours
    [[ "$output" == "-2600" ]]
}

@test "shlib::dt_add unknown unit defaults to seconds" {
    run shlib::dt_add 1000 60 unknown
    [[ "$output" == "1060" ]]
}

@test "shlib::dt_add with large amounts" {
    run shlib::dt_add 0 365 days
    [[ "$output" == "31536000" ]]
}

@test "shlib::dt_add with zero amount" {
    run shlib::dt_add 1000 0 days
    [[ "$output" == "1000" ]]
}
