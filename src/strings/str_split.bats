@test "shlib::str_split handles empty string" {
    shlib::str_split result ""
    [[ ${#result[@]} -eq 0 ]]
}

@test "shlib::str_split handles leading separator" {
    shlib::str_split result ",a,b" ","
    [[ ${#result[@]} -eq 3 ]]
    [[ "${result[0]}" == "" ]]
    [[ "${result[1]}" == "a" ]]
    [[ "${result[2]}" == "b" ]]
}

@test "shlib::str_split handles multi-character separator" {
    shlib::str_split result "a::b::c" "::"
    [[ ${#result[@]} -eq 3 ]]
    [[ "${result[0]}" == "a" ]]
    [[ "${result[1]}" == "b" ]]
    [[ "${result[2]}" == "c" ]]
}

@test "shlib::str_split handles string with no separator" {
    shlib::str_split result "hello" ","
    [[ ${#result[@]} -eq 1 ]]
    [[ "${result[0]}" == "hello" ]]
}

@test "shlib::str_split handles trailing separator" {
    shlib::str_split result "a,b," ","
    [[ ${#result[@]} -eq 3 ]]
    [[ "${result[0]}" == "a" ]]
    [[ "${result[1]}" == "b" ]]
    [[ "${result[2]}" == "" ]]
}

@test "shlib::str_split splits by comma" {
    shlib::str_split result "a,b,c" ","
    # shellcheck disable=SC2154
    [[ ${#result[@]} -eq 3 ]]
    [[ "${result[0]}" == "a" ]]
    [[ "${result[1]}" == "b" ]]
    [[ "${result[2]}" == "c" ]]
}

@test "shlib::str_split uses space as default separator" {
    shlib::str_split result "hello world foo"
    [[ ${#result[@]} -eq 3 ]]
    [[ "${result[0]}" == "hello" ]]
    [[ "${result[1]}" == "world" ]]
    [[ "${result[2]}" == "foo" ]]
}

@test "shlib::str_split with consecutive separators" {
    shlib::str_split result "a,,b" ","
    [[ ${#result[@]} -eq 3 ]]
    [[ "${result[0]}" == "a" ]]
    [[ "${result[1]}" == "" ]]
    [[ "${result[2]}" == "b" ]]
}

@test "shlib::str_split with empty separator splits into characters" {
    shlib::str_split result "abc" ""
    [[ ${#result[@]} -eq 3 ]]
    [[ "${result[0]}" == "a" ]]
    [[ "${result[1]}" == "b" ]]
    [[ "${result[2]}" == "c" ]]
}

@test "shlib::str_split with separator at both ends" {
    shlib::str_split result ",a,b," ","
    [[ ${#result[@]} -eq 4 ]]
    [[ "${result[0]}" == "" ]]
    [[ "${result[1]}" == "a" ]]
    [[ "${result[2]}" == "b" ]]
    [[ "${result[3]}" == "" ]]
}
