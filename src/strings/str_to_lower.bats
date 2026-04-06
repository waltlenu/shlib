@test "shlib::str_to_lower converts to lowercase" {
    run shlib::str_to_lower "HELLO"
    [[ "${output}" == "hello" ]]
}

@test "shlib::str_to_lower handles mixed case" {
    run shlib::str_to_lower "HeLLo WoRLd"
    [[ "${output}" == "hello world" ]]
}

@test "shlib::str_to_lower preserves non-alpha characters" {
    run shlib::str_to_lower "HELLO123!"
    [[ "${output}" == "hello123!" ]]
}

@test "shlib::str_to_lower with empty string" {
    run shlib::str_to_lower ""
    [[ "${output}" == "" ]]
}
