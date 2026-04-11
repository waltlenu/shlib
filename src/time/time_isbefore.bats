@test "shlib::time_isbefore returns 0 when ts1 < ts2" {
    shlib::time_isbefore 1000 2000
}

@test "shlib::time_isbefore returns 1 when equal" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::time_isbefore 1000 1000
}

@test "shlib::time_isbefore returns 1 when ts1 > ts2" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::time_isbefore 2000 1000
}

@test "shlib::time_isbefore with negative timestamps" {
    shlib::time_isbefore -100 0
}

@test "shlib::time_isbefore with zero timestamps" {
    shlib::time_isbefore 0 1
}
