@test "shlib::time_fromunix formats timestamp as date" {
    run shlib::time_fromunix 1704067200 "%Y-%m-%d"
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]
}

@test "shlib::time_fromunix handles epoch zero" {
    run shlib::time_fromunix 0 "%Y"
    [[ "$status" -eq 0 ]]
    [[ "$output" == "1970" ]]
}

@test "shlib::time_fromunix handles full datetime format" {
    run shlib::time_fromunix 1704067200 "%Y-%m-%d %H:%M:%S"
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}\ [0-9]{2}:[0-9]{2}:[0-9]{2}$ ]]
}

@test "shlib::time_fromunix handles hour format" {
    run shlib::time_fromunix 1704067200 "%H"
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ ^[0-9]{2}$ ]]
}

@test "shlib::time_fromunix handles month name format" {
    run shlib::time_fromunix 1704067200 "%B"
    [[ "$status" -eq 0 ]]
    [[ -n "$output" ]]
}

@test "shlib::time_fromunix handles negative timestamp" {
    run shlib::time_fromunix -86400 "%Y"
    [[ "$status" -eq 0 ]]
    [[ "$output" == "1969" ]]
}

@test "shlib::time_fromunix handles weekday format" {
    run shlib::time_fromunix 1704067200 "%A"
    [[ "$status" -eq 0 ]]
    [[ -n "$output" ]]
}

@test "shlib::time_fromunix returns error for invalid timestamp" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::time_fromunix "invalid" "%Y-%m-%d"
}

@test "shlib::time_fromunix with very large future timestamp" {
    # Year 2100: 4102444800
    run shlib::time_fromunix 4102444800 "%Y"
    [[ "$status" -eq 0 ]]
    [[ "$output" == "2100" ]]
}
