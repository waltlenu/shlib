@test "shlib::str_toupper converts to uppercase" {
    run shlib::str_toupper "hello"
    [[ "${output}" == "HELLO" ]]
}

@test "shlib::str_toupper handles mixed case" {
    run shlib::str_toupper "HeLLo WoRLd"
    [[ "${output}" == "HELLO WORLD" ]]
}

@test "shlib::str_toupper preserves non-alpha characters" {
    run shlib::str_toupper "hello123!"
    [[ "${output}" == "HELLO123!" ]]
}

@test "shlib::str_toupper with empty string" {
    run shlib::str_toupper ""
    [[ "${output}" == "" ]]
}
