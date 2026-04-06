@test "shlib::str_repeat handles empty string" {
    run shlib::str_repeat "" 5
    [[ "${output}" == "" ]]
}

@test "shlib::str_repeat handles string with spaces" {
    run shlib::str_repeat "a b" 2
    [[ "${output}" == "a ba b" ]]
}

@test "shlib::str_repeat repeats string N times" {
    run shlib::str_repeat "ab" 3
    [[ "${output}" == "ababab" ]]
}

@test "shlib::str_repeat with count 0" {
    run shlib::str_repeat "hello" 0
    [[ "${output}" == "" ]]
}

@test "shlib::str_repeat with count 1" {
    run shlib::str_repeat "hello" 1
    [[ "${output}" == "hello" ]]
}

@test "shlib::str_repeat with default count" {
    run shlib::str_repeat "test"
    [[ "${output}" == "test" ]]
}

@test "shlib::str_repeat with negative count returns empty" {
    run shlib::str_repeat "hello" -1
    [[ "${output}" == "" ]]
}

@test "shlib::str_repeat with single character" {
    run shlib::str_repeat "-" 5
    [[ "${output}" == "-----" ]]
}
