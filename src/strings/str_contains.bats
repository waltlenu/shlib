@test "shlib::str_contains empty string in empty string" {
    shlib::str_contains "" ""
}

@test "shlib::str_contains handles empty substring" {
    shlib::str_contains "hello" ""
}

@test "shlib::str_contains returns 0 when substring found" {
    shlib::str_contains "hello world" "world"
}

@test "shlib::str_contains returns 1 when substring not found" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::str_contains "hello world" "foo"
}

@test "shlib::str_contains string equals substring" {
    shlib::str_contains "hello" "hello"
}
