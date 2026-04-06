@test "shlib::str_padright does not truncate longer strings" {
    run shlib::str_padright "hello" 3 "-"
    [[ "${output}" == "hello" ]]
}

@test "shlib::str_padright pads with dashes" {
    run shlib::str_padright "hi" 5 "-"
    [[ "${output}" == "hi---" ]]
}

@test "shlib::str_padright pads with default space" {
    run shlib::str_padright "hi" 5
    [[ "${output}" == "hi   " ]]
}

@test "shlib::str_padright with exact length string returns unchanged" {
    run shlib::str_padright "hello" 5 "-"
    [[ "${output}" == "hello" ]]
}

@test "shlib::str_padright with multi-character pad string" {
    run shlib::str_padright "x" 5 "ab"
    [[ "${#output}" -ge 5 ]]
    [[ "${output}" == "x"* ]]
}
