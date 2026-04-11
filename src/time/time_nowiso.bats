@test "shlib::time_now and time_nowiso return consistent timestamps" {
    local unix_ts iso_ts
    unix_ts=$(shlib::time_now)
    iso_ts=$(shlib::time_nowiso)
    # Both should be from the same second (or very close)
    [[ -n "$unix_ts" ]]
    [[ -n "$iso_ts" ]]
    # ISO format should contain current year
    local year
    year=$(date +%Y)
    [[ "$iso_ts" == "$year"* ]]
}

@test "shlib::time_nowiso ignores invalid argument and returns UTC" {
    run shlib::time_nowiso invalid
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$ ]]
}

@test "shlib::time_nowiso local returns local ISO format" {
    run shlib::time_nowiso local
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}[+-][0-9]{2}:[0-9]{2}$ ]]
}

@test "shlib::time_nowiso returns UTC ISO format" {
    run shlib::time_nowiso
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$ ]]
}
