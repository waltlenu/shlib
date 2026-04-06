@test "shlib::str_padleft does not truncate longer strings" {
    run shlib::str_padleft "hello" 3 "0"
    [[ "${output}" == "hello" ]]
}

@test "shlib::str_padleft pads with default space" {
    run shlib::str_padleft "hi" 5
    [[ "${output}" == "   hi" ]]
}

@test "shlib::str_padleft pads with zeros" {
    run shlib::str_padleft "42" 5 "0"
    [[ "${output}" == "00042" ]]
}

@test "shlib::str_padleft with exact length string returns unchanged" {
    run shlib::str_padleft "hello" 5 "0"
    [[ "${output}" == "hello" ]]
}

@test "shlib::str_padleft with multi-character pad string" {
    run shlib::str_padleft "x" 5 "ab"
    # With multi-char pad, each iteration adds the whole string
    [[ "${#output}" -ge 5 ]]
    [[ "${output}" == *"x" ]]
}
