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
