@test "shlib::str_tolower converts to lowercase" {
    run shlib::str_tolower "HELLO"
    [[ "${output}" == "hello" ]]
}

@test "shlib::str_tolower handles mixed case" {
    run shlib::str_tolower "HeLLo WoRLd"
    [[ "${output}" == "hello world" ]]
}

@test "shlib::str_tolower preserves non-alpha characters" {
    run shlib::str_tolower "HELLO123!"
    [[ "${output}" == "hello123!" ]]
}

@test "shlib::str_tolower with empty string" {
    run shlib::str_tolower ""
    [[ "${output}" == "" ]]
}
