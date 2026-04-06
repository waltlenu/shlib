@test "shlib::dt_now and dt_now_iso return consistent timestamps" {
    local unix_ts iso_ts
    unix_ts=$(shlib::dt_now)
    iso_ts=$(shlib::dt_now_iso)
    # Both should be from the same second (or very close)
    [[ -n "$unix_ts" ]]
    [[ -n "$iso_ts" ]]
    # ISO format should contain current year
    local year
    year=$(date +%Y)
    [[ "$iso_ts" == "$year"* ]]
}

@test "shlib::dt_now_iso ignores invalid argument and returns UTC" {
    run shlib::dt_now_iso invalid
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$ ]]
}

@test "shlib::dt_now_iso local returns local ISO format" {
    run shlib::dt_now_iso local
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}[+-][0-9]{2}:[0-9]{2}$ ]]
}

@test "shlib::dt_now_iso returns UTC ISO format" {
    run shlib::dt_now_iso
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$ ]]
}

@test "shlib::dt_now returns a timestamp" {
    run shlib::dt_now
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ ^[0-9]+$ ]]
}

@test "shlib::dt_now returns reasonable timestamp" {
    run shlib::dt_now
    # Should be after Jan 1, 2020 (1577836800)
    [[ "$output" -gt 1577836800 ]]
}
