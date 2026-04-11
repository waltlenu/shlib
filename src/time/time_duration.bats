@test "shlib::time_duration compact format" {
    run shlib::time_duration 90061 compact
    [[ "$output" == "1d1h1m1s" ]]
}

@test "shlib::time_duration days and minutes no hours" {
    # 1 day + 1 minute = 86460 seconds
    run shlib::time_duration 86460
    [[ "$output" == "1d 1m" ]]
}

@test "shlib::time_duration days and seconds only" {
    # 1 day + 1 second = 86401 seconds
    run shlib::time_duration 86401
    [[ "$output" == "1d 1s" ]]
}

@test "shlib::time_duration days only long format" {
    run shlib::time_duration 172800 long
    [[ "$output" == "2 days" ]]
}

@test "shlib::time_duration formats days" {
    run shlib::time_duration 90061
    [[ "$output" == "1d 1h 1m 1s" ]]
}

@test "shlib::time_duration formats hours" {
    run shlib::time_duration 3661
    [[ "$output" == "1h 1m 1s" ]]
}

@test "shlib::time_duration formats minutes and seconds" {
    run shlib::time_duration 90
    [[ "$output" == "1m 30s" ]]
}

@test "shlib::time_duration formats seconds only" {
    run shlib::time_duration 45
    [[ "$output" == "45s" ]]
}

@test "shlib::time_duration handles exactly one day" {
    run shlib::time_duration 86400
    [[ "$output" == "1d" ]]
}

@test "shlib::time_duration handles exactly one hour" {
    run shlib::time_duration 3600
    [[ "$output" == "1h" ]]
}

@test "shlib::time_duration handles exactly one minute" {
    run shlib::time_duration 60
    [[ "$output" == "1m" ]]
}

@test "shlib::time_duration handles large values (weeks)" {
    run shlib::time_duration 694861
    # 8 days, 1 hour, 1 minute, 1 second
    [[ "$output" == "8d 1h 1m 1s" ]]
}

@test "shlib::time_duration handles negative values compact" {
    run shlib::time_duration -90 compact
    [[ "$output" == "-1m30s" ]]
}

@test "shlib::time_duration handles negative values long" {
    run shlib::time_duration -90 long
    [[ "$output" == "-1 minute, 30 seconds" ]]
}

@test "shlib::time_duration handles negative values short" {
    run shlib::time_duration -90
    [[ "$output" == "-1m 30s" ]]
}

@test "shlib::time_duration handles zero compact" {
    run shlib::time_duration 0 compact
    [[ "$output" == "0s" ]]
}

@test "shlib::time_duration handles zero long" {
    run shlib::time_duration 0 long
    [[ "$output" == "0 seconds" ]]
}

@test "shlib::time_duration handles zero short" {
    run shlib::time_duration 0
    [[ "$output" == "0s" ]]
}

@test "shlib::time_duration hours and seconds no minutes" {
    # 1 hour + 1 second = 3601 seconds
    run shlib::time_duration 3601
    [[ "$output" == "1h 1s" ]]
}

@test "shlib::time_duration hours and seconds no minutes long" {
    run shlib::time_duration 3601 long
    [[ "$output" == "1 hour, 1 second" ]]
}

@test "shlib::time_duration long format singular" {
    run shlib::time_duration 90061 long
    [[ "$output" == "1 day, 1 hour, 1 minute, 1 second" ]]
}

@test "shlib::time_duration long format with plurals" {
    run shlib::time_duration 180122 long
    [[ "$output" == "2 days, 2 hours, 2 minutes, 2 seconds" ]]
}

@test "shlib::time_duration minutes only long format" {
    run shlib::time_duration 120 long
    [[ "$output" == "2 minutes" ]]
}

@test "shlib::time_duration omits zero components compact" {
    run shlib::time_duration 3600 compact
    [[ "$output" == "1h" ]]
}

@test "shlib::time_duration omits zero components long" {
    run shlib::time_duration 3600 long
    [[ "$output" == "1 hour" ]]
}

@test "shlib::time_duration omits zero components short" {
    run shlib::time_duration 3600
    [[ "$output" == "1h" ]]
}

@test "shlib::time_duration one second" {
    run shlib::time_duration 1
    [[ "$output" == "1s" ]]
}

@test "shlib::time_duration one second long format" {
    run shlib::time_duration 1 long
    [[ "$output" == "1 second" ]]
}

@test "shlib::time_duration unknown format defaults to short" {
    run shlib::time_duration 90 unknown
    [[ "$output" == "1m 30s" ]]
}

@test "shlib::time_duration with huge value (multiple years)" {
    # 2 years = 63072000 seconds
    run shlib::time_duration 63072000
    [[ "$status" -eq 0 ]]
    [[ "$output" == "730d" ]]
}

@test "shlib::time_duration with very large seconds value" {
    # 1 year worth of seconds = 31536000
    run shlib::time_duration 31536000
    [[ "$status" -eq 0 ]]
    [[ "$output" == "365d" ]]
}
