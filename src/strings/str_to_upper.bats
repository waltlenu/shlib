@test "shlib::str_to_upper converts to uppercase" {
    run shlib::str_to_upper "hello"
    [[ "${output}" == "HELLO" ]]
}

@test "shlib::str_to_upper handles mixed case" {
    run shlib::str_to_upper "HeLLo WoRLd"
    [[ "${output}" == "HELLO WORLD" ]]
}

@test "shlib::str_to_upper preserves non-alpha characters" {
    run shlib::str_to_upper "hello123!"
    [[ "${output}" == "HELLO123!" ]]
}

@test "shlib::str_to_upper with empty string" {
    run shlib::str_to_upper ""
    [[ "${output}" == "" ]]
}
