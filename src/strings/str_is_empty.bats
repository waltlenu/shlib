@test "shlib::str_is_empty returns 0 for empty string" {
    shlib::str_is_empty ""
}

@test "shlib::str_is_empty returns 0 for mixed tabs and spaces" {
    shlib::str_is_empty $'\t  \t  \t'
}

@test "shlib::str_is_empty returns 0 for tabs only" {
    shlib::str_is_empty $'\t\t'
}

@test "shlib::str_is_empty returns 0 for whitespace-only string" {
    shlib::str_is_empty "   "
}

@test "shlib::str_is_empty returns 1 for non-empty string" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::str_is_empty "hello"
}

@test "shlib::str_is_empty returns 1 for string with content and whitespace" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::str_is_empty "  hello  "
}
