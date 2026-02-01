#!/usr/bin/env bats

setup() {
    load 'test_helper'
}

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

@test "shlib::dt_duration compact format" {
    run shlib::dt_duration 90061 compact
    [[ "$output" == "1d1h1m1s" ]]
}

@test "shlib::dt_duration days and minutes no hours" {
    # 1 day + 1 minute = 86460 seconds
    run shlib::dt_duration 86460
    [[ "$output" == "1d 1m" ]]
}

@test "shlib::dt_duration days and seconds only" {
    # 1 day + 1 second = 86401 seconds
    run shlib::dt_duration 86401
    [[ "$output" == "1d 1s" ]]
}

@test "shlib::dt_duration days only long format" {
    run shlib::dt_duration 172800 long
    [[ "$output" == "2 days" ]]
}

@test "shlib::dt_duration formats days" {
    run shlib::dt_duration 90061
    [[ "$output" == "1d 1h 1m 1s" ]]
}

@test "shlib::dt_duration formats hours" {
    run shlib::dt_duration 3661
    [[ "$output" == "1h 1m 1s" ]]
}

@test "shlib::dt_duration formats minutes and seconds" {
    run shlib::dt_duration 90
    [[ "$output" == "1m 30s" ]]
}

@test "shlib::dt_duration formats seconds only" {
    run shlib::dt_duration 45
    [[ "$output" == "45s" ]]
}

@test "shlib::dt_duration handles exactly one day" {
    run shlib::dt_duration 86400
    [[ "$output" == "1d" ]]
}

@test "shlib::dt_duration handles exactly one hour" {
    run shlib::dt_duration 3600
    [[ "$output" == "1h" ]]
}

@test "shlib::dt_duration handles exactly one minute" {
    run shlib::dt_duration 60
    [[ "$output" == "1m" ]]
}

@test "shlib::dt_duration handles large values (weeks)" {
    run shlib::dt_duration 694861
    # 8 days, 1 hour, 1 minute, 1 second
    [[ "$output" == "8d 1h 1m 1s" ]]
}

@test "shlib::dt_duration handles negative values compact" {
    run shlib::dt_duration -90 compact
    [[ "$output" == "-1m30s" ]]
}

@test "shlib::dt_duration handles negative values long" {
    run shlib::dt_duration -90 long
    [[ "$output" == "-1 minute, 30 seconds" ]]
}

@test "shlib::dt_duration handles negative values short" {
    run shlib::dt_duration -90
    [[ "$output" == "-1m 30s" ]]
}

@test "shlib::dt_duration handles zero compact" {
    run shlib::dt_duration 0 compact
    [[ "$output" == "0s" ]]
}

@test "shlib::dt_duration handles zero long" {
    run shlib::dt_duration 0 long
    [[ "$output" == "0 seconds" ]]
}

@test "shlib::dt_duration handles zero short" {
    run shlib::dt_duration 0
    [[ "$output" == "0s" ]]
}

@test "shlib::dt_duration hours and seconds no minutes" {
    # 1 hour + 1 second = 3601 seconds
    run shlib::dt_duration 3601
    [[ "$output" == "1h 1s" ]]
}

@test "shlib::dt_duration hours and seconds no minutes long" {
    run shlib::dt_duration 3601 long
    [[ "$output" == "1 hour, 1 second" ]]
}

@test "shlib::dt_duration long format singular" {
    run shlib::dt_duration 90061 long
    [[ "$output" == "1 day, 1 hour, 1 minute, 1 second" ]]
}

@test "shlib::dt_duration long format with plurals" {
    run shlib::dt_duration 180122 long
    [[ "$output" == "2 days, 2 hours, 2 minutes, 2 seconds" ]]
}

@test "shlib::dt_duration minutes only long format" {
    run shlib::dt_duration 120 long
    [[ "$output" == "2 minutes" ]]
}

@test "shlib::dt_duration omits zero components compact" {
    run shlib::dt_duration 3600 compact
    [[ "$output" == "1h" ]]
}

@test "shlib::dt_duration omits zero components long" {
    run shlib::dt_duration 3600 long
    [[ "$output" == "1 hour" ]]
}

@test "shlib::dt_duration omits zero components short" {
    run shlib::dt_duration 3600
    [[ "$output" == "1h" ]]
}

@test "shlib::dt_duration one second" {
    run shlib::dt_duration 1
    [[ "$output" == "1s" ]]
}

@test "shlib::dt_duration one second long format" {
    run shlib::dt_duration 1 long
    [[ "$output" == "1 second" ]]
}

@test "shlib::dt_duration unknown format defaults to short" {
    run shlib::dt_duration 90 unknown
    [[ "$output" == "1m 30s" ]]
}

@test "shlib::dt_duration with huge value (multiple years)" {
    # 2 years = 63072000 seconds
    run shlib::dt_duration 63072000
    [[ "$status" -eq 0 ]]
    [[ "$output" == "730d" ]]
}

@test "shlib::dt_duration with very large seconds value" {
    # 1 year worth of seconds = 31536000
    run shlib::dt_duration 31536000
    [[ "$status" -eq 0 ]]
    [[ "$output" == "365d" ]]
}

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

@test "shlib::dt_is_after returns 0 when ts1 > ts2" {
    shlib::dt_is_after 2000 1000
}

@test "shlib::dt_is_after returns 1 when equal" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::dt_is_after 1000 1000
}

@test "shlib::dt_is_after returns 1 when ts1 < ts2" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::dt_is_after 1000 2000
}

@test "shlib::dt_is_after with negative timestamps" {
    shlib::dt_is_after 0 -100
}

@test "shlib::dt_is_after with zero timestamps" {
    shlib::dt_is_after 1 0
}

@test "shlib::dt_is_before returns 0 when ts1 < ts2" {
    shlib::dt_is_before 1000 2000
}

@test "shlib::dt_is_before returns 1 when equal" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::dt_is_before 1000 1000
}

@test "shlib::dt_is_before returns 1 when ts1 > ts2" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::dt_is_before 2000 1000
}

@test "shlib::dt_is_before with negative timestamps" {
    shlib::dt_is_before -100 0
}

@test "shlib::dt_is_before with zero timestamps" {
    shlib::dt_is_before 0 1
}

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

@test "shlib::dt_today matches current date" {
    run shlib::dt_today
    local expected
    expected=$(date +%Y-%m-%d)
    [[ "$output" == "$expected" ]]
}

@test "shlib::dt_today returns YYYY-MM-DD format" {
    run shlib::dt_today
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]
}
