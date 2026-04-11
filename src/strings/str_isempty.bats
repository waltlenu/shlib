@test "shlib::str_isempty returns 0 for empty string" {
    shlib::str_isempty ""
}

@test "shlib::str_isempty returns 0 for mixed tabs and spaces" {
    shlib::str_isempty $'\t  \t  \t'
}

@test "shlib::str_isempty returns 0 for tabs only" {
    shlib::str_isempty $'\t\t'
}

@test "shlib::str_isempty returns 0 for whitespace-only string" {
    shlib::str_isempty "   "
}

@test "shlib::str_isempty returns 1 for non-empty string" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::str_isempty "hello"
}

@test "shlib::str_isempty returns 1 for string with content and whitespace" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::str_isempty "  hello  "
}
