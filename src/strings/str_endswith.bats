@test "shlib::str_endswith full string match" {
    shlib::str_endswith "hello" "hello"
}

@test "shlib::str_endswith handles empty suffix" {
    shlib::str_endswith "hello" ""
}

@test "shlib::str_endswith returns 0 when suffix matches" {
    shlib::str_endswith "hello world" "world"
}

@test "shlib::str_endswith returns 1 when suffix does not match" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::str_endswith "hello world" "hello"
}
