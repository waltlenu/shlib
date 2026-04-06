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
