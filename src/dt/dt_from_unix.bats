@test "shlib::dt_from_unix formats timestamp as date" {
    run shlib::dt_from_unix 1704067200 "%Y-%m-%d"
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]
}

@test "shlib::dt_from_unix handles epoch zero" {
    run shlib::dt_from_unix 0 "%Y"
    [[ "$status" -eq 0 ]]
    [[ "$output" == "1970" ]]
}

@test "shlib::dt_from_unix handles full datetime format" {
    run shlib::dt_from_unix 1704067200 "%Y-%m-%d %H:%M:%S"
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}\ [0-9]{2}:[0-9]{2}:[0-9]{2}$ ]]
}

@test "shlib::dt_from_unix handles hour format" {
    run shlib::dt_from_unix 1704067200 "%H"
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ ^[0-9]{2}$ ]]
}

@test "shlib::dt_from_unix handles month name format" {
    run shlib::dt_from_unix 1704067200 "%B"
    [[ "$status" -eq 0 ]]
    [[ -n "$output" ]]
}

@test "shlib::dt_from_unix handles negative timestamp" {
    run shlib::dt_from_unix -86400 "%Y"
    [[ "$status" -eq 0 ]]
    [[ "$output" == "1969" ]]
}

@test "shlib::dt_from_unix handles weekday format" {
    run shlib::dt_from_unix 1704067200 "%A"
    [[ "$status" -eq 0 ]]
    [[ -n "$output" ]]
}

@test "shlib::dt_from_unix returns error for invalid timestamp" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::dt_from_unix "invalid" "%Y-%m-%d"
}

@test "shlib::dt_from_unix with very large future timestamp" {
    # Year 2100: 4102444800
    run shlib::dt_from_unix 4102444800 "%Y"
    [[ "$status" -eq 0 ]]
    [[ "$output" == "2100" ]]
}
