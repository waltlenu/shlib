@test "shlib::str_startswith full string match" {
    shlib::str_startswith "hello" "hello"
}

@test "shlib::str_startswith handles empty prefix" {
    shlib::str_startswith "hello" ""
}

@test "shlib::str_startswith returns 0 when prefix matches" {
    shlib::str_startswith "hello world" "hello"
}

@test "shlib::str_startswith returns 1 when prefix does not match" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::str_startswith "hello world" "world"
}
