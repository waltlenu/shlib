@test "shlib::time_add adds days" {
    run shlib::time_add 1000 1 days
    [[ "$output" == "87400" ]]
}

@test "shlib::time_add adds hours" {
    run shlib::time_add 1000 1 hours
    [[ "$output" == "4600" ]]
}

@test "shlib::time_add adds minutes" {
    run shlib::time_add 1000 1 minutes
    [[ "$output" == "1060" ]]
}

@test "shlib::time_add adds seconds" {
    run shlib::time_add 1000 60 seconds
    [[ "$output" == "1060" ]]
}

@test "shlib::time_add adds weeks" {
    run shlib::time_add 1000 1 weeks
    [[ "$output" == "605800" ]]
}

@test "shlib::time_add handles singular unit: day" {
    run shlib::time_add 1000 1 day
    [[ "$output" == "87400" ]]
}

@test "shlib::time_add handles singular unit: hour" {
    run shlib::time_add 1000 1 hour
    [[ "$output" == "4600" ]]
}

@test "shlib::time_add handles singular unit: minute" {
    run shlib::time_add 1000 1 minute
    [[ "$output" == "1060" ]]
}

@test "shlib::time_add handles singular unit: second" {
    run shlib::time_add 1000 60 second
    [[ "$output" == "1060" ]]
}

@test "shlib::time_add handles singular unit: week" {
    run shlib::time_add 1000 1 week
    [[ "$output" == "605800" ]]
}

@test "shlib::time_add subtracts with negative amount" {
    run shlib::time_add 1000 -1 hours
    [[ "$output" == "-2600" ]]
}

@test "shlib::time_add unknown unit defaults to seconds" {
    run shlib::time_add 1000 60 unknown
    [[ "$output" == "1060" ]]
}

@test "shlib::time_add with large amounts" {
    run shlib::time_add 0 365 days
    [[ "$output" == "31536000" ]]
}

@test "shlib::time_add with zero amount" {
    run shlib::time_add 1000 0 days
    [[ "$output" == "1000" ]]
}
