@test "shlib::time_isafter returns 0 when ts1 > ts2" {
    shlib::time_isafter 2000 1000
}

@test "shlib::time_isafter returns 1 when equal" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::time_isafter 1000 1000
}

@test "shlib::time_isafter returns 1 when ts1 < ts2" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::time_isafter 1000 2000
}

@test "shlib::time_isafter with negative timestamps" {
    shlib::time_isafter 0 -100
}

@test "shlib::time_isafter with zero timestamps" {
    shlib::time_isafter 1 0
}
