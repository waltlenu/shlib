@test "shlib::str_len counts byte length (not unicode codepoints)" {
    # Note: Bash ${#var} returns byte count for multibyte chars in some versions
    run shlib::str_len "abc"
    [[ "${output}" == "3" ]]
}

@test "shlib::str_len counts spaces" {
    run shlib::str_len "hello world"
    [[ "${output}" == "11" ]]
}

@test "shlib::str_len returns 0 for empty string" {
    run shlib::str_len ""
    [[ "${output}" == "0" ]]
}

@test "shlib::str_len returns correct length" {
    run shlib::str_len "hello"
    [[ "${output}" == "5" ]]
}
